import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:filter_profanity/filter_profanity.dart'; // Import the package
import '../../models/community.dart';
import '../../utils/provider/community_provider.dart';

class AddCommentPage extends ConsumerStatefulWidget {
  final Post? post;
  final String? userID;

  const AddCommentPage({super.key, this.post, this.userID});

  @override
  ConsumerState<AddCommentPage> createState() => _AddCommentPageState();
}

class _AddCommentPageState extends ConsumerState<AddCommentPage> {
  final commentController = TextEditingController();
  bool _hasProfanity = false;

  Future<void> _refreshPosts() async {
    await ref.read(postsProvider.notifier).fetchPosts();
  }

  Future<void> _addComment(
      WidgetRef ref, String postId, String commentText, String userID) async {
    if (commentText.trim().isEmpty) return;

    // Check for profanity
    _hasProfanity = hasProfanity(commentText,
        offensiveWords: englishOffensiveWords + hindiOffensiveWords);
    setState(() {});

    if (_hasProfanity) {
      // Exit early if profanity is detected
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final profileImagePath =
        prefs.getString('pfpPath') ?? 'assets/images/pfp/default.jpg';
    final newComment = Comment(
      id: '', // This will be set by Firestore
      userId: userID,
      content: commentText,
      timestamp: DateTime.now(),
      profileImagePath: profileImagePath,
      likes: 0,
      likedBy: [],
    );

    await ref.read(postsProvider.notifier).addComment(postId, newComment);
    commentController.clear();
    Navigator.of(context).pop(); // Close the page after posting the comment
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close_rounded),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              _addComment(
                  ref, widget.post!.id, commentController.text, widget.userID!);
              _refreshPosts();
            },
            child: Text(
              "Post",
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
          ),
        ],
        title: Text(
          'Add comment',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.post!.content),
            ),
            Divider(
              thickness: 0.1,
              indent: 10,
              endIndent: 10,
            ),
            if (_hasProfanity)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Your comment contains words which are not allowed',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            TextField(
              maxLines: null,
              minLines: 1,
              controller: commentController,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(8),
                hintText: 'Add a comment',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
