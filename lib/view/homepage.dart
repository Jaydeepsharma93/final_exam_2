import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/authcontroller.dart';
import '../controller/expensecontroller.dart';
import '../model/modelclass.dart';
import 'loginpage.dart';

class HomePage extends StatelessWidget {
  final ExpenseController expenseController = Get.put(ExpenseController());
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    expenseController.fetchExpenses();

    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Get.find<AuthController>().logout();
              Get.offAll(() => LoginPage());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Title',
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                expenseController.searchQuery.value = query;
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              final filteredExpenses = expenseController.filteredExpenses;
              if (filteredExpenses.isEmpty) {
                return Center(child: Text('No expenses found.'));
              }
              return ListView.builder(
                itemCount: filteredExpenses.length,
                itemBuilder: (context, index) {
                  final expense = filteredExpenses[index];
                  return ListTile(
                    title: Text(expense.title),
                    subtitle: Text('\$${expense.amount} on ${expense.date}'),
                    tileColor: getCategoryColor(expense.category),
                    onTap: () {
                      // Optionally, you can add a tap action if needed
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showEditExpenseDialog(context, expense);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            expenseController.deleteExpense(expense.id!);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddExpenseDialog(context);
        },
        child: Icon(Icons.add),
        tooltip: 'Add Expense',
      ),
    );
  }

  void _showAddExpenseDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _amountController = TextEditingController();
    String _category = 'Food';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Expense'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Expense Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    try {
                      double.parse(value);
                    } catch (_) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _category,
                  items: ['Food', 'Transport', 'Other']
                      .map((category) => DropdownMenuItem(
                    child: Text(category),
                    value: category,
                  ))
                      .toList(),
                  decoration: InputDecoration(labelText: 'Category'),
                  onChanged: (value) {
                    _category = value!;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  final expense = Expense(
                    title: _titleController.text,
                    amount: double.parse(_amountController.text),
                    date: DateTime.now().toString(),
                    category: _category,
                  );
                  expenseController.addExpense(expense);
                  Navigator.pop(context);
                }
              },
              child: Text('Add Expense'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showEditExpenseDialog(BuildContext context, Expense expense) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _titleController = TextEditingController(text: expense.title);
    final TextEditingController _amountController = TextEditingController(text: expense.amount.toString());
    String _category = expense.category;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Expense'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Expense Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    try {
                      double.parse(value);
                    } catch (_) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _category,
                  items: ['Food', 'Transport', 'Other']
                      .map((category) => DropdownMenuItem(
                    child: Text(category),
                    value: category,
                  ))
                      .toList(),
                  decoration: InputDecoration(labelText: 'Category'),
                  onChanged: (value) {
                    _category = value!;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  final updatedExpense = Expense(
                    id: expense.id, // Keep the same ID
                    title: _titleController.text,
                    amount: double.parse(_amountController.text),
                    date: expense.date, // Retain the original date
                    category: _category,
                  );
                  expenseController.updateExpense(updatedExpense);
                  Navigator.pop(context);
                }
              },
              child: Text('Update Expense'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Color getCategoryColor(String category) {
    switch (category) {
      case 'Food':
        return Colors.green;
      case 'Transport':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
