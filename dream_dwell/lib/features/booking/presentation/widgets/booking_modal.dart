import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:dream_dwell/cores/network/hive_service.dart';

class BookingModal extends StatefulWidget {
  final String propertyId;
  final VoidCallback? onBookingSuccess;
  const BookingModal({Key? key, required this.propertyId, this.onBookingSuccess}) : super(key: key);

  @override
  State<BookingModal> createState() => _BookingModalState();
}

class _BookingModalState extends State<BookingModal> {
  DateTime? _selectedDate;
  String? _selectedSlot;
  List<String> _availableSlots = [];
  bool _loadingSlots = false;
  bool _booking = false;
  String? _error;

  Future<String?> _getToken() async {
    final hive = HiveService();
    return await hive.getToken();
  }

  Future<void> _fetchSlots(DateTime date) async {
    setState(() { _loadingSlots = true; _error = null; });
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final token = await _getToken();
      final response = await Dio().get(
        'http://10.0.2.2:3001/api/calendar/properties/${widget.propertyId}/available-slots',
        queryParameters: {'date': formattedDate},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      setState(() {
        _availableSlots = List<String>.from(response.data['availableSlots'] ?? []);
        _selectedSlot = null;
      });
    } catch (e) {
      print('Dio error in _fetchSlots: $e');
      setState(() { _error = 'Failed to fetch slots.'; });
    } finally {
      setState(() { _loadingSlots = false; });
    }
  }

  Future<void> _bookVisit() async {
    if (_selectedDate == null || _selectedSlot == null) return;
    setState(() { _booking = true; _error = null; });
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      final token = await _getToken();
      await Dio().post('http://10.0.2.2:3001/api/calendar/book-visit',
        data: {
          'propertyId': widget.propertyId,
          'date': formattedDate,
          'timeSlot': _selectedSlot,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (widget.onBookingSuccess != null) widget.onBookingSuccess!();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking successful!'), backgroundColor: Colors.green),
      );
    } catch (e) {
      print('Dio error in _bookVisit: $e');
      setState(() { _error = 'Failed to book visit.'; });
    } finally {
      setState(() { _booking = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Book a Visit', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            CalendarDatePicker(
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 60)),
              onDateChanged: (date) {
                setState(() { _selectedDate = date; });
                _fetchSlots(date);
              },
            ),
            if (_loadingSlots) const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
            if (_selectedDate != null && !_loadingSlots)
              _availableSlots.isEmpty
                ? const Text('No available slots for this date.')
                : DropdownButton<String>(
                    value: _selectedSlot,
                    hint: const Text('Select Time Slot'),
                    items: _availableSlots.map((slot) => DropdownMenuItem(value: slot, child: Text(slot))).toList(),
                    onChanged: (val) => setState(() => _selectedSlot = val),
                  ),
            if (_error != null) Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _booking || _selectedDate == null || _selectedSlot == null ? null : _bookVisit,
              child: _booking ? const CircularProgressIndicator(color: Colors.white) : const Text('Confirm Booking'),
            ),
          ],
        ),
      ),
    );
  }
} 