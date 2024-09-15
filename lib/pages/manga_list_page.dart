import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/manga_list_widget.dart';

class MangaListPage extends StatefulWidget {
  final String searchQuery;

  const MangaListPage({Key? key, required this.searchQuery}) : super(key: key);

  @override
  State<MangaListPage> createState() => _MangaListPageState();
}

class _MangaListPageState extends State<MangaListPage> {
  List<dynamic> _mangaList = [];
  bool _isLoading = true;
  bool _hasError = false;
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _fetchMangaList();
  }

  @override
  void didUpdateWidget(MangaListPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != oldWidget.searchQuery) {
      _resetMangaList();
    }
  }

  void _resetMangaList() {
    setState(() {
      _mangaList = [];
      _currentPage = 1;
      _isLoading = true;
      _hasMoreData = true;
    });
    _fetchMangaList();
  }

  Future<void> _fetchMangaList({bool loadMore = false}) async {
    final query =
        widget.searchQuery.isNotEmpty ? '&query=${widget.searchQuery}' : '';
    final url =
        'https://nhentai.net/api/galleries/search?query="$query"&page=$_currentPage';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null &&
            data['result'] != null &&
            data['result'].isNotEmpty) {
          setState(() {
            _mangaList.addAll(data['result']); // Append new data
            _isLoading = false;
            _isLoadingMore = false;
            _hasMoreData =
                data['result'].length == 25; // Check if more pages available
          });
        } else {
          setState(() {
            _isLoading = false;
            _isLoadingMore = false;
            _hasMoreData = false;
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
        _hasError = true; // Handle error and display error message
      });
    }
  }

  void _loadMoreManga() {
    if (!_isLoadingMore && _hasMoreData) {
      setState(() {
        _currentPage++;
        _isLoadingMore = true;
      });
      _fetchMangaList(loadMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError) {
      return const Center(
          child: Text('Failed to load manga. Please try again later.'));
    }

    return Column(
      children: [
        Expanded(
          child: _mangaList.isNotEmpty
              ? MangaListWidget(mangaList: _mangaList)
              : const Center(child: Text('No manga found')),
        ),
        if (_isLoadingMore)
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: CircularProgressIndicator(),
          ),
        if (!_isLoadingMore && _hasMoreData)
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: _loadMoreManga,
              child: const Text('Load More'),
            ),
          ),
      ],
    );
  }
}
