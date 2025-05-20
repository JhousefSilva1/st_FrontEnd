class StGenderRequest {
  final String genderName;

  StGenderRequest({
    required this.genderName,
  });
  Map<String, dynamic> toJson() {
    return {
      'genderName': genderName,
    };
  }

  debugPrint() {
    print('Gender Name: $genderName');
  }
}