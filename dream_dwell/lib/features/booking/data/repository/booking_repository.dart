abstract class BookingRepository {
  Future<List<String>> fetchBookings();
}

class MockBookingRepository implements BookingRepository {
  @override
  Future<List<String>> fetchBookings() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ['Booking 1', 'Booking 2', 'Booking 3'];
  }
} 