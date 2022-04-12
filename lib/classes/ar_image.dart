class ArImage {
  final int id;
  final String? name;
  final String? dataUrl;

  ArImage({
    required this.id,
    required this.name,
    required this.dataUrl,
  });

  factory ArImage.fromJson(Map<String, dynamic> json) {
    return ArImage(
      id: json['id'],
      name: json['name'],
      dataUrl: json['dataUrl'],
    );
  }
}
