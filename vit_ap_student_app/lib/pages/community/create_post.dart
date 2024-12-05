import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:filter_profanity/filter_profanity.dart'; // Import the package

import '../../models/community.dart';
import '../../utils/provider/community_provider.dart';

class CreatePostPage extends ConsumerStatefulWidget {
  final Post? post;
  final String? userID;

  const CreatePostPage({super.key, this.post, this.userID});

  @override
  ConsumerState<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends ConsumerState<CreatePostPage> {
  final _contentController = TextEditingController();
  String _postType = 'text'; // Default post type
  File? _mediaFile;
  Set<String> _selectedTags = {}; // Track selected tags
  bool _hasProfanity = false;
  bool _isPostEmpty = false;

  final List<String> _availableTags = [
    'Discussion',
    'Announcement',
    'Event',
    'Question',
    'Promotion',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.close_rounded,
            size: 28,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_contentController.text.trim().isEmpty)
                () => _isPostEmpty = true;
              _createPost(ref, context);
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
          'New Post',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_hasProfanity)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Your post contains words which are not allowed',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              if (_isPostEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Post cannot be empty',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: 8),
              TextField(
                maxLines: null,
                minLines: 1,
                controller: _contentController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(8),
                  hintText: 'Add post content',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ),
              SizedBox(height: 8),

              SizedBox(height: 8),
              Divider(
                thickness: 0.1,
                indent: 10,
                endIndent: 10,
              ),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select Tags:',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                children: _availableTags.map((tag) {
                  return FilterChip(
                    checkmarkColor: Theme.of(context).colorScheme.primary,
                    selectedColor: Theme.of(context).colorScheme.secondary,
                    selectedShadowColor: Theme.of(context).colorScheme.tertiary,
                    labelPadding: EdgeInsets.all(0),
                    padding: EdgeInsets.all(6),
                    label: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    selected: _selectedTags.contains(tag),
                    onSelected: (isSelected) {
                      setState(() {
                        if (isSelected) {
                          _selectedTags.add(tag);
                        } else {
                          _selectedTags.remove(tag);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 8),
              // DropdownButton<String>(
              //   value: _postType,
              //   items: [
              //     'text',
              //   ] // Add more options like 'link', 'image', etc.
              //       .map((type) => DropdownMenuItem(
              //             child: Text(type),
              //             value: type,
              //           ))
              //       .toList(),
              //   onChanged: (value) {
              //     setState(() {
              //       _postType = value!;
              //       if (['image', 'audio', 'video'].contains(_postType)) {
              //         _pickMedia();
              //       }
              //     });
              //   },
              // ),
              if (_mediaFile != null) ...[
                SizedBox(height: 8),
                _postType == 'image'
                    ? Image.file(_mediaFile!)
                    : Text(
                        'Selected ${_postType}: ${_mediaFile!.path.split('/').last}'),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickMedia() async {
    final picker = ImagePicker();
    XFile? pickedFile;

    switch (_postType) {
      case 'image':
        pickedFile = await picker.pickImage(source: ImageSource.gallery);
        break;
      case 'audio':
        // Implement media picking for audio
        break;
      case 'video':
        // Implement media picking for video
        break;
    }

    if (pickedFile != null) {
      setState(() {
        _mediaFile = File(pickedFile!.path);
      });
    }
  }

  Future<void> _createPost(WidgetRef ref, BuildContext context) async {
    final contentText = _contentController.text.trim();

    if (contentText.isEmpty) {
      setState(() {
        _hasProfanity = false; // No need to check for profanity if empty
      });
      return; // Exit early if content is empty
    }

    // Check for profanity
    _hasProfanity = hasProfanity(contentText,
        offensiveWords: englishOffensiveWords + hindiOffensiveWords);
    setState(() {});

    if (_hasProfanity) {
      // Exit early if profanity is detected
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString('profile');
    final username = profileJson != null
        ? jsonDecode(profileJson)['student_name']
        : 'Unknown';
    final profileImagePath =
        prefs.getString('pfpPath') ?? 'assets/images/pfp/default.jpg';

    final post = Post(
      id: '', // Generate unique ID if necessary
      username: username,
      profileImagePath: profileImagePath,
      content: contentText,
      type: _postType,
      likes: 0,
      dislikes: 0,
      comments: [],
      timestamp: DateTime.now(), // Add the timestamp
      likedBy: [], // Initialize as an empty list
      dislikedBy: [], // Initialize as an empty list
      tags: _selectedTags.toList(),
      creatorId: username, // Pass selected tags
    );

    // Handle media upload here if necessary and update the post content accordingly

    ref.read(postsProvider.notifier).addPost(post);
    Navigator.pop(context);
  }
}
