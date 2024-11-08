import 'package:expense_manager/component/resources/app_bar.dart';
import 'package:expense_manager/component/resources/app_color.dart';
import 'package:expense_manager/component/resources/format.dart';
import 'package:expense_manager/component/resources/padding.dart';
import 'package:expense_manager/service/dataService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailByMonthScreen extends StatefulWidget {
  const DetailByMonthScreen({super.key});

  @override
  State<DetailByMonthScreen> createState() => _DetailByMonthScreenState();
}

class _DetailByMonthScreenState extends State<DetailByMonthScreen> {
  List<Map<String, dynamic>> _expenseData = [];

  List<Map<String, dynamic>> _revenueData = [];

  Map<String, Map<String, dynamic>> _groupedData = {};
  Future<void> _fetchExpenses() async {
    await getExpenses('').then((expenses) {
      setState(() {
        _expenseData = expenses;
        // totalSpent = calculateTotal(expenses);
      });
    });
  }

  Future<void> _fetchRevenue() async {
    await getRevenues('').then((revenues) {
      setState(() {
        _revenueData = revenues;
        // budget = calculateTotal(revenues);
      });
    });
  }

  Future<void> _groupDataByMonth() async {
    Map<String, Map<String, dynamic>> groupedData = {};
    await _fetchExpenses();
    await _fetchRevenue();
    for (var expense in _expenseData) {
      DateTime? date = parseDate(expense['date']);
      String monthKey = DateFormat('MM/yyyy').format(date!);

      // Nếu chưa có key cho tháng này, khởi tạo
      if (!groupedData.containsKey(monthKey)) {
        groupedData[monthKey] = {
          'expenses': [],
          'revenues': [],
          'totalSpend': 0,
          'totalBudget': 0,
          'remainingBudget': 0
        };
      }

      // Thêm chi tiêu vào tháng tương ứng
      groupedData[monthKey]!['expenses']!.add(expense);

      // Cộng dồn chi tiêu
      groupedData[monthKey]!['totalSpend'] += expense['amount'];
    }

    // Xử lý thu nhập
    for (var revenue in _revenueData) {
      DateTime? date = parseDate(revenue['date']);
      String monthKey = DateFormat('MM/yyyy').format(date!);

      // Nếu chưa có key cho tháng này, khởi tạo
      if (!groupedData.containsKey(monthKey)) {
        groupedData[monthKey] = {
          'expenses': [],
          'revenues': [],
          'totalSpend': 0,
          'totalBudget': 0,
          'remainingBudget': 0
        };
      }

      // Thêm thu nhập vào tháng tương ứng
      groupedData[monthKey]!['revenues']!.add(revenue);

      // Cộng dồn thu nhập
      groupedData[monthKey]!['totalBudget'] += revenue['amount'];
    }
    for (var monthKey in groupedData.keys) {
      groupedData[monthKey]!['remainingBudget'] =
          groupedData[monthKey]!['totalBudget'] -
              groupedData[monthKey]!['totalSpend'];
    }
    setState(() {
      _groupedData = groupedData;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _groupDataByMonth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Biến động thu/chi"),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.screenBgColor,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: CustomPadding(
          child: Column(
            children: [
              for (var monthKey in _groupedData.keys)
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.contentColorWhite,
                      // gradient: const LinearGradient(
                      //   colors: [Color(0xFF07d681), Color(0xFF07a98b)],
                      // ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      )),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          rowPrice(
                            monthKey,
                            formatPrice(
                                _groupedData[monthKey]!['remainingBudget']),
                            AppColors.contentColorBlack,
                          ),
                          const Divider(
                            color: AppColors.gridLinesColor,
                            thickness: 1,
                            height: 15,
                          ),
                          rowPrice(
                              "Tổng thu",
                              formatPrice(
                                  _groupedData[monthKey]!['totalBudget']),
                              Colors.green),
                          const SizedBox(height: 10),
                          rowPrice(
                              "Tổng chi",
                              formatPrice(
                                  _groupedData[monthKey]!['totalSpend']),
                              AppColors.contentColorRed),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget rowPrice(String monthKey, String amount, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          monthKey,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          '$amount₫',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
