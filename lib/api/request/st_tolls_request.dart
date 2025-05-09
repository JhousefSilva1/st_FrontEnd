class StTollsRequest{
  final String tollName;

  StTollsRequest({
    required this.tollName,
  });

  Map<String, dynamic> toJson() {
    return {
      'tollName': tollName,
    };
  }
}