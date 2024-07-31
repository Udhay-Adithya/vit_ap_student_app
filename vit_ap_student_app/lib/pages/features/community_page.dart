import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vit_ap_student_app/pages/features/create_post.dart';
import '../../utils/ads/nativead.dart';
import '../../utils/provider/community_provider.dart';
import 'post_tile.dart';
import 'sort_criteria.dart';

class CommunityPage extends ConsumerStatefulWidget {
  const CommunityPage({super.key});

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends ConsumerState<CommunityPage> {
  late Future<String> _userIdFuture;
  final NativeAdManager _nativeAdManager = NativeAdManager();
  bool _isLoadingMore = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _userIdFuture = fetchUserRegNo();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(postsProvider.notifier).fetchPosts();
      _loadAd();
    });
  }

  void _loadAd() {
    final postsCount = ref.watch(postsProvider).length;
    const adFrequency = 5;
    final numberOfAds = (postsCount / adFrequency).ceil();

    _nativeAdManager.loadAds(
      numberOfAds,
      (ads) {
        ('Ads loaded: $ads');
        setState(() {});
      },
      () {
        print('Failed to load ads');
      },
    );
  }

  Future<String> fetchUserRegNo() async {
    final prefs = await SharedPreferences.getInstance();
    return jsonDecode(prefs.getString('profile')!)['student_name'] ?? '';
  }

  Future<void> _refreshPosts() async {
    await ref.read(postsProvider.notifier).fetchPosts();
    _loadAd();
  }

  void _sortPosts(SortCriteria criteria) {
    ref.read(postsProvider.notifier).sortPosts(criteria);
  }

  void _fetchMorePosts() async {
    if (_isLoadingMore) return;
    setState(() {
      _isLoadingMore = true;
    });
    await ref.read(postsProvider.notifier).fetchMorePosts();
    setState(() {
      _isLoadingMore = false;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchMorePosts();
    }
  }

  @override
  void dispose() {
    _nativeAdManager.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(postsProvider);

    // Filter posts based on the search query
    final filteredPosts = posts.where((post) {
      final postTitle = post.content.toLowerCase();
      final postContent = post.content.toLowerCase();
      final searchQuery = _searchQuery.toLowerCase();
      return postTitle.contains(searchQuery) ||
          postContent.contains(searchQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchDialog(context);
            },
          ),
          PopupMenuButton<SortCriteria>(
            onSelected: _sortPosts,
            itemBuilder: (context) => <PopupMenuEntry<SortCriteria>>[
              const PopupMenuItem<SortCriteria>(
                value: SortCriteria.mostLiked,
                child: Text('Most Liked'),
              ),
              const PopupMenuItem<SortCriteria>(
                value: SortCriteria.mostRecent,
                child: Text('Most Recent'),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreatePostDialog(context),
          ),
        ],
      ),
      body: FutureBuilder<String>(
        future: _userIdFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final userId = snapshot.data!;
            if (filteredPosts.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(
                    "assets/images/lottie/empty.json",
                    frameRate: const FrameRate(60),
                    width: 380,
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'No content here yet...',
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.tertiary),
                    ),
                  ),
                  Text(
                    'Post something awesome to get things started!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                ],
              );
            }

            final adFrequency = 5;
            final totalItems = filteredPosts.length +
                (filteredPosts.length / adFrequency).ceil();
            return RefreshIndicator(
              onRefresh: _refreshPosts,
              child: ListView.builder(
                  controller: _scrollController,
                  itemCount: totalItems + (_isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (_isLoadingMore && index == totalItems) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (_nativeAdManager.areAdsLoaded &&
                        index % adFrequency == 0 &&
                        index > 0) {
                      final adIndex = (index / adFrequency).floor();
                      final ad = _nativeAdManager.getNativeAd(adIndex);
                      if (ad != null) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: NativeAdWidget(nativeAd: ad),
                        );
                      }
                    } else {
                      final postIndex = index - (index / adFrequency).floor();
                      if (postIndex < 0 || postIndex >= filteredPosts.length) {
                        return SizedBox.shrink();
                      }
                      final post = filteredPosts[postIndex];
                      return PostTile(
                        post: post,
                        userId: userId,
                      );
                    }
                    return null;
                  }),
            );
          } else {
            return const Center(child: Text('No user ID found'));
          }
        },
      ),
    );
  }

  void _showCreatePostDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CreatePostDialog(),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Posts'),
        content: TextField(
          controller: _searchController,
          decoration: const InputDecoration(hintText: 'Enter search query'),
          onChanged: (query) {
            setState(() {
              _searchQuery = query;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _searchQuery = _searchController.text;
              });
              Navigator.of(context).pop();
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }
}
