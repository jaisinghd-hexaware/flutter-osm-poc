import 'package:flutter/material.dart';
import 'package:osm_poc/widgets/mini_map.dart';
import 'package:osm_poc/widgets/osm.dart';
import 'package:osm_poc/widgets/test_mini_map.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My First App'),
      ),
      body: Center(
        child: Column(
          children: [
            MiniMap(),
            const Text('Hello World'),
            ElevatedButton(
              onPressed: () {
                // Use the context from this widget for navigation
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OSM()),
                );
              },
              child: const Text('Open Map'),
            ),
            TestMiniMap(),
          ],
        ),
      ),
    );
  }
}
