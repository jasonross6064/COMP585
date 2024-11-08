import 'package:flutter/material.dart';
import 'home.dart';
import 'dictionary_page/dictionary.dart';
import 'gardening_tips_page/gardening_tips.dart';
import 'my_plants_page/my_plants.dart';

void main() {
  runApp(const GardenApp());
}

class GardenApp extends StatelessWidget {
  const GardenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlantPals',
      theme: ThemeData(
        primarySwatch: Colors.green,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.green[50],
          selectedItemColor: Colors.green[800],
          unselectedItemColor: Colors.green[400],
        ),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const DictionaryPage(),
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
          title: const Text('PlantPals'),
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
