import 'package:flutter/material.dart';

class GardeningTipsPage extends StatelessWidget {
  final List<Map<String, String>> gardeningTopics = [
    {'title': 'Vegetable Gardening', 'image': 'assets/vegetable_gardening.jpg'},
    {'title': 'Flower Gardening', 'image': 'assets/flower_gardening.jpg'},
    {'title': 'Herb Gardening', 'image': 'assets/herb_gardening.jpg'},
    {'title': 'Indoor Plants', 'image': 'assets/indoor_plants.jpg'},
    {'title': 'Organic Gardening', 'image': 'assets/organic_gardening.jpg'},
    {'title': 'Pest Control', 'image': 'assets/pest_control.jpg'},
    {'title': 'Landscape Design', 'image': 'assets/landscape_design.jpg'},
    {'title': 'Garden Tools', 'image': 'assets/garden_tools.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two items per row
            crossAxisSpacing: 8.0, // Space between columns
            mainAxisSpacing: 8.0, // Space between rows
            childAspectRatio: 1.0, // Square aspect ratio for each item
          ),
          itemCount: gardeningTopics.length,
          itemBuilder: (context, index) {
            return GardeningTopicCard(
              title: gardeningTopics[index]['title']!,
              imagePath: gardeningTopics[index]['image']!,
            );
          },
        ),
      ),
    );
  }
}

class GardeningTopicCard extends StatelessWidget {
  final String title;
  final String imagePath;

  GardeningTopicCard({required this.title, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // You can navigate to a detailed page or perform other actions
          print('Tapped on $title');
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4), // Dark overlay for fading effect
                BlendMode.darken,
              ),
            ),
          ),
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.white, // White text to stand out on dark background
                shadows: [
                  Shadow(
                    blurRadius: 5.0,
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}