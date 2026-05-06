class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;

  Expense({required this.id, required this.title, required this.amount, required this.date, required this.category});

  // Serialization (Lab 7)
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'amount': amount,
    'date': date.toIso8601String(),
    'category': category,
  };

  // Deserialization (Lab 7)
  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
    id: json['id'],
    title: json['title'],
    // FIXED: 'as num' allows both ints and doubles to be parsed safely
    amount: (json['amount'] as num).toDouble(), 
    date: DateTime.parse(json['date']),
    category: json['category'],
  );
}