import 'package:flutter/material.dart';

class EditPropertyPage extends StatelessWidget {
  final String propertyId;
  const EditPropertyPage({Key? key, required this.propertyId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Property')),
      body: Center(
        child: Text('Edit form for property: $propertyId'),
      ),
    );
  }
} 