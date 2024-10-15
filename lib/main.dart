import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Gardening App',
        home: GardenApp()
  ));
}

class GardenApp extends StatefulWidget {
  const GardenApp({Key? key}) : super(key: key);

  @override
  GardenAppState createState() => GardenAppState();
}

class GardenAppState extends State<GardenApp> {


}

