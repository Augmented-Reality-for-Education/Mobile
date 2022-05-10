import 'ar_image.dart';

class ArSequence {
  final int id;
  final String? name;
  final List<ArImage>? images;

  ArSequence({
    required this.id,
    required this.name,
    required this.images,
  });

  factory ArSequence.fromJson(Map<String, dynamic> json) {
    var images = (json['images'] as List)
        .map((image) => ArImage.fromJson(image))
        .toList();

    return ArSequence(
      id: json['id'],
      name: json['name'],
      images: images,
    );
  }
}
