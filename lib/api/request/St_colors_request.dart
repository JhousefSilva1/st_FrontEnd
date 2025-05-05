
class StColorRquest{
  final String colorName;
  final String colorDescription;
  
  StColorRquest({
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