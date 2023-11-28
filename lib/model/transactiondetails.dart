class TransactionDetails {
  final int? id;
  final int? transactionId;
  final String? nama;
  final String? senderName;
  final double? transactionAmount;

  TransactionDetails({
    this.id,
    this.transactionId,
    this.nama,
    this.transactionAmount,
    this.senderName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'transactionId': transactionId,
      'nama': nama,
      'senderName': senderName,
      'transactionAmount': transactionAmount,
    };
  }
}
