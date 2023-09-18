import 'package:flutter/material.dart';
import 'package:osm_poc/widgets/map_screen.dart';
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
      body: MapScreen(),
    );
  }
}
