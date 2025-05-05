
class StColorRequest{
  final String colorName;
  final String colorDescription;
  
  StColorRequest({
    required this.colorName,
    required this.colorDescription,
  });

  Map<String, dynamic> toJson() {
    return {
      'colorName': colorName,
      'colorDescription': colorDescription,
    };
  }

  debugPrint() {
    print('Color Name: $colorName');
    print('Color Description: $colorDescription');
  }
}