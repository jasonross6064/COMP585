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

  @override
  void initState() {
    super.initState();
    fetchPlants();
    _scrollController.addListener(_onScroll);
  }

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
      setState(() {
        plants.addAll(data['data']);
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

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !isLoading &&
        !isFetchingMore) {
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
        ],
      ),
    );
  }
}