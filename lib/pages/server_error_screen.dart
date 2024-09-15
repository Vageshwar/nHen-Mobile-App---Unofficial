import 'package:flutter/material.dart';

class ServerErrorScreen extends StatelessWidget {
  const ServerErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              'Servers are down!',
              style: TextStyle(fontSize: 24, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate back to the splash screen to retry
                Navigator.of(context).pushReplacementNamed('/');
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
