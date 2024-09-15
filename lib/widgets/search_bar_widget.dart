import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearchSubmitted;

  const SearchBarWidget({Key? key, required this.onSearchSubmitted})
      : super(key: key);

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();

  void _submitSearch() {
    widget.onSearchSubmitted(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search for manga...',
          suffixIcon: IconButton(
            icon: const Icon(Icons.search),
            onPressed: _submitSearch,
          ),
        ),
        onSubmitted: (value) => _submitSearch(),
      ),
    );
  }
}
