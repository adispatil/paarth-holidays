class WalletModel {
  final int points;
  final String pointsInInr;
  final String unit;
  final String totalEarnedPoints;
  final List<WalletTransaction> transactions;

  WalletModel({
    required this.points,
    required this.pointsInInr,
    required this.unit,
    required this.totalEarnedPoints,
    required this.transactions,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      points: json['points'] ?? 0,
      pointsInInr: json['points_in_inr'] ?? '',
      unit: json['unit'] ?? '',
      totalEarnedPoints: json['total_earned_points'] ?? '',
      transactions: (json['transaction'] as List<dynamic>?)
          ?.map((transaction) => WalletTransaction.fromJson(transaction))
          .toList() ?? [],
    );
  }
}

class WalletTransaction {
  final String date;
  final String type; // 'C' for credit, 'D' for debit
  final int points;
  final String comment;

  WalletTransaction({
    required this.date,
    required this.type,
    required this.points,
    required this.comment,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      date: json['date'] ?? '',
      type: json['type'] ?? '',
      points: json['points'] ?? 0,
      comment: json['comment'] ?? '',
    );
  }
} 