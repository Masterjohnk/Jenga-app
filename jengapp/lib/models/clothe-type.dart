class ClothType {
  final String clothe;

  ClothType({
    required this.clothe,
  });

  factory ClothType.fromJson(Map<String, dynamic> json) {
    return ClothType(
      clothe: json['name'] ?? '',

    );
  }
}
