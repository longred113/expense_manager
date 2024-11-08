import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

int _id = 0;

Future<bool> saveExpense(int amount, String category, String date) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> expenses = prefs.getStringList('expenses') ?? [];
  int id = expenses.isNotEmpty ? int.parse(expenses.last.split('|')[0]) + 1 : 0;
  expenses.add('$id|$amount|$category|$date');

  final data = await prefs.setStringList('expenses', expenses);
  return data;
}

Future<List<Map<String, dynamic>>> getExpenses(String month) async {
  final prefs = await SharedPreferences.getInstance();
  final dateFormat = DateFormat('dd/MM/yyyy');
  List<String> expenses = prefs.getStringList('expenses') ?? [];
  List<Map<String, dynamic>> parsedExpenses = [];

  for (var expense in expenses) {
    var data = expense.split('|');
    try {
      DateTime parsedDate = dateFormat.parse(data[3]);
      if (month.isEmpty || parsedDate.month.toString() == month) {
        parsedExpenses.add({
          'id': int.parse(data[0]),
          'amount': int.parse(data[1]),
          'category': data[2],
          'date': data[3]
        });
      }
    } catch (e) {
      print('Error parsing date: $e');
    }
  }
  return parsedExpenses;
}

Future<bool> editExpense(int index, Map<String, dynamic> updatedExpense) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> expenses = prefs.getStringList('expenses') ?? [];

  if (index >= 0 && index < expenses.length) {
    expenses[index] =
        '${index}|${updatedExpense['amount']}|${updatedExpense['category']}|${updatedExpense['date']}';

    final data = await prefs.setStringList('expenses', expenses);
    return data;
  }
  return false;
}

Future<bool> deleteExpense(int id) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> expenses = prefs.getStringList('expenses') ?? [];
  expenses.removeWhere((expense) => int.parse(expense.split('|')[0]) == id);
  return await prefs.setStringList('expenses', expenses);
}

Future<bool> saveRevenue(int amount, String category, String date) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> revenue = prefs.getStringList('revenue') ?? [];
  int id = revenue.isNotEmpty ? int.parse(revenue.last.split('|')[0]) + 1 : 0;
  revenue.add('$id|$amount|$category|$date');

  final data = await prefs.setStringList('revenue', revenue);
  return data;
}

Future<List<Map<String, dynamic>>> getRevenues(String month) async {
  final prefs = await SharedPreferences.getInstance();
  final dateFormat = DateFormat('dd/MM/yyyy');
  List<String> revenues = prefs.getStringList('revenue') ?? [];
  List<Map<String, dynamic>> parsedRevenues = [];
  for (var revenue in revenues) {
    var data = revenue.split('|');
    try {
      DateTime parsedDate = dateFormat.parse(data[3]);
      if (month.isEmpty || parsedDate.month.toString() == month) {
        parsedRevenues.add({
          'id': int.parse(data[0]),
          'amount': int.parse(data[1]),
          'category': data[2],
          'date': data[3]
        });
      }
    } catch (e) {
      print('Error parsing date: $e');
    }
  }
  return parsedRevenues;
}

Future<bool> editRevenues(
    int index, Map<String, dynamic> updatedRevenue) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> revenues = prefs.getStringList('revenue') ?? [];
  if (index >= 0 && index < revenues.length) {
    revenues[index] =
        '${index}|${updatedRevenue['amount']}|${updatedRevenue['category']}|${updatedRevenue['date']}';

    final data = await prefs.setStringList('revenue', revenues);
    return data;
  }
  return false;
}

Future<bool> deleteRevenue(int id) async {
  final prefs = await SharedPreferences.getInstance();
  // await prefs.remove('revenue');
  List<String> revenues = prefs.getStringList('revenue') ?? [];
  revenues.removeWhere((revenue) => int.parse(revenue.split('|')[0]) == id);
  return await prefs.setStringList('revenue', revenues);
}
