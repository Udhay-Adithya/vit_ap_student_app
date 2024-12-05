import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_ap_student_app/utils/provider/community_provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:vit_ap_student_app/pages/community/post_detail_page.dart';
import '../../models/community.dart';

class PostTile extends ConsumerWidget {
  final String userId;
  final Post post;

  const PostTile({super.key, required this.post, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _navigateToPostDetail(context, post, userId),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          color: Theme.of(context).colorScheme.secondary,
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        Text(
                          _formatTimestamp(post.timestamp),
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  if (post.creatorId == userId) ...[
                    PopupMenuButton(
                      icon: Icon(
                        Icons.more_vert_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          onTap: () {
                            _editPost(context, post, ref);
                          },
                          value: 0,
                          child: Row(
                            children: [
                              Icon(Icons.edit_rounded),
                              Text(
                                "  Edit",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () {
                            _confirmDeletePost(context, ref, post.id);
                          },
                          value: 0,
                          child: Row(
                            children: [
                              Icon(Icons.delete_forever),
                              Text(
                                "  Delete",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {},
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Container(
                constraints: const BoxConstraints(
                  maxHeight: 120,
                ),
                child: IntrinsicHeight(
                  child: Text(
                    post.content,
                    overflow: TextOverflow.fade,
                    softWrap: true,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildInteractionButton(
                          context,
                          ref,
                          icon: Icons.thumb_up_alt_outlined,
                          count: post.likes,
                          isActive: post.likedBy.contains(userId),
                          onPressed: () => _likePost(ref, post.id, userId),
                        ),
                        _buildInteractionButton(
                          context,
                          ref,
                          icon: Icons.thumb_down_off_alt_outlined,
                          count: post.dislikes,
                          isActive: post.dislikedBy.contains(userId),
                          onPressed: () => _dislikePost(ref, post.id, userId),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.mode_comment_outlined),
                          onPressed: () =>
                              _navigateToPostDetail(context, post, userId),
                        ),
                        Text('${post.comments.length}')
                      ],
                    ),
                  ),
                ],
              ),
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
          iconSize: 22,
        ),
        Text(
          count.toString(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  void _navigateToPostDetail(BuildContext context, Post post, String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailPage(post: post, userId: userId),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return timeago.format(timestamp);
  }

  void _likePost(WidgetRef ref, String postId, String userId) {
    ref.read(postsProvider.notifier).likePost(postId, userId);
  }

  void _dislikePost(WidgetRef ref, String postId, String userId) {
    ref.read(postsProvider.notifier).dislikePost(postId, userId);
  }

  void _editPost(BuildContext context, Post post, WidgetRef ref) {
    final TextEditingController _contentController =
        TextEditingController(text: post.content);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Post'),
          content: TextField(
            controller: _contentController,
            decoration: const InputDecoration(
              labelText: 'Post Content',
              border: OutlineInputBorder(),
            ),
            maxLines: 5,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final updatedContent = _contentController.text.trim();
                if (updatedContent.isNotEmpty) {
                  final updatedPost = post.copyWith(content: updatedContent);
                  ref.read(postsProvider.notifier).updatePost(updatedPost);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeletePost(BuildContext context, WidgetRef ref, String postId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this post?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Trigger post deletion
                ref.read(postsProvider.notifier).deletePost(postId);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
