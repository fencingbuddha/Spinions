class PersonalityMode {
  final String id;

  final String name;

  final List<String> quotes;

  PersonalityMode({required this.id, required this.name, required this.quotes});

  factory PersonalityMode.fromJson(String id, Map<String, dynamic> json) {
    return PersonalityMode(
      id: id,
      name: id[0].toUpperCase() + id.substring(1),
      quotes: List<String>.from(json as Iterable),
    );
  }
}
