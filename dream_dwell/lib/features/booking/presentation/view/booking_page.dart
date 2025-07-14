import 'package:flutter/material.dart';

class BookingPage extends StatelessWidget {
  final String propertyId;
  const BookingPage({Key? key, required this.propertyId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Property')),
      body: Center(
        child: Text('Booking form for property: $propertyId'),
      ),
    );
  }
} 