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
  bool isFetchingMore = false;
  int currentPage = 1;
  int? selectedIndex;
  final ScrollController _scrollController = ScrollController();

  String plantName = '';
  String plantDescription = '';
  String plantImageUrl = '';
  String plantCycle = '';
  String plantWatering = '';
  String plantSunlight = '';
  String plantOtherNames = '';

  @override
  void initState() {
    super.initState();
    fetchPlants();  // Initial plant fetch
    _scrollController.addListener(_onScroll);  // Listen for scroll events
  }

  // Combined method to fetch plants and their details
  Future<void> fetchPlants() async {
    if (isLoading || isFetchingMore) return;

    setState(() {
      isLoading = currentPage == 1;
      isFetchingMore = currentPage > 1;
    });

    const apiKey = 'sk-9Hdu671316cb84c647326';
    final response = await http.get(
      Uri.parse('https://perenual.com/api/species-list?page=$currentPage&key=$apiKey&order=asc'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> fetchedPlants = data['data'];

      // Filter out plants based on image URL or any other criteria
      List<dynamic> filteredPlants = fetchedPlants.where((plant) {
        final imageUrl = plant['default_image']?['regular_url'];
        return imageUrl != null && imageUrl != 'null' && !imageUrl.contains('upgrade_access');
      }).toList();

      setState(() {
        plants.addAll(filteredPlants);

        // Log plant IDs for debugging
        print('Fetched Plant IDs: ${filteredPlants.map((plant) => plant['id']).toList()}');

        isLoading = false;
        isFetchingMore = false;
      });

      setState(() {
        plants.addAll(filteredPlants);
        isLoading = false;
        isFetchingMore = false;
      });
    } else {
      setState(() {
        isLoading = false;
        isFetchingMore = false;
      });
      print('Failed to load plants');
    }

  }

  // Fetch plant details based on its ID
  /*Future<void> fetchPlantDetails(int plantId) async {
    setState(() {
      isLoading = true;
    });

    const apiKey = 'sk-9Hdu671316cb84c647326';
    final url = 'https://perenual.com/api/species/$plantId?key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      // Log the response body
      print('Response Body: ${response.body}');

      // Check if the response is successful
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          plantName = data['common_name'] ?? 'Unknown Plant';
          plantDescription = data['scientific_name'] ?? 'No description available';
          plantImageUrl = data['default_image']?['regular_url'] ?? '';
          plantCycle = data['cycle'] ?? 'Not specified';
          plantWatering = data['watering'] ?? 'Not specified';
          plantSunlight = _handleSunlightField(data['sunlight']);
          plantOtherNames = _handleOtherNamesField(data['other_name']);
          isLoading = false;
        });
      } else {
        // If the status code is not 200, log the error
        print('Error: Failed to load plant details. Status code: ${response.statusCode}');
        print('Error Response: ${response.body}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      // Catch any errors such as network issues
      print('Error fetching plant details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }*/
  Future<void> fetchPlantDetails(int plantId) async {
    setState(() {
      isLoading = true;
    });

    const apiKey = 'sk-9Hdu671316cb84c647326';
    final url = 'https://perenual.com/api/species/details/$plantId?key=$apiKey';

    print('Fetching details for Plant ID: $plantId');
    print('Full URL: $url');

    try {
      final response = await http.get(Uri.parse(url));

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);

          // Print the type and structure of the returned data
          print('Data Type: ${data.runtimeType}');
          print('Data Content: $data');

          // Handle different possible return types
          dynamic plantData;
          if (data is List && data.isNotEmpty) {
            plantData = data[0]; // Take the first item if it's a list
          } else if (data is Map) {
            plantData = data;
          } else {
            throw Exception('Unexpected data format');
          }

          setState(() {
            plantName = plantData['common_name'] ?? 'Unknown Plant';
            plantDescription = plantData['scientific_name']?[0] ?? 'No description available';
            plantImageUrl = plantData['default_image']?['regular_url'] ?? '';
            plantCycle = plantData['cycle'] ?? 'Not specified';
            plantWatering = plantData['watering'] ?? 'Not specified';
            plantSunlight = _handleSunlightField(plantData['sunlight']);
            plantOtherNames = _handleOtherNamesField(plantData['other_name']);
            isLoading = false;
          });
        } catch (parseError) {
          print('JSON Parsing Error: $parseError');
          setState(() {
            isLoading = false;
          });
        }
      } else {
        print('Error: Failed to load plant details. Status code: ${response.statusCode}');
        print('Error Response: ${response.body}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching plant details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Handle the sunlight data (if it's a list or string)
  String _handleSunlightField(dynamic sunlight) {
    if (sunlight == null) return 'No sunlight info available';
    return sunlight is String ? sunlight : 'Unknown sunlight info';
  }

  // Handle the "other names" data (if it's a list or string)
  String _handleOtherNamesField(dynamic otherNames) {
    if (otherNames == null) return 'No other names available';
    return otherNames is List ? otherNames.join(', ') : otherNames.toString();
  }

  // Detect when the user scrolls to the bottom to load more plants
  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
        !isLoading && !isFetchingMore) {
      currentPage++;
      fetchPlants();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Dictionary'),
      ),
      body: isLoading && currentPage == 1
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: plants.length + (isFetchingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == plants.length) {
                  return const Center(child: CircularProgressIndicator());
                }
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
                      fetchPlantDetails(plant['id']);  // Fetch details for the tapped plant
                    },
                  ),
                );
              },
            ),
          ),
          if (isFetchingMore)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: CircularProgressIndicator(),
            ),
          // Display plant details if selected
          if (selectedIndex != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        plantName,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            selectedIndex = null;
                            // Reset plant details
                            plantName = '';
                            plantDescription = '';
                            plantImageUrl = '';
                            plantCycle = '';
                            plantWatering = '';
                            plantSunlight = '';
                            plantOtherNames = '';
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  plantImageUrl.isNotEmpty
                      ? Image.network(plantImageUrl, height: 200, fit: BoxFit.cover)
                      : const Icon(Icons.image_not_supported),
                  const SizedBox(height: 16),
                  Text('Description: $plantDescription'),
                  Text('Cycle: $plantCycle'),
                  Text('Watering: $plantWatering'),
                  Text('Sunlight: $plantSunlight'),
                  Text('Other Names: $plantOtherNames'),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

