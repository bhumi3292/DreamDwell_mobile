import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:table_calendar/table_calendar.dart';
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
  // String? _availabilityId; // Removed unused field
  Map<String, List<String>> _availabilitiesMap = {};

  String _normalizeDate(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return DateFormat('yyyy-MM-dd').format(d);
  }

  Future<String?> _getToken() async {
    final hive = HiveService();
    return await hive.getToken();
  }

  @override
  void initState() {
    super.initState();
    _fetchLandlordAvailabilities();
  }

  Future<void> _fetchLandlordAvailabilities() async {
    setState(() { _loading = true; _error = null; });
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        setState(() { 
          _error = 'Please log in to manage availability.'; 
          _loading = false; 
        });
        return;
      }

      final response = await Dio().get(
        'http://10.0.2.2:3001/api/calendar/landlord/availabilities',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final availabilities = response.data['availabilities'] as List;
      final map = <String, List<String>>{};
      
      for (var avail in availabilities) {
        if (avail['property']['_id'] == widget.propertyId) {
          final date = avail['date'] as String;
          final timeSlots = List<String>.from(avail['timeSlots'] ?? []);
          map[date] = timeSlots;
        }
      }
      
      setState(() {
        _availabilitiesMap = map;
      });
    } catch (e) {
      debugPrint('Dio error in _fetchLandlordAvailabilities: $e');
      if (e.toString().contains('403')) {
        setState(() { _error = 'Access denied. Please check your login status.'; });
      } else if (e.toString().contains('401')) {
        setState(() { _error = 'Please log in to manage availability.'; });
      } else {
        setState(() { _error = 'Failed to fetch availability data.'; });
      }
    } finally {
      setState(() { _loading = false; });
    }
  }

  void _onDateSelected(DateTime selectedDay, DateTime focusedDay) {
    final formattedDate = _normalizeDate(selectedDay);
    setState(() {
      _selectedDate = selectedDay;
      _slots = _availabilitiesMap[formattedDate] ?? [];
      // _availabilityId = null; // Will be set when we fetch specific availability
    });
  }

  Future<void> _addSlot() async {
    if (_selectedDate == null || _slotController.text.isEmpty) return;
    
    final newSlot = _slotController.text.trim();
    if (_slots.contains(newSlot)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This time slot already exists.'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() { _loading = true; _error = null; });
    try {
      final formattedDate = _normalizeDate(_selectedDate!);
      final token = await _getToken();
      
      final newSlots = [..._slots, newSlot];
      
      await Dio().post('http://10.0.2.2:3001/api/calendar/availabilities',
        data: {
          'propertyId': widget.propertyId,
          'date': formattedDate,
          'timeSlots': newSlots,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      
      _slotController.clear();
      await _fetchLandlordAvailabilities(); // Refresh the data
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Time slot added successfully!'), backgroundColor: Colors.green),
      );
    } catch (e) {
      debugPrint('Dio error in _addSlot: $e');
      setState(() { _error = 'Failed to add time slot.'; });
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
      
      await _fetchLandlordAvailabilities(); // Refresh the data
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Time slot removed successfully!'), backgroundColor: Colors.green),
      );
    } catch (e) {
      debugPrint('Dio error in _removeSlot: $e');
      setState(() { _error = 'Failed to remove time slot.'; });
    } finally {
      setState(() { _loading = false; });
    }
  }

  Future<void> _deleteAvailability() async {
    if (_selectedDate == null) return;
    
    setState(() { _loading = true; _error = null; });
    try {
      final formattedDate = _normalizeDate(_selectedDate!);
      final token = await _getToken();
      
      // Find the availability ID for this date
      final availability = _availabilitiesMap[formattedDate];
      if (availability == null) {
        setState(() { _error = 'No availability found for this date.'; });
        return;
      }
      
      // For now, we'll create an empty availability to effectively delete it
      await Dio().post('http://10.0.2.2:3001/api/calendar/availabilities',
        data: {
          'propertyId': widget.propertyId,
          'date': formattedDate,
          'timeSlots': [],
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      
      await _fetchLandlordAvailabilities(); // Refresh the data
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Availability deleted successfully!'), backgroundColor: Colors.green),
      );
    } catch (e) {
      debugPrint('Dio error in _deleteAvailability: $e');
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
            const Text('Manage Availability', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF003366))),
            const SizedBox(height: 16),
            
            if (_loading) 
              const Center(child: CircularProgressIndicator())
            else
              TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(const Duration(days: 60)),
                focusedDay: _selectedDate ?? DateTime.now(),
                selectedDayPredicate: (day) => _selectedDate != null && isSameDay(day, _selectedDate),
                onDaySelected: _onDateSelected,
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.blue[100],
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Color(0xFF003366),
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    final formatted = _normalizeDate(date);
                    if (_availabilitiesMap[formatted] != null && _availabilitiesMap[formatted]!.isNotEmpty) {
                      return Positioned(
                        bottom: 1,
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    }
                    return null;
                  },
                ),
              ),
            
            if (_selectedDate != null && !_loading)
              Column(
                children: [
                  const SizedBox(height: 16),
                  Text('Availability for: ${DateFormat('MMM dd, yyyy').format(_selectedDate!)}', 
                       style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  
                  if (_slots.isEmpty)
                    const Text('No time slots set for this date.', style: TextStyle(color: Colors.grey))
                  else
                    ..._slots.map((slot) => ListTile(
                      title: Text(slot),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeSlot(slot),
                      ),
                    )),
                  
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _slotController,
                          decoration: const InputDecoration(
                            hintText: 'Add time slot (e.g. 10:00 AM)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _addSlot,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF003366),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                  
                  if (_slots.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _deleteAvailability,
                        child: const Text('Delete All Slots for This Date'),
                      ),
                    ),
                ],
              ),
            
            if (_error != null) 
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
} 