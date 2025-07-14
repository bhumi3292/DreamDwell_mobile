import 'package:flutter/material.dart';

class ContactLandlordPage extends StatelessWidget {
  final String landlordEmail;
  final String landlordPhone;
  const ContactLandlordPage({Key? key, required this.landlordEmail, required this.landlordPhone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Landlord')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: $landlordEmail'),
            const SizedBox(height: 8),
            Text('Phone: $landlordPhone'),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.email),
              label: const Text('Send Email'),
              onPressed: () {
                // TODO: Implement email launch
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.phone),
              label: const Text('Call'),
              onPressed: () {
                // TODO: Implement phone call launch
              },
            ),
          ],
        ),
      ),
    );
  }
} 