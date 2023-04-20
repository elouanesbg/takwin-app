class AudioFiles {
  final String name;
  final String title;
  final String length;
  String? onlineUrl = "";

  AudioFiles({
    required this.name,
    required this.title,
    required this.length,
  });

  factory AudioFiles.fromJson(Map<String, dynamic> data) {
    return AudioFiles(
      name: data["name"],
      title: data["title"],
      length: data["length"],
    );
  }

  Map toJson() => {
        "name": name,
        "title": title,
        "length": length,
      };
}
