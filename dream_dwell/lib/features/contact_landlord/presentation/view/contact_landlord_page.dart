import 'package:flutter/material.dart';

class ContactLandlordPage extends StatelessWidget {
  const ContactLandlordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Landlord'),
      ),
      body: const Center(
        child: Text('Contact Landlord Page'),
      ),
    );
  }
} 