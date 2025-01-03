import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gardening_app/my_plants_page/plant.dart';
import 'package:gardening_app/my_plants_page/edit_plants_page.dart';

class MyPlantsPage extends StatefulWidget {
  @override
  _MyPlantsPageState createState() => _MyPlantsPageState();
}

class _MyPlantsPageState extends State<MyPlantsPage> {
  // List of plants (you can also fetch these from a database or API)
  List<Plant> plants = [
    Plant(name: 'Mitchell', species: 'Aloe', age: 2, wateringLevel: 80, happinessLevel: 90, image: '',),
    Plant(name: 'George', species: 'Ocimum basilicum', age: 1, wateringLevel: 70, happinessLevel: 85, image: '',),
    Plant(name: 'Goeff', species: 'Cactaceae', age: 3, wateringLevel: 20, happinessLevel: 60, image: '',),
  ];

  // List of watering schedules
  final List<String> wateringSchedules = [
    'Every Day',
    'Every Other Day',
    'Once a Week',
    'Once Every Two Weeks',
    'Once a Month',
  ];

  // Current selected schedule for each plant, stored by plant index
  Map<int, String> selectedSchedules = {};

  // Method to calculate watering level based on selected schedule
  void updateWateringLevel(int index, String schedule) {
    int wateringLevel = 0;

    switch (schedule) {
      case 'Every Day':
        wateringLevel = 100;
        break;
      case 'Every Other Day':
        wateringLevel = 80;
        break;
      case 'Once a Week':
        wateringLevel = 75;
        break;
      case 'Once Every Two Weeks':
        wateringLevel = 50;
        break;
      case 'Once a Month':
        wateringLevel = 25;
        break;
    }

    setState(() {
      plants[index].wateringLevel = wateringLevel;
      selectedSchedules[index] = schedule;  // Store selected schedule by plant index
    });
  }

  // Edit or add plant (based on the context)
  Future<void> _editOrAddPlant(int? index) async {
    final updatedPlant = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPlantPage(plant: index != null ? plants[index] : null),
      ),
    );

    if (updatedPlant != null) {
      if (index == null) {
        setState(() {
          plants.add(updatedPlant); // Add the new plant to the list
        });
      } else {
        setState(() {
          plants[index] = updatedPlant;  // Update the plant in the list
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: plants.length,
        itemBuilder: (context, index) {
          final plant = plants[index];

          // Check if the plant has an image
          Widget imageWidget;

          if (plant.image.isEmpty) {
            // If no image is set, show a default icon
            imageWidget = const Icon(
                Icons.yard,
                size: 80, // Larger icon size
                color: Colors.grey
            );
          } else {
            // If the image exists, display it (assuming it's a picked image)
            imageWidget = Image.file(
              File(plant.image), // Display picked image from device storage
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            );
          }

          return InkWell(
            onTap: () => _editOrAddPlant(index),  // Handle the tap to edit plant
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Increased card margin
              elevation: 4, // Add some elevation for a raised effect
              child: Padding(
                padding: const EdgeInsets.all(16.0), // Add padding inside the card
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        imageWidget,  // Image or default icon
                        SizedBox(width: 16), // Space between image and text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                plant.name,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                plant.species,
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16), // Space between image and progress bars
                    // Water Level as Progress Bar
                    Text(
                      'Water Level',
                      style: TextStyle(fontSize: 14, color: Colors.blue),
                    ),
                    LinearProgressIndicator(
                      value: plant.wateringLevel / 100,
                      backgroundColor: Colors.grey[200],
                      color: Colors.blue,
                      minHeight: 6,
                    ),
                    SizedBox(height: 8),  // Space between progress bars
                    // Happiness Level as Progress Bar
                    Text(
                      'Happiness',
                      style: TextStyle(fontSize: 14, color: Colors.orange),
                    ),
                    LinearProgressIndicator(
                      value: plant.happinessLevel / 100,
                      backgroundColor: Colors.grey[200],
                      color: Colors.orange,
                      minHeight: 6,
                    ),
                    SizedBox(height: 16),
                    // Show dropdown only when editing a plant
                    if (selectedSchedules[index] != null)
                      DropdownButton<String>(
                        value: selectedSchedules[index], // Show the selected schedule
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            updateWateringLevel(index, newValue); // Update the watering level
                          }
                        },
                        items: wateringSchedules.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _editOrAddPlant(null), // Add new plant
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
