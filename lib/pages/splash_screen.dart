import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isServerUp = true;

  @override
  void initState() {
    super.initState();
    _checkBackend();
  }

  Future<void> _checkBackend() async {
    try {
      final response = await http.get(Uri.parse('https://nhentai.net'));
      if (response.statusCode == 200) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        setState(() {
          _isServerUp = false;
        });
        Navigator.of(context).pushReplacementNamed('/error');
      }
    } catch (e) {
      setState(() {
        _isServerUp = false;
      });
      Navigator.of(context).pushReplacementNamed('/error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Checking server status...'),
          ],
        ),
      ),
    );
  }
}
