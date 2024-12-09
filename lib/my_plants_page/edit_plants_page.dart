import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
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
  String? imagePath;

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
    selectedSchedule = widget.plant?.wateringLevel != null
        ? wateringSchedules[1]
        : null;
    imagePath = widget.plant?.image;
  }

  // Method to request storage permissions and pick an image
  Future<void> _pickImage() async {
    // Request storage permissions
    PermissionStatus status = await Permission.storage.request();

    if (status.isGranted) {
      // Use image_picker to select an image
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          imagePath = pickedFile.path;
        });
      }
    } else {
      // Show an error message if permissions are denied
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Storage permission is required to pick an image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Plant')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Image selection section
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: imagePath != null
                      ? Image.file(
                    File(imagePath!),
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  )
                      : Icon(
                    Icons.camera_alt,
                    size: 50,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Plant Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: speciesController,
                decoration: InputDecoration(
                  labelText: 'Plant Species',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Watering Schedule',
                  border: OutlineInputBorder(),
                ),
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
                  // Validate input
                  if (nameController.text.isEmpty || speciesController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill in all fields')),
                    );
                    return;
                  }

                  // Update or create the plant object
                  final updatedPlant = Plant(
                    name: nameController.text,
                    species: speciesController.text,
                    age: 1, // Example age, modify as needed
                    wateringLevel: selectedSchedule != null
                        ? wateringSchedules.indexOf(selectedSchedule!) * 25
                        : 50,
                    happinessLevel: 80, // Example happiness level
                    image: imagePath ?? '', // Save the image path
                  );
                  Navigator.pop(context, updatedPlant); // Return updated plant to previous screen
                },
                child: Text('Save'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up controllers
    nameController.dispose();
    speciesController.dispose();
    super.dispose();
  }
}