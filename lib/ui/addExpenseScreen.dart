import 'dart:ui';

import 'package:expense_manager/component/resources/app_bar.dart';
import 'package:expense_manager/component/resources/app_color.dart';
import 'package:expense_manager/component/resources/bottomSheet.dart';
import 'package:expense_manager/component/resources/custom_button.dart';
import 'package:expense_manager/component/resources/custom_dropdown.dart';
import 'package:expense_manager/component/resources/custom_input.dart';
import 'package:expense_manager/component/resources/data.dart';
import 'package:expense_manager/component/resources/format.dart';
import 'package:expense_manager/component/resources/padding.dart';
import 'package:expense_manager/component/resources/status_notification.dart';
import 'package:expense_manager/helpers/navigation_helper.dart';
import 'package:expense_manager/service/dataService.dart';
import 'package:expense_manager/ui/dashboardScreen.dart';
import 'package:flutter/material.dart';

class AddExpenseScreen extends StatefulWidget {
  final String type;
  final int click;
  final Map<String, dynamic>? data;
  const AddExpenseScreen(
      {super.key, required this.type, required this.click, this.data});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

final _formKey = GlobalKey<FormState>();
double _amount = 0;
String _category = '';
DateTime _selectedDate = DateTime.now();

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  Map<String, dynamic>? selectedCategory;
  String _selectedValue = '';
  final _priceController = TextEditingController();
  final _dateController = TextEditingController();
  int click = 0;
  String formatAmount() {
    String rawText = _priceController.text;
    String formattedText = rawText.replaceAll('.', '');
    return formattedText;
  }

  String defaultValue() {
    if (widget.data != null) {
      return widget.data!['category'];
    } else {
      return _selectedValue;
    }
  }

  Future<void> _submitExpense() async {
    if (_priceController.text.trim().isEmpty) return;

    final price = int.parse(formatAmount());
    final date = _dateController.text.trim().isNotEmpty
        ? _dateController.text
        : formatDateVN(DateTime.now());

    if (widget.data != null) {
      if (widget.type == "edit_spend") {
        final formData = {
          'amount': price,
          'category': _selectedValue,
          'date': date,
        };
        final res = await editExpense(widget.data!['id'], formData);
        if (res) {
          showNotification(
            isSuccess: true,
            context: context,
            title: 'Thành công',
            message: 'Chỉnh sửa chi thành công',
            type: widget.type,
            click: click,
            widgetClick: widget.click,
          );
        }
      } else {
        final formData = {
          'amount': price,
          'category': _selectedValue,
          'date': date,
        };
        final res = await editRevenues(widget.data!['id'], formData);
        if (res) {
          showNotification(
            isSuccess: true,
            context: context,
            title: 'Thành công',
            message: 'Chỉnh sửa thu thành công',
            type: widget.type,
            click: click,
            widgetClick: widget.click,
          );
        }
      }
    } else {
      if (widget.type == "add_spend") {
        final res = await saveExpense(price, _selectedValue, date);
        if (res) {
          showNotification(
            isSuccess: true,
            context: context,
            title: 'Thành công',
            message: 'Thêm chi tiêu thành công',
            type: widget.type,
            click: click,
            widgetClick: widget.click,
          );
        }
      } else {
        final res = await saveRevenue(price, _selectedValue, date);
        if (res) {
          showNotification(
            isSuccess: true,
            context: context,
            title: 'Thành công',
            message: 'Thêm doanh thu thành công',
            type: widget.type,
            click: click,
            widgetClick: widget.click,
          );
        }
      }
    }
  }

  Future<void> _selectedDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      locale: const Locale('vi', 'VN'),
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light().copyWith(
              primary: AppColors.contentColorGreen,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (_picked != null) {
      setState(() {
        _dateController.text = formatDateVN(_picked).toString().split(" ")[0];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.data != null) {
      _selectedValue = widget.data!['category'];
      _priceController.text = formatPrice(widget.data!['amount']).toString();
      _dateController.text = widget.data!['date'].toString().split(" ")[0];
    } else {
      _selectedValue =
          widget.type == "add_spend" ? 'Chi tiêu thiết yếu' : "Lương thưởng";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.type == "add_spend"
            ? "Thêm chi tiêu"
            : widget.type == "add_revenue"
                ? "Thêm doanh thu"
                : widget.type == "edit_spend"
                    ? "Chỉnh sửa chi tiêu"
                    : "Chỉnh sửa doanh thu",
      ),
      // backgroundColor: AppColors.bgColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.screenBgColor,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: CustomPadding(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomDropdown(
                    defaultValue: defaultValue(),
                    label: widget.type == "add_spend"
                        ? 'Danh mục chi tiêu'
                        : "Danh mục thu",
                    hintTitle: 'Select category',
                    dropdownItems: widget.type == "add_spend"
                        ? spend_categories
                        : revenue_categories,
                    onItemSelected: (value) {
                      if (!mounted) return;
                      setState(() {
                        _selectedValue = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: const Text(
                      'Số tiền',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.itemsBackground,
                      ),
                    ),
                  ),
                  CustomInput(
                    text: "Số tiền",
                    keyboardType: "number",
                    controller: _priceController,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: const Text(
                      'Ngày',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.itemsBackground,
                      ),
                    ),
                  ),
                  Container(
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
                      controller: _dateController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.contentColorWhite,
                        contentPadding: const EdgeInsets.all(15),
                        hintText: "Ngày",
                        hintStyle: const TextStyle(
                            fontSize: 14, color: AppColors.contentColorGrey),
                        suffixIcon: const Icon(Icons.calendar_month_outlined),
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
                      readOnly: true,
                      onTap: () {
                        _selectedDate();
                      },
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "*Lưu ý: Nếu không chọn ngày hệ thống sẽ tự động chọn ngày hôm nay",
                    style: TextStyle(color: AppColors.contentColorRed),
                  ),
                  const Spacer(),
                  CustomButton(
                    textButton: "Xác nhận",
                    onPressed: _submitExpense,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
