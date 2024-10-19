import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({super.key});

  @override
  _DictionaryPageState createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  List<dynamic> plants = [];
  bool isLoading = false;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    fetchPlants();
  }

  Future<void> fetchPlants() async {
    setState(() {
     isLoading = true;
    });

    const apiKey = 'sk-9Hdu671316cb84c647326';
    final response = await http.get(
      Uri.parse('https://perenual.com/api/species-list?page=1&key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        plants = data['data'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('Failed to load plants');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: plants.length,
              itemBuilder: (context, index) {
                final plant = plants[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  color: selectedIndex == index ? const Color(0xFFC5E1A5) : null,
                  child: ListTile(
                    leading: plant['default_image'] != null
                        ? Image.network(
                            plant['default_image']['thumbnail'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                        )
                        : const Icon(Icons.local_florist),
                    title: Text(
                      plant['common_name'] ?? 'Unknown',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  ),
                );
              },
      ),
    );
  }
}