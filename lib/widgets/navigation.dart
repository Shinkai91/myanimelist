import 'package:flutter/material.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: currentIndex,
      items: const [
        CurvedNavigationBarItem(
          child: Icon(Icons.tv),
          label: 'Anime',
        ),
        CurvedNavigationBarItem(
          child: Icon(Icons.book),
          label: 'Manga',
        ),
        CurvedNavigationBarItem(
          child: Icon(Icons.calendar_today),
          label: 'Seasonal',
        ),
        CurvedNavigationBarItem(
          child: Icon(Icons.search),
          label: 'Search',
        ),
        CurvedNavigationBarItem(
          child: Icon(Icons.favorite),
          label: 'Favorite',
        ),
        CurvedNavigationBarItem(
          child: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      color: Colors.white,
      buttonBackgroundColor: Colors.white,
      backgroundColor: const Color.fromARGB(255, 40, 53, 147),
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 600),
      onTap: onTap,
      letIndexChange: (index) => true,
    );
  }
}