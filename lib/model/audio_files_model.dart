class AudioFiles {
  final String name;
  final String title;
  final String length;

  AudioFiles({required this.name, required this.title, required this.length});

  factory AudioFiles.fromJson(Map<String, dynamic> data) {
    return AudioFiles(
        name: data["name"], title: data["title"], length: data["length"]);
  }
}
