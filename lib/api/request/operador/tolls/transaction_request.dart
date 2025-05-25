class TransactionRequest {
  final int vehicleId;
  final int tollId;
  final int walletId;

  TransactionRequest({
    required this.vehicleId,
    required this.tollId,
    required this.walletId,
  });

  // Convertir a Map para JSON
  Map<String, dynamic> toJson() => {
    'vehicleId': vehicleId,
    'tollId': tollId,
    'walletId': walletId,
  };

  // Método para crear una instancia vacía (opcional)
  factory TransactionRequest.createEmpty() => TransactionRequest(
    vehicleId: 0,
    tollId: 0,
    walletId: 0,
  );
}