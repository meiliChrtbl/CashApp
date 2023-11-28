class UserData {
  int? id;
  final String nama;
  final String cardNumber;
  final String cardExpiry;
  final double totalAmount;
  // final DateTime transactionAt;

  UserData({
    this.id,
    required this.cardNumber,
    required this.cardExpiry,
    required this.nama,
    required this.totalAmount,
    // this.transactionAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'cardNumber': cardNumber,
      'cardExpiry': cardExpiry,
      'totalAmount': totalAmount,
      // 'transactionAt': transactionAt,
    };
  }
}