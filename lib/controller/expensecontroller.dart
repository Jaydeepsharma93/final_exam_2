import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../model/modelclass.dart';
import 'databasehelper.dart';


class ExpenseController extends GetxController {
  var expenses = <Expense>[].obs;
  var searchQuery = ''.obs;

  void fetchExpenses() async {
    expenses.value = await DatabaseHelper().getAllExpenses();
  }

  Future<void> addExpense(Expense expense) async {
    await DatabaseHelper().insertExpense(expense);
    fetchExpenses();
    await syncWithFirestore();
  }

  Future<void> updateExpense(Expense expense) async {
    await DatabaseHelper().updateExpense(expense);
    fetchExpenses();
    await syncWithFirestore();
  }

  Future<void> deleteExpense(int id) async {
    await DatabaseHelper().deleteExpense(id);
    fetchExpenses();
    await syncWithFirestore();
  }

  Future<void> syncWithFirestore() async {
    for (var expense in expenses) {
      await FirebaseFirestore.instance.collection('expenses').doc(expense.id.toString()).set(expense.toMap());
    }
  }

  List<Expense> get filteredExpenses {
    if (searchQuery.value.isEmpty) return expenses;
    return expenses.where((expense) => expense.title.toLowerCase().contains(searchQuery.value.toLowerCase())).toList();
  }
}
