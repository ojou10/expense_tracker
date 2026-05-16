class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;
  final String? receiptPath; 

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    this.receiptPath, 
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'amount': amount,
    'date': date.toIso8601String(),
    'category': category,
    'receiptPath': receiptPath, 
  };

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
    id: json['id'],
    title: json['title'],
    amount: (json['amount'] as num).toDouble(),
    date: DateTime.parse(json['date']),
    category: json['category'],
    receiptPath: json['receiptPath'], 
  );
}