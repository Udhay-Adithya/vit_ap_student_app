import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/community.dart';
import '../../pages/community/sort_criteria.dart';

final postsProvider = StateNotifierProvider<PostsNotifier, List<Post>>((ref) {
  return PostsNotifier();
});

class PostsNotifier extends StateNotifier<List<Post>> {
  PostsNotifier() : super([]) {
    fetchPosts();
  }

  final CollectionReference _postsRef =
      FirebaseFirestore.instance.collection('posts');
  DocumentSnapshot? _lastFetchedPost;
  bool _hasMorePosts = true;
  final int _postsPerPage = 10;

  Future<void> fetchPosts() async {
    print("Fetching initial posts");
    try {
      final query =
          _postsRef.orderBy('timestamp', descending: true).limit(_postsPerPage);
      final snapshot = await query.get();
      print("Fetched ${snapshot.docs.length} initial posts");

      final posts = await Future.wait(snapshot.docs.map((doc) async {
        final postData = doc.data() as Map<String, dynamic>;
        final commentsSnapshot =
            await doc.reference.collection('comments').get();
        final comments = commentsSnapshot.docs.map((commentDoc) {
          final commentData = commentDoc.data();
          return Comment.fromJson(commentData).copyWith(id: commentDoc.id);
        }).toList();
        return Post.fromJson(postData)
          ..id = doc.id
          ..comments = comments;
      }).toList());

      if (snapshot.docs.isNotEmpty) {
        _lastFetchedPost = snapshot.docs.last;
      } else {
        _hasMorePosts = false;
      }

      state = posts;
    } catch (e) {
      print('Error fetching posts: $e');
    }
  }

  Future<void> fetchMorePosts() async {
    if (!_hasMorePosts || _lastFetchedPost == null) return;

    print("Fetching more posts");
    try {
      final query = _postsRef
          .orderBy('timestamp', descending: true)
          .startAfterDocument(_lastFetchedPost!)
          .limit(_postsPerPage);
      final snapshot = await query.get();
      print("Fetched ${snapshot.docs.length} more posts");

      if (snapshot.docs.isEmpty) {
        _hasMorePosts = false;
      } else {
        final newPosts = await Future.wait(snapshot.docs.map((doc) async {
          final postData = doc.data() as Map<String, dynamic>;
          final commentsSnapshot =
              await doc.reference.collection('comments').get();
          final comments = commentsSnapshot.docs.map((commentDoc) {
            final commentData = commentDoc.data();
            return Comment.fromJson(commentData).copyWith(id: commentDoc.id);
          }).toList();
          return Post.fromJson(postData)
            ..id = doc.id
            ..comments = comments;
        }).toList());

        _lastFetchedPost = snapshot.docs.last;
        state = [...state, ...newPosts];
      }
    } catch (e) {
      print('Error fetching more posts: $e');
    }
  }

  Future<void> addPost(Post post) async {
    final docRef =
        await FirebaseFirestore.instance.collection('posts').add(post.toJson());
    state = [...state, post.copyWith(id: docRef.id)];
  }

  Future<void> deletePost(String postId) async {
    await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
    state = state.where((post) => post.id != postId).toList();
  }

  Future<void> updatePost(Post post) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(post.id)
        .update(post.toJson());
    state = state.map((p) => p.id == post.id ? post : p).toList();
  }

  void sortPosts(SortCriteria criteria) {
    if (criteria == SortCriteria.mostLiked) {
      state = [...state]..sort((a, b) => b.likes.compareTo(a.likes));
    } else if (criteria == SortCriteria.mostRecent) {
      state = [...state]..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    }
  }

  Future<void> likePost(String postId, String userId) async {
    try {
      final postIndex = state.indexWhere((post) => post.id == postId);
      if (postIndex == -1) {
        print('Post not found');
        return; // Return early if post not found
      }

      final post = state[postIndex];
      final isAlreadyLiked = post.likedBy.contains(userId);
      final isAlreadyDisliked = post.dislikedBy.contains(userId);

      if (isAlreadyLiked) {
        // Unlike the post
        post.likedBy.remove(userId);
        post.likes -= 1;
      } else {
        // Like the post
        post.likedBy.add(userId);
        post.likes += 1;
        // Ensure no double counting of dislikes
        if (isAlreadyDisliked) {
          post.dislikedBy.remove(userId);
          post.dislikes -= 1;
        }
      }
      await _postsRef.doc(postId).update(post.toJson());
      state = [...state];
    } catch (e) {
      print('Error liking post: $e');
    }
  }

  Future<void> dislikePost(String postId, String userId) async {
    try {
      final postIndex = state.indexWhere((post) => post.id == postId);
      if (postIndex != -1) {
        final post = state[postIndex];
        final isAlreadyDisliked = post.dislikedBy.contains(userId);
        final isAlreadyLiked = post.likedBy.contains(userId);

        if (isAlreadyDisliked) {
          // Remove dislike from the post
          post.dislikedBy.remove(userId);
          post.dislikes -= 1;
        } else {
          // Dislike the post
          post.dislikedBy.add(userId);
          post.dislikes += 1;
          // Ensure no double counting of likes
          if (isAlreadyLiked) {
            post.likedBy.remove(userId);
            post.likes -= 1;
          }
        }
        await _postsRef.doc(postId).update(post.toJson());
        state = [...state];
      }
    } catch (e) {
      print('Error disliking post: $e');
    }
  }

  Future<void> addComment(String postId, Comment comment) async {
    try {
      final postIndex = state.indexWhere((post) => post.id == postId);
      if (postIndex != -1) {
        // Add the comment to the subcollection
        final commentDocRef = await _postsRef
            .doc(postId)
            .collection('comments')
            .add(comment.toJson());
        final newComment = comment.copyWith(id: commentDocRef.id);

        // Update the post with the new comment
        final post = state[postIndex];
        final updatedPost =
            post.copyWith(comments: [...post.comments, newComment]);
        await _postsRef.doc(postId).update(updatedPost.toJson());

        // Update the local state with the new comment
        state = [
          for (final p in state)
            if (p.id == postId) updatedPost else p
        ];
      }
    } catch (e) {
      print('Error adding comment: $e');
    }
  }

  Future<void> likeComment(
      String postId, String commentId, String userId) async {
    try {
      final postIndex = state.indexWhere((post) => post.id == postId);
      if (postIndex != -1) {
        final post = state[postIndex];
        final commentIndex =
            post.comments.indexWhere((comment) => comment.id == commentId);
        if (commentIndex != -1) {
          final comment = post.comments[commentIndex];
          if (!comment.likedBy.contains(userId)) {
            comment.likedBy.add(userId);
            comment.likes += 1;
            await _postsRef
                .doc(postId)
                .collection('comments')
                .doc(commentId)
                .update(comment.toJson());
            state = [...state];
          }
        }
      }
    } catch (e) {
      print('Error liking comment: $e');
    }
  }
}
