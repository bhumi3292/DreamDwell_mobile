import 'package:flutter/material.dart';

class EditPropertyPage extends StatelessWidget {
<<<<<<< HEAD
  final String propertyId;
  const EditPropertyPage({Key? key, required this.propertyId}) : super(key: key);
=======
  const EditPropertyPage({Key? key}) : super(key: key);
>>>>>>> sprint5

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      appBar: AppBar(title: const Text('Edit Property')),
      body: Center(
        child: Text('Edit form for property: $propertyId'),
=======
      appBar: AppBar(
        title: const Text('Edit Property'),
      ),
      body: const Center(
        child: Text('Edit Property Page'),
>>>>>>> sprint5
      ),
    );
  }
} 