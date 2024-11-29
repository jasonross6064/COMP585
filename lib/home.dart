import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String plantName = '';
  String plantDescription = '';
  String plantImageUrl = '';
  String plantCycle = '';
  String plantWatering = '';
  String plantSunlight = '';
  String plantOtherNames = '';
  String weatherDescription = '';
  String temperature = '';
  String humidity = '';
  String windSpeed = '';
  bool isLoading = true;  // To manage loading state for plant
  bool isWeatherLoading = true;  // To manage loading state for weather
  bool isExpanded = false;  // To manage expanded state of the card
  DateTime currentDate = DateTime.now();  // To track today's date
  int plantIndex = 0;  // To store which plant to fetch based on date

  @override
  void initState() {
    super.initState();
    fetchRandomPlant(); // Fetch plant data
    fetchWeatherData();  // Fetch weather data
  }

  // Fetch stored plant index to ensure the same plant is shown for the whole day
  Future<void> fetchStoredPlantIndex() async {
    final prefs = await SharedPreferences.getInstance();
    final storedDate = prefs.getString('lastFetchedDate');
    final today = DateTime.now().toIso8601String().split('T')[0];  // Get the date in YYYY-MM-DD format

    if (storedDate != today) {
      // It's a new day, so set a new plant index
      final newPlantIndex = DateTime.now().day % 10;
      prefs.setInt('plantIndex', newPlantIndex);
      prefs.setString('lastFetchedDate', today);  // Save today's date
      setState(() {
        plantIndex = newPlantIndex;  // Update the index for today's plant
      });
    } else {
      // Use the stored plant index for today
      plantIndex = prefs.getInt('plantIndex') ?? 0;
    }
  }

  // Fetch plant data
  Future<void> fetchRandomPlant() async {
    const apiKey = 'sk-9Hdu671316cb84c647326';
    final currentPage = 1;

    try {
      final response = await http.get(
        Uri.parse('https://perenual.com/api/species-list?page=$currentPage&key=$apiKey&order=asc'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final plants = data['data'] as List;

        // Ensure we are getting a plant with a valid image
        bool plantFound = false;
        for (var i = plantIndex; i < plants.length; i++) {
          final plant = plants[i];
          final imageUrl = plant['default_image']?['regular_url'];

          if (imageUrl != null && imageUrl.isNotEmpty && imageUrl != 'null') {
            String description = '';
            if (plant['scientific_name'] is List) {
              description = (plant['scientific_name'] as List).join(', ');
            } else if (plant['scientific_name'] is String) {
              description = plant['scientific_name'] ?? 'No description available';
            } else {
              description = 'No description available';
            }

            setState(() {
              plantName = plant['common_name'] ?? 'Unknown Plant';
              plantDescription = description;
              plantImageUrl = imageUrl;  // Use the valid image URL
              plantCycle = plant['cycle'] ?? 'Not specified';
              plantWatering = plant['watering'] ?? 'Not specified';
              plantSunlight = _handleSunlightField(plant['sunlight']);
              plantOtherNames = _handleOtherNamesField(plant['other_name']);
              isLoading = false;
            });

            plantFound = true;
            break; // Exit the loop once we find a valid plant
          }
        }

        if (!plantFound) {
          setState(() {
            plantName = 'No valid plant found';
            plantDescription = 'Could not find a plant with valid image data';
            plantImageUrl = '';
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load plants, Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        plantName = 'Error';
        plantDescription = 'Failed to fetch plant data';
        plantImageUrl = '';
        isLoading = false;
      });
    }
  }

  // Handle 'sunlight' field which could be a List or String
  String _handleSunlightField(dynamic sunlight) {
    if (sunlight is List) {
      return sunlight.join(', ');
    } else if (sunlight is String) {
      return sunlight;
    } else {
      return 'Not specified';
    }
  }

  // Handle 'other_name' field which could be a List or String
  String _handleOtherNamesField(dynamic otherName) {
    if (otherName is List) {
      return otherName.join(', ');
    } else if (otherName is String) {
      return otherName;
    } else {
      return 'None';
    }
  }






  // Fetch weather data
  Future<void> fetchWeatherData() async {
    const apiKey = 'c7c88d7c24d8488f95903555241611';
    const cityName = 'Los Angeles';

    try {
      final response = await http.get(
        Uri.parse('http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$cityName&aqi=no'),
      );

      print('Weather response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          weatherDescription = data['current']['condition']['text'] ?? 'No description available';
          temperature = '${data['current']['temp_c']}°C' ?? 'No temperature data';
          humidity = '${data['current']['humidity']}%' ?? 'No humidity data';
          windSpeed = '${data['current']['wind_kph']} km/h' ?? 'No wind speed data';
          isWeatherLoading = false;
        });
      } else {
        throw Exception('Failed to load weather data, Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Weather data fetch error: $error');

      setState(() {
        weatherDescription = 'Error fetching weather';
        temperature = 'N/A';
        humidity = 'N/A';
        windSpeed = 'N/A';
        isWeatherLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to PlantPals!'),  // AppBar title
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Plant of the Day Card
              isLoading
                  ? Center(child: CircularProgressIndicator())  // Loading spinner
                  : GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.lightGreen[50],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Plant of the Day",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ),
                      // Row to place image on the left and name/description on the right
                      Row(
                        children: [
                          if (plantImageUrl.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipOval(
                                child: Image.network(
                                  plantImageUrl,
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    plantName,
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8),
                                  Text(plantDescription),
                                  if (isExpanded)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Divider(),
                                          Text('Cycle: $plantCycle'),
                                          Text('Watering: $plantWatering'),
                                          Text('Sunlight: $plantSunlight'),
                                          Text('Other Names: $plantOtherNames'),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Weather Card (with full width)
              isWeatherLoading
                  ? Center(child: CircularProgressIndicator())  // Weather loading spinner
                  : Container(
                width: double.infinity,  // This will make the card take up the full width
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.lightGreen[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Weather for the Day',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                        SizedBox(height: 8),
                        Text('Condition: $weatherDescription'),
                        SizedBox(height: 8),
                        Text('Temperature: $temperature'),
                        SizedBox(height: 8),
                        Text('Humidity: $humidity'),
                        SizedBox(height: 8),
                        Text('Wind Speed: $windSpeed'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}