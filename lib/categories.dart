import 'package:flutter/material.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search by Criteria'),
      ),
      body: const Center(
        child: Text('This is the Categories page'),
      ),
    );
  }
}
