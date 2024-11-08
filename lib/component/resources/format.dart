import 'package:intl/intl.dart';

String formatPrice(int number) {
  final NumberFormat _currencyFormat =
      NumberFormat.currency(locale: 'vi_VN', symbol: '', decimalDigits: 0);

  String formattedText = _currencyFormat.format(number);

  return formattedText;
}

int calculateTotal(list) {
  int total = 0;
  for (var data in list) {
    total += data['amount'] as int;
  }
  return total;
}

List<Map<String, dynamic>> combineSpendByCategory(
    List<Map<String, dynamic>> listSpend) {
  Map<String, int> combined = {};
  for (var spend in listSpend) {
    String category = spend['category'];
    int amount = spend['amount'];
    if (combined.containsKey(category)) {
      combined[category] = combined[category]! + amount;
    } else {
      combined[category] = amount;
    }
  }

  return combined.entries
      .map((entry) => {'category': entry.key, 'amount': entry.value})
      .toList();
}

String formatDateVN(DateTime date) {
  return DateFormat('dd/MM/yyyy').format(date);
}

DateTime? parseDate(String dateString) {
  final List<DateFormat> dateFormats = [
    DateFormat('dd/MM/yyyy'), // Format: 12/10/2000
    DateFormat('yyyy-MM-dd'), // Format: 12-2-2000
  ];
  for (DateFormat format in dateFormats) {
    try {
      return format.parseStrict(dateString); // Try to parse with each format
    } catch (e) {
      // Continue trying with the next format
    }
  }
  return null;
}

String formatMonth(DateTime dateTime) {
  return DateFormat('MM').format(dateTime);
}
