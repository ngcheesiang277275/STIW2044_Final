import 'package:flutter/material.dart';
import 'package:mytutor/views/subjectspage.dart';
import 'package:mytutor/views/tutorspage.dart';
import 'package:mytutor/views/subscriptionpage.dart';
import 'package:mytutor/views/favouritespage.dart';
import 'package:mytutor/views/profilepage.dart';
import 'package:mytutor/models/user.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      SubjectsPage(
        user: widget.user,
      ),
      const TutorsPage(),
      const SubscriptionPage(),
      const FavouritesPage(),
      const ProfilePage()
    ];
  }

  int currentIndex = 0;

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTap,
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black,
        elevation: 10,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Subjects'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Tutors'),
          BottomNavigationBarItem(
              icon: Icon(Icons.beenhere), label: 'Subscription'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favourite'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Profile'),
        ],
      ),
    );
  }
}
