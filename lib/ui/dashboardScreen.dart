import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:expense_manager/component/resources/app_color.dart';
import 'package:expense_manager/component/resources/data.dart';
import 'package:expense_manager/component/resources/format.dart';
import 'package:expense_manager/helpers/navigation_helper.dart';
import 'package:expense_manager/service/dataService.dart';
import 'package:expense_manager/ui/addExpenseScreen.dart';
import 'package:expense_manager/ui/chartTabScreen.dart';
import 'package:expense_manager/ui/detailByMonthScreen.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int remainingBudget = 0;
  int totalSpent = 0;
  int budget = 0;
  List<Map<String, dynamic>> _expenseData = [];

  List<Map<String, dynamic>> _revenueData = [];
  Future<void> _fetchExpenses() async {
    await getExpenses(formatMonth(DateTime.now())).then((expenses) {
      setState(() {
        _expenseData = expenses;
        totalSpent = calculateTotal(expenses);
      });
    });
  }

  Future<void> _fetchRevenue() async {
    await getRevenues(formatMonth(DateTime.now())).then((revenues) {
      setState(() {
        _revenueData = revenues;
        budget = calculateTotal(revenues);
      });
    });
  }

  Future<void> calculatorData() async {
    await _fetchRevenue();
    await _fetchExpenses();
    remainingBudget = budget - totalSpent;
  }

  @override
  void initState() {
    super.initState();
    // deleteExpense(0);
    // deleteRevenue(0);
    calculatorData();
  }

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: listObject.length,
      child: Scaffold(
        appBar: AppBar(
          leading: Container(
            margin: const EdgeInsets.only(left: 10),
            child: Image.asset('assets/images/dragon-removebg.png'),
          ),
          title: const Text('Quản lý tài chính'),
          titleTextStyle: const TextStyle(
            color: AppColors.contentColorWhite,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.appBarColor,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          elevation: 10,
          shadowColor: Colors.black.withOpacity(0.7),
          actions: [
            DropdownButtonHideUnderline(
              child: DropdownButton2(
                customButton: const Icon(
                  Icons.format_list_bulleted,
                  size: 30,
                  color: AppColors.contentColorWhite,
                ),
                items: [
                  ...MenuItems.firstItems.map(
                    (item) => DropdownMenuItem<MenuItem>(
                      value: item,
                      child: MenuItems.buildItem(item),
                    ),
                  ),
                ],
                onChanged: (value) async {
                  MenuItems.onChanged(context, value! as MenuItem, this);
                },
                dropdownStyleData: DropdownStyleData(
                  width: 160,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primary,
                    gradient:
                        const LinearGradient(colors: AppColors.appBarColor),
                  ),
                  offset: const Offset(0, 8),
                ),
                menuItemStyleData: MenuItemStyleData(
                  customHeights: [
                    ...List<double>.filled(MenuItems.firstItems.length, 48),
                    // 8,
                    // ...List<double>.filled(MenuItems.secondItems.length, 48),
                  ],
                  padding: const EdgeInsets.only(left: 16, right: 16),
                ),
              ),
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.screenBgColor,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        createPageRoute(const DetailByMonthScreen()),
                      );
                    },
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Text(
                                'Tổng chi tiêu tháng này:',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              '${formatPrice(totalSpent)}₫',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Text(
                                'Ngân sách còn lại:',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              '${formatPrice(remainingBudget)}₫',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: remainingBudget > 0
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: AppColors.contentColorBlack,
                    dividerHeight: 0,
                    unselectedLabelColor: AppColors.contentColorBlack,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: AppColors.screenBgColor,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    tabs: listObject.map((object) {
                      return Tab(text: object['name']);
                    }).toList(),
                  ),
                ),
              ),
              // Expanded để TabBarView chiếm hết không gian còn lại
              Expanded(
                child: TabBarView(
                  children: listObject.map((object) {
                    return object['name'] == "Chi tiêu"
                        ? ChartTabScreen(
                            expenseData: _expenseData,
                            title: "Biểu đồ chi tiêu",
                            subTitle: "Danh sách chi tiêu",
                            noteList: spend_categories,
                            type: 'edit_spend',
                          )
                        : ChartTabScreen(
                            expenseData: _revenueData,
                            title: "Biểu đồ thu nhập",
                            subTitle: "Danh sách thu nhập",
                            noteList: revenue_categories,
                            type: 'edit_revenue',
                          );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuItem {
  const MenuItem({
    required this.text,
    required this.icon,
  });

  final String text;
  final IconData icon;
}

abstract class MenuItems {
  static const List<MenuItem> firstItems = [home, share];
  // static const List<MenuItem> secondItems = [logout];

  static const home = MenuItem(text: 'Thêm chi tiêu', icon: Icons.add);
  static const share = MenuItem(text: 'Thêm doanh thu', icon: Icons.share);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        // Icon(item.icon, color: AppColors.contentColorOrange, size: 22),
        // const SizedBox(
        //   width: 10,
        // ),
        Expanded(
          child: Text(
            item.text,
            style: const TextStyle(
              color: AppColors.contentColorWhite,
            ),
          ),
        ),
      ],
    );
  }

  static void onChanged(
      BuildContext context, MenuItem item, _DashboardScreenState state) {
    switch (item) {
      case MenuItems.home:
        Navigator.push(
            context,
            createPageRoute(
              const AddExpenseScreen(
                type: "add_spend",
                click: 1,
              ),
            )).then((value) {
          if (value == true) {
            state.calculatorData();
          }
        });
        break;
      case MenuItems.share:
        Navigator.push(
            context,
            createPageRoute(
              const AddExpenseScreen(
                type: "add_revenue",
                click: 1,
              ),
            )).then((value) {
          if (value == true) {
            state.calculatorData();
          }
        });
        break;
    }
  }
}
