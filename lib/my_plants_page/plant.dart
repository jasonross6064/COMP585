class Plant {
  String name;
  String species;
  int age; // in years
  int wateringLevel; // from 0 to 100 (percent)
  int happinessLevel; // from 0 to 100 (percent)
  String image;  // Path to the plant image or URL for image

  Plant({
    required this.name,
    required this.species,
    required this.age,
    required this.wateringLevel,
    required this.happinessLevel,
    required this.image,  // Initialize image path
  });
}