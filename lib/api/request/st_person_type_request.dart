class StPersonTypeRequest{
  final String personType;

  StPersonTypeRequest({
    required this.personType,
  });

  Map<String, dynamic> toJson() {
    return {
      'personType': personType,
    };
  }

  debugPrint() {
    print('Person Type: $personType');
  }
}