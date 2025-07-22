import 'package:flutter/material.dart';

class SharePropertyWidget extends StatelessWidget {
<<<<<<< HEAD
  final String propertyId;
  const SharePropertyWidget({Key? key, required this.propertyId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Share Property'),
      content: Text('Share property link for: $propertyId'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
=======
  const SharePropertyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Property'),
      ),
      body: const Center(
        child: Text('Share Property Widget'),
      ),
>>>>>>> sprint5
    );
  }
} 