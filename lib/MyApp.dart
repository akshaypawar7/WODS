import 'package:flutter/material.dart';
// Tabs
import 'tabs/Watchlists.dart';
import 'tabs/Markets.dart';
import 'tabs/Feed.dart';
import 'tabs/Profile.dart';
// Drawer
import 'drawers/Watchlists_Menu.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedTab = 3;
  final List<Widget> _tabs = [
    Watchlists(),
    Markets(),
    Feed(),
    Profile(),
  ];
  Widget _page() {
    return Scaffold(
      backgroundColor: Color.fromRGBO(240, 154, 105, 1),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 9,
            child: Center(
              child: Text(
                'WODS',
                style: TextStyle(fontSize: 55, color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Made in INDIA',
              style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _selectedTab == 0 ? Drawer(child: Watchlists_Menu()) : null,
      body: _tabs.elementAt(_selectedTab),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'WatchList',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard_rounded),
            label: 'Markets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_rounded),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        showUnselectedLabels: false,
        showSelectedLabels: false,
        selectedItemColor: Color.fromRGBO(240, 154, 105, 1),
        unselectedItemColor: Colors.grey[500],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedTab,
        onTap: (int index) => setState(() {
          if (_selectedTab != index) _selectedTab = index;
        }),
      ),
    );
  }
}
