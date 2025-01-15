import 'package:flutter/material.dart';

import '../../styles/my_colors.dart';

class NavigationBarBottom extends StatefulWidget {
  final int currentPage;

  const NavigationBarBottom({super.key, required this.currentPage});

  @override
  State<NavigationBarBottom> createState() => _NavigationBarBottomState();
}

class _NavigationBarBottomState extends State<NavigationBarBottom> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentPage;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/upcoming_events');
        break;
      case 2:
        Navigator.pushNamed(context, '/sport_create');
        break;
      case 3:
        Navigator.pushNamed(context, '/sport_create');
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      unselectedItemColor: MyColors.primary.pink500,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.people_alt_outlined),
          label: 'All sport events',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.travel_explore),
          label: 'Upcoming events',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.create),
          label: 'Create',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: MyColors.dark,
      onTap: _onItemTapped,
    );
  }
}
