import 'package:get/get.dart';
import 'package:dream_dwell/view/dashboard.dart';
import 'package:dream_dwell/view/explore.dart';
import 'package:dream_dwell/view/favourite.dart';
import 'package:dream_dwell/view/booking.dart';
import 'package:dream_dwell/view/profile.dart';

class NavigationController extends GetxController {
  var selectedIndex = 0.obs;

  final screens = [
    const DashboardPage(),
    const ExplorePage(),
    const FavouritePage(),
    const BookingPage(),
    const ProfilePage(),
  ];
}
