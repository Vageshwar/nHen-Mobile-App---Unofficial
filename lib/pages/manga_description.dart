import 'package:flutter/material.dart';
import 'package:nhen_unofficial/pages/manga_reader.dart';

class MangaDescriptionPage extends StatelessWidget {
  final Map<String, dynamic> manga;

  const MangaDescriptionPage({Key? key, required this.manga}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine the image extension based on the cover type
    final Map<String, String> imageExtensions = {
      'j': 'jpg',
      'p': 'png',
      'g': 'gif',
    };

    final String coverType = manga['images']['cover']['t'];
    final String coverUrl =
        'https://t.nhentai.net/galleries/${manga['media_id']}/cover.${imageExtensions[coverType]}';

    final String title =
        manga['title']['english'] ?? manga['title']['pretty'] ?? 'No Title';
    final int numPages = manga['num_pages'] ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                coverUrl,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Number of Pages: $numPages'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the MangaReaderPage
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        MangaReaderPage(manga: manga, currentPage: 1),
                  ),
                );
              },
              child: const Text('Start Reading'),
            ),
            const Divider(),
            const Text(
              'Tags:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Wrap(
              children: [
                for (var tag in manga['tags'])
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Chip(label: Text(tag['name'])),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
