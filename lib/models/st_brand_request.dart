class BrandRequest {
  final String name;
  final String description;

  BrandRequest({
    required this.name,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
    };
  }

  factory BrandRequest.fromJson(Map<String, dynamic> json) {
    return BrandRequest(
      name: json['name'],
      description: json['description'],
    );
  }
}