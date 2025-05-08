class StRoadTypeRequest{
  final String roadType;

  StRoadTypeRequest({
    required this.roadType,
  });

  Map<String, dynamic> toJson() {
    return {
      'roadType': roadType,
    };
  }
}