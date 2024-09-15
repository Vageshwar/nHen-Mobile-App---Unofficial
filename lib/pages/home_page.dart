import 'package:flutter/material.dart';
import 'manga_list_page.dart';
import '../widgets/search_bar_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchQuery = ''; // Track the search query

  // When the user submits the search query
  void _onSearchSubmitted(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NHen Exe'),
      ),
      body: Column(
        children: [
          // Search bar at the top
          SearchBarWidget(onSearchSubmitted: _onSearchSubmitted),
          // Manga list that fetches results based on the search query
          Expanded(
            child: MangaListPage(searchQuery: _searchQuery),
          ),
        ],
      ),
    );
  }
}
