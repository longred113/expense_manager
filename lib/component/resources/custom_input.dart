import 'package:expense_manager/component/resources/app_color.dart';
import 'package:expense_manager/component/resources/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CustomInput extends StatelessWidget {
  final String text;
  final String keyboardType;
  final TextEditingController controller;
  const CustomInput({
    super.key,
    required this.text,
    required this.keyboardType,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        // style: TextStyle(color: AppColors.contentColorWhite),
        // focusNode: _titleFocusNode,
        controller: controller,

        keyboardType:
            keyboardType == "Text" ? TextInputType.text : TextInputType.number,
        inputFormatters: keyboardType == "Text"
            ? []
            : [
                FilteringTextInputFormatter.digitsOnly,
                // CurrencyInputFormatter(),
                PriceFormatter()
              ],
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.contentColorWhite,
          contentPadding: const EdgeInsets.all(15),
          hintText: text,
          hintStyle:
              const TextStyle(fontSize: 14, color: AppColors.contentColorGrey),
          suffixText: "VND",
          suffixStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.contentColorBlack,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(
              color: AppColors.itemsBackground,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(
              color: AppColors.itemsBackground,
            ),
          ),
        ),
      ),
    );
  }
}

class PriceFormatter extends TextInputFormatter {
  final NumberFormat _currencyFormat =
      NumberFormat.currency(locale: 'vi_VN', symbol: '', decimalDigits: 0);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    final price = double.tryParse(text.replaceAll(',', ''));
    if (price != null) {
      final formattedPrice = _currencyFormat.format(price);
      return TextEditingValue(
        text: formattedPrice,
        selection: TextSelection.fromPosition(
          TextPosition(offset: formattedPrice.length - 1),
        ),
      );
    }
    return newValue;
  }
}
