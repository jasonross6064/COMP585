import 'package:flutter/material.dart';

void main() => runApp( GardenApp());


class GardenApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Garden App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
  }

  class _HomePageState extends State<HomePage> {
    int _currentIndex = 0;

    final List<Widget> _tabs = [
      HomeScreen(),
      DictionaryScreen(),
      GardeningTipsScreen(),
      MyPlantsScreen(),
    ];

    @override
    Widget build(BuildContext cntext) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Gardening App'),
        ),
        body: _tabs[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index){
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fence),
              label: 'Gardening Tips',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books),
              label: 'Dictionary',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.yard),
              label: 'My Plants',
            ),
          ],
        ),
      );
    }
  }

  class HomeScreen extends StatelessWidget {
  @override
    Widget build (BuildContext context) {
      return Center(
        child: Text('Home Screen'),
      );
     }
    }
  class DictionaryScreen extends StatelessWidget {
  @override
    Widget build (BuildContext context) {
      return Center(
        child: Text('Dictionary Screen'),
      );
    }
  }
  class GardeningTipsScreen extends StatelessWidget {
  @override
    Widget build (BuildContext context) {
      return Center(
        child: Text('Gardening Tips Screen'),
      );
    }
  }
  class MyPlantsScreen extends StatelessWidget {
  @override
    Widget build (BuildContext context) {
      return Center(
        child: Text('My Plants Screen'),
      );
    }
  }