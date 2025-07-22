abstract class ContactLandlordRepository {
  Future<List<String>> fetchContacts();
}

class MockContactLandlordRepository implements ContactLandlordRepository {
  @override
  Future<List<String>> fetchContacts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ['Contact 1', 'Contact 2', 'Contact 3'];
  }
} 