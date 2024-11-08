import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gardening_app/my_plants_page/plant.dart';
import 'package:gardening_app/my_plants_page/permission_handler.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class EditPlantPage extends StatefulWidget {
  final Plant? plant; // Make plant nullable

  EditPlantPage({this.plant}); // Accept a nullable plant

  @override
  _EditPlantPageState createState() => _EditPlantPageState();
}

class _EditPlantPageState extends State<EditPlantPage> {
  late TextEditingController _nameController;
  late TextEditingController _speciesController;
  late TextEditingController _ageController;
  late TextEditingController _wateringController;
  late TextEditingController _happinessController;

  File? _image; // Store the picked image

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // If plant is passed, initialize fields with its values, else set default values
    if (widget.plant != null) {
      _nameController = TextEditingController(text: widget.plant!.name);
      _speciesController = TextEditingController(text: widget.plant!.species);
      _ageController = TextEditingController(text: widget.plant!.age.toString());
      _wateringController = TextEditingController(text: widget.plant!.wateringLevel.toString());
      _happinessController = TextEditingController(text: widget.plant!.happinessLevel.toString());
      _image = File(widget.plant!.image); // Load the existing image
    } else {
      _nameController = TextEditingController();
      _speciesController = TextEditingController();
      _ageController = TextEditingController();
      _wateringController = TextEditingController();
      _happinessController = TextEditingController();
    }
  }

  // Pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Update the image
      });
    }
  }

  // Save or add new plant data
  void _savePlant() {
    final newPlant = Plant(
      name: _nameController.text,
      species: _speciesController.text,
      age: int.parse(_ageController.text),
      wateringLevel: int.parse(_wateringController.text),
      happinessLevel: int.parse(_happinessController.text),
      image: _image?.path ?? '', // Use new image or empty string if none selected
    );

    Navigator.pop(context, newPlant); // Pass new plant back
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.plant == null ? const Text('Add Plant') : const Text('Edit Plant'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _image == null
                    ? Center(child: Text('Tap to pick an image'))
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    _image!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Plant Name'),
            ),
            TextField(
              controller: _speciesController,
              decoration: const InputDecoration(labelText: 'Species'),
            ),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Age (in years)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _wateringController,
              decoration: const InputDecoration(labelText: 'Watering Level (%)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _happinessController,
              decoration: const InputDecoration(labelText: 'Happiness Level (%)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _savePlant,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}