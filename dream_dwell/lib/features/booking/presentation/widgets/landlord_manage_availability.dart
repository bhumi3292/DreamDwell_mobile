import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:dream_dwell/cores/network/hive_service.dart';

class LandlordManageAvailability extends StatefulWidget {
  final String propertyId;
  const LandlordManageAvailability({Key? key, required this.propertyId}) : super(key: key);

  @override
  State<LandlordManageAvailability> createState() => _LandlordManageAvailabilityState();
}

class _LandlordManageAvailabilityState extends State<LandlordManageAvailability> {
  DateTime? _selectedDate;
  final TextEditingController _slotController = TextEditingController();
  List<String> _slots = [];
  bool _loading = false;
  String? _error;
  String? _availabilityId;

  String _normalizeDate(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return DateFormat('yyyy-MM-dd').format(d);
  }

  Future<String?> _getToken() async {
    final hive = HiveService();
    return await hive.getToken();
  }

  Future<void> _fetchAvailability(DateTime date) async {
    setState(() { _loading = true; _error = null; });
    try {
      final formattedDate = _normalizeDate(date);
      final token = await _getToken();
      final response = await Dio().get(
        'http://10.0.2.2:3001/api/calendar/properties/${widget.propertyId}/available-slots',
        queryParameters: {'date': formattedDate},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      setState(() {
        _slots = List<String>.from(response.data['availableSlots'] ?? []);
        _availabilityId = response.data['availability']?['_id'];
      });
    } catch (e) {
      print('Dio error in _fetchAvailability: $e');
      setState(() { _error = 'Failed to fetch availability.'; _slots = []; _availabilityId = null; });
    } finally {
      setState(() { _loading = false; });
    }
  }

  Future<void> _addSlot() async {
    if (_selectedDate == null || _slotController.text.isEmpty) return;
    setState(() { _loading = true; _error = null; });
    try {
      final formattedDate = _normalizeDate(_selectedDate!);
      final token = await _getToken();
      await Dio().post('http://10.0.2.2:3001/api/calendar/availabilities',
        data: {
          'propertyId': widget.propertyId,
          'date': formattedDate,
          'timeSlots': [..._slots, _slotController.text],
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      _slotController.clear();
      await _fetchAvailability(_selectedDate!);
    } catch (e) {
      print('Dio error in _addSlot: $e');
      setState(() { _error = 'Failed to add slot.'; });
    } finally {
      setState(() { _loading = false; });
    }
  }

  Future<void> _removeSlot(String slot) async {
    if (_selectedDate == null) return;
    setState(() { _loading = true; _error = null; });
    try {
      final formattedDate = _normalizeDate(_selectedDate!);
      final newSlots = _slots.where((s) => s != slot).toList();
      final token = await _getToken();
      if (newSlots.isEmpty) {
        // If no slots left, delete the availability
        await _deleteAvailability();
        return;
      }
      await Dio().post('http://10.0.2.2:3001/api/calendar/availabilities',
        data: {
          'propertyId': widget.propertyId,
          'date': formattedDate,
          'timeSlots': newSlots,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      await _fetchAvailability(_selectedDate!);
    } catch (e) {
      print('Dio error in _removeSlot: $e');
      setState(() { _error = 'Failed to remove slot.'; });
    } finally {
      setState(() { _loading = false; });
    }
  }

  Future<void> _deleteAvailability() async {
    if (_availabilityId == null) return;
    setState(() { _loading = true; _error = null; });
    try {
      final token = await _getToken();
      await Dio().delete('http://10.0.2.2:3001/api/calendar/availabilities/$_availabilityId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      setState(() { _slots = []; _availabilityId = null; });
    } catch (e) {
      print('Dio error in _deleteAvailability: $e');
      setState(() { _error = 'Failed to delete availability.'; });
    } finally {
      setState(() { _loading = false; });
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
            const Text('Manage Availability', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            CalendarDatePicker(
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 60)),
              onDateChanged: (date) {
                setState(() { _selectedDate = date; });
                _fetchAvailability(date);
              },
            ),
            if (_loading) const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
            if (_selectedDate != null && !_loading)
              Column(
                children: [
                  ..._slots.map((slot) => ListTile(
                    title: Text(slot),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeSlot(slot),
                    ),
                  )),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _slotController,
                          decoration: const InputDecoration(hintText: 'Add time slot (e.g. 10:00 AM)'),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: _addSlot,
                      ),
                    ],
                  ),
                  if (_slots.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: _deleteAvailability,
                        child: const Text('Delete All Slots for This Date'),
                      ),
                    ),
                ],
              ),
            if (_error != null) Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
} 