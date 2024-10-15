class Expense {
  final int? id;
  final String title;
  final double amount;
  final String date;
  final String category;

  Expense({this.id, required this.title, required this.amount, required this.date, required this.category});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date,
      'category': category,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      date: map['date'],
      category: map['category'],
    );
  }
}
