import 'package:flutter/material.dart';
import 'package:gardening_app/my_plants_page/plant.dart';

class EditPlantPage extends StatefulWidget {
  final Plant? plant;

  EditPlantPage({this.plant});

  @override
  _EditPlantPageState createState() => _EditPlantPageState();
}

class _EditPlantPageState extends State<EditPlantPage> {
  late TextEditingController nameController;
  late TextEditingController speciesController;
  String? selectedSchedule;

  final List<String> wateringSchedules = [
    'Every Day',
    'Every Other Day',
    'Once a Week',
    'Once Every Two Weeks',
    'Once a Month',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing plant data if available
    nameController = TextEditingController(text: widget.plant?.name ?? '');
    speciesController = TextEditingController(text: widget.plant?.species ?? '');
    selectedSchedule = widget.plant?.wateringLevel != null ? wateringSchedules[1] : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Plant')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Plant Name'),
            ),
            TextField(
              controller: speciesController,
              decoration: InputDecoration(labelText: 'Plant Species'),
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: selectedSchedule,
              onChanged: (String? newValue) {
                setState(() {
                  selectedSchedule = newValue;
                });
              },
              items: wateringSchedules.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Update or create the plant object
                final updatedPlant = Plant(
                  name: nameController.text,
                  species: speciesController.text,
                  age: 1, // Example age, modify as needed
                  wateringLevel: wateringSchedules.indexOf(selectedSchedule ?? 'Once a Week') * 25,
                  happinessLevel: 80, // Example happiness level
                  image: '', // Optional image handling
                );
                Navigator.pop(context, updatedPlant); // Return updated plant to previous screen
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
