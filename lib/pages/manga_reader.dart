import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class MangaReaderPage extends StatefulWidget {
  final Map<String, dynamic> manga;
  final int currentPage;

  const MangaReaderPage(
      {Key? key, required this.manga, required this.currentPage})
      : super(key: key);

  @override
  _MangaReaderPageState createState() => _MangaReaderPageState();
}

class _MangaReaderPageState extends State<MangaReaderPage>
    with TickerProviderStateMixin {
  late int _currentPage;
  late String _currentPageUrl;
  bool _isLoading = true;
  bool _showActions = false;
  Timer? _hideTimer;

  final Map<String, String> imageExtensions = {
    'j': 'jpg',
    'p': 'png',
    'g': 'gif',
  };

  @override
  void initState() {
    super.initState();
    _currentPage = widget.currentPage;
    _loadPage();
    _startHideTimer();
  }

  // Load the image for the current page
  Future<void> _loadPage() async {
    setState(() {
      _isLoading = true;
    });

    final String imageType =
        widget.manga['images']['pages'][_currentPage - 1]['t'];
    final String mediaId = widget.manga['media_id'];
    _currentPageUrl =
        'https://i.nhentai.net/galleries/$mediaId/$_currentPage.${imageExtensions[imageType]}';

    setState(() {
      _isLoading = false;
    });
  }

  // Start the timer to hide the bottom actions
  void _startHideTimer() {
    _hideTimer?.cancel(); // Cancel any existing timer
    _hideTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _showActions = false;
      });
    });
  }

  // Move to the next page
  void _goToNextPage() {
    if (_currentPage < widget.manga['num_pages']) {
      setState(() {
        _currentPage++;
        _loadPage();
      });
    } else {
      Navigator.of(context)
          .pop(); // Exit the reader when reaching the last page
    }
  }

  // Move to the previous page
  void _goToPreviousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
        _loadPage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapUp: (details) {
          // Detect if the user tapped on the left, right, or center of the screen
          var screenWidth = MediaQuery.of(context).size.width;
          if (details.globalPosition.dx < screenWidth / 3) {
            _goToPreviousPage(); // Left side tap, go to previous page
          } else if (details.globalPosition.dx > 2 * screenWidth / 3) {
            _goToNextPage(); // Right side tap, go to next page
          } else {
            // Center tap, show/hide the actions
            setState(() {
              _showActions = !_showActions;
              if (_showActions) {
                _startHideTimer(); // Restart the hide timer when the actions reappear
              }
            });
          }
        },
        child: Stack(
          children: [
            Center(
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : AnimatedOpacity(
                      opacity: _isLoading ? 0 : 1,
                      duration: const Duration(milliseconds: 500),
                      child: InteractiveViewer(
                        panEnabled: true, // Allow panning
                        scaleEnabled: true, // Allow zooming
                        minScale: 1.0,
                        maxScale: 4.0, // Set a maximum zoom level
                        child: Image.network(
                          _currentPageUrl,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                        ),
                      ),
                    ),
            ),
            // Bottom action bar (appears and disappears after 3 seconds)
            if (_showActions)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: _currentPage > 1 ? _goToPreviousPage : null,
                      ),
                      Text(
                        'Page $_currentPage/${widget.manga['num_pages']}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward,
                            color: Colors.white),
                        onPressed: _currentPage < widget.manga['num_pages']
                            ? _goToNextPage
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hideTimer?.cancel(); // Cancel the timer when the page is disposed
    super.dispose();
  }
}
