import 'package:flutter/material.dart';

class EditPropertyPage extends StatelessWidget {
  const EditPropertyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Property'),
      ),
      body: const Center(
        child: Text('Edit Property Page'),
      ),
    );
  }
} 