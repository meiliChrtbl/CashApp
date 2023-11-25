class TransactionDetails {
  final int id;
  final int transactionId;
  final String userName;
  final String senderName;
  final double transactionAmount;
  // final bool transactionDone;

  TransactionDetails({
    required this.id,
    required this.transactionId,
    required this.userName,
    required this.transactionAmount,
    required this.senderName,
    // this.transactionDone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'transactionId': transactionId,
      'userName': userName,
      'senderName': senderName,
      'transactionAmount': transactionAmount,
      // 'transactionDone': transactionDone,
    };
  }
}