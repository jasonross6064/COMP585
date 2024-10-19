import 'package:flutter/material.dart';
import 'home.dart';
import 'dictionary.dart';
import 'gardening_tips.dart';
import 'my_plants.dart';

void main() {
  runApp(GardenApp());
}

class GardenApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gardening App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.green[50],
          selectedItemColor: Colors.green[800],
          unselectedItemColor: Colors.green[400],
        ),
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    DictionaryPage(),
    GardeningTipsPage(),
    MyPlantsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Gardening App'),
              backgroundColor: Colors.green,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Dictionary',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fence),
            label: 'Gardening Tips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.yard),
            label: 'My Plants',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
