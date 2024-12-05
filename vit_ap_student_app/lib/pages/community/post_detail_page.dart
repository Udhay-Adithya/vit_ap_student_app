import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:vit_ap_student_app/pages/community/comment_page.dart';
import '../../models/community.dart';
import '../../utils/provider/community_provider.dart';

class PostDetailPage extends ConsumerStatefulWidget {
  final Post post;
  final String userId;

  const PostDetailPage({super.key, required this.post, required this.userId});

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends ConsumerState<PostDetailPage> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  Future<void> _refreshPosts() async {
    await ref.read(postsProvider.notifier).fetchPosts();
  }

  void _addCommentLike(
      WidgetRef ref, String postId, String commentId, String userId) async {
    await ref
        .read(postsProvider.notifier)
        .likeComment(postId, commentId, userId);
  }

  void _editPost(BuildContext context, Post post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Post'),
        content: TextField(
          controller: TextEditingController(text: post.content),
          decoration: const InputDecoration(
            hintText: 'Edit your post...',
          ),
          onChanged: (value) {
            post = post.copyWith(content: value);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(postsProvider.notifier).updatePost(post);
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deletePost(BuildContext context, String postId) async {
    final confirmation = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmation == true) {
      await ref.read(postsProvider.notifier).deletePost(postId);
      Navigator.of(context).pop(); // Navigate back
    }
  }

  @override
  Widget build(BuildContext context) {
    final post =
        ref.watch(postsProvider).firstWhere((Post p) => p.id == widget.post.id);
    final isPostOwner = widget.userId ==
        post.username; // Ensure this matches your criteria for ownership

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
      ),
      bottomNavigationBar: BottomAppBar(
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              PageTransition(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                type: PageTransitionType.fade,
                child: AddCommentPage(
                  post: post,
                  userID: widget.userId,
                ),
              ),
            );
          },
          child: TextField(
            enabled: false,
            readOnly: true,
            controller: commentController,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.send_rounded,
                ),
                onPressed: null,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              contentPadding: EdgeInsets.all(8),
              hintText: 'Add a comment',
              hintStyle: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () => _refreshPosts(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Post header
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  color: Theme.of(context).colorScheme.secondary,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage(post.profileImagePath),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.username,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                Text(
                                  _formatTimestamp(post.timestamp),
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          if (isPostOwner)
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                  ),
                                  onPressed: () => _editPost(context, post),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                  ),
                                  onPressed: () =>
                                      _deletePost(context, post.id),
                                ),
                              ],
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SelectableText(
                        post.content,
                        textAlign: TextAlign.start,
                        style: TextStyle(),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildInteractionButton(
                            context,
                            ref,
                            icon: Icons.thumb_up,
                            count: post.likes,
                            isActive: post.likedBy.contains(widget.userId),
                            onPressed: () =>
                                _likePost(ref, post.id, widget.userId),
                          ),
                          _buildInteractionButton(
                            context,
                            ref,
                            icon: Icons.thumb_down,
                            count: post.dislikes,
                            isActive: post.dislikedBy.contains(widget.userId),
                            onPressed: () =>
                                _dislikePost(ref, post.id, widget.userId),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                padding: EdgeInsets.all(0.0),
                margin: EdgeInsets.all(0.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(9.0),
                ),
                child: Column(
                  children: post.comments
                      .map(
                        (comment) => ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                AssetImage(comment.profileImagePath),
                          ),
                          title: Text(comment.userId),
                          subtitle: SelectableText(comment.content),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.favorite_border),
                                onPressed: () => _addCommentLike(
                                  ref,
                                  post.id,
                                  comment.id,
                                  widget.userId,
                                ),
                              ),
                              Text(comment.likes.toString()),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInteractionButton(
    BuildContext context,
    WidgetRef ref, {
    required IconData icon,
    required int count,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    return Row(
      children: [
        IconButton(
          icon: Icon(icon,
              color: isActive ? Theme.of(context).colorScheme.primary : null),
          onPressed: onPressed,
        ),
        Text(count.toString()),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return timeago.format(timestamp);
  }

  void _likePost(WidgetRef ref, String postId, String userId) async {
    await ref.read(postsProvider.notifier).likePost(postId, userId);
  }

  void _dislikePost(WidgetRef ref, String postId, String userId) async {
    await ref.read(postsProvider.notifier).dislikePost(postId, userId);
  }
}
