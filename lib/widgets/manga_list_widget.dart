import 'package:flutter/material.dart';
import 'package:nhen_unofficial/pages/manga_description.dart';

class MangaListWidget extends StatelessWidget {
  final List<dynamic> mangaList;

  const MangaListWidget({Key? key, required this.mangaList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: mangaList.length,
      itemBuilder: (context, index) {
        final manga = mangaList[index];

        // Construct the thumbnail URL using media_id
        final String thumbnailUrl =
            'https://t.nhentai.net/galleries/${manga['media_id']}/thumb.jpg';

        // Use the English title if available, otherwise fallback to 'pretty' title or 'No Title'
        final String title =
            manga['title']['english'] ?? manga['title']['pretty'] ?? 'No Title';

        // Get the number of pages
        final int numPages = manga['num_pages'] ?? 0;

        return ListTile(
          leading: Image.network(
            thumbnailUrl,
            width: 50,
            height: 70,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Display a placeholder icon when image fails to load
              return const Icon(Icons.broken_image, size: 50);
            },
          ),
          title: Text(title),
          subtitle: Text('$numPages pages'),
          onTap: () {
            // Navigate to MangaDescriptionPage with the selected manga
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MangaDescriptionPage(manga: manga),
              ),
            );
          },
        );
      },
    );
  }
}
