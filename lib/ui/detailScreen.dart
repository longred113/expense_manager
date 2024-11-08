import 'package:expense_manager/component/resources/app_bar.dart';
import 'package:expense_manager/component/resources/app_color.dart';
import 'package:expense_manager/component/resources/bottomSheet.dart';
import 'package:expense_manager/component/resources/format.dart';
import 'package:expense_manager/helpers/navigation_helper.dart';
import 'package:expense_manager/service/dataService.dart';
import 'package:expense_manager/ui/addExpenseScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatefulWidget {
  final List<Map<String, dynamic>> listData;
  final List<Map<String, dynamic>> listTab;
  final int initialTabIndex;
  final String type;
  const DetailScreen({
    super.key,
    required this.listData,
    required this.listTab,
    this.initialTabIndex = 0,
    required this.type,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late int _selectedTabIndex;
  List<Map<String, dynamic>> filteredData = [];
  int _itemsToShow = 10;
  DateTime? _selectedDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedTabIndex = widget.initialTabIndex;
    _fetchData();
  }

  void _fetchData() {
    filteredData = widget.listData.where((expense) {
      return expense['category'] == widget.listTab[_selectedTabIndex]['name'];
    }).toList();
    filteredData.sort((a, b) {
      final dateA = parseDate(a['date']);
      final dateB = parseDate(b['date']);
      if (dateA == null || dateB == null) return 0; // Handle null dates safely
      return dateB.compareTo(dateA); // Sort by newest first
    });
  }

  void _applyFilters() {
    setState(() {
      // Define the possible date formats
      final List<DateFormat> dateFormats = [
        DateFormat('dd/MM/yyyy'), // Format: 12/10/2000
        DateFormat('dd-MM-yyyy'), // Format: 12-2-2000
      ];

      DateTime? parseDate(String dateString) {
        for (DateFormat format in dateFormats) {
          try {
            return format
                .parseStrict(dateString); // Try to parse with each format
          } catch (e) {
            // Continue trying with the next format
          }
        }
        return null; // If none of the formats work, return null
      }

      // Filter data based on the selected date and selected category
      filteredData = widget.listData.where((expense) {
        // Parse the expense date
        final expenseDate = parseDate(expense['date']);
        // If the date cannot be parsed, skip this expense
        if (expenseDate == null) return false;

        // Get the selected category name from the Tab
        final selectedCategory = widget.listTab[_selectedTabIndex]['name'];

        // Filter based on both the selected category and selected date (if any)
        final isCategoryMatch = expense['category'] == selectedCategory;
        final isDateMatch = _selectedDate == null ||
            (expenseDate.year == _selectedDate!.year &&
                expenseDate.month == _selectedDate!.month &&
                expenseDate.day == _selectedDate!.day);

        return isCategoryMatch && isDateMatch; // Return true if both match
      }).toList();

      // Sort filtered data by date (newest first)
      filteredData.sort((a, b) {
        final dateA = parseDate(a['date']);
        final dateB = parseDate(b['date']);
        if (dateA == null || dateB == null)
          return 0; // Handle null dates safely
        return dateB.compareTo(dateA); // Sort by newest first
      });
    });
  }

  void _loadMore() {
    setState(() {
      _itemsToShow += 10;
    });
  }

  Future<void> _deleteItem(expense) async {
    final res = widget.type == 'edit_spend'
        ? await deleteExpense(expense['id'])
        : await deleteRevenue(expense['id']);
    if (res) {
      showNotification(
        isSuccess: true,
        context: context,
        title: "Thành công",
        message: "Xoá thành công",
        type: 'edit_spend',
        click: 2,
        widgetClick: 2,
      );
    } else {
      showNotification(
        isSuccess: false,
        context: context,
        title: "Thất bại",
        message: "Xoá thất bại",
        type: 'edit_spend',
        click: 2,
        widgetClick: 2,
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
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
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _itemsToShow = 10; // Reset to show only the first set of items
        _applyFilters(); // Reapply filters
        _selectedDate = null;
      });
    }
  }

  Future<void> _handleOption(expense) async {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text("Chọn chức năng"),
          actions: [
            CupertinoDialogAction(
              child: const Text(
                "Sửa",
                style: TextStyle(color: AppColors.contentColorGreen),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    createPageRoute(
                      AddExpenseScreen(
                        type: widget.type,
                        click: 2,
                        data: expense,
                      ),
                    )).then((value) {
                  if (value == true) {
                    _fetchData();
                  }
                });
              },
            ),
            CupertinoDialogAction(
              child: const Text(
                "Xoá",
                style: TextStyle(color: AppColors.contentColorRed),
              ),
              onPressed: () {
                _deleteItem(expense);
                // Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.listTab.length,
      initialIndex: _selectedTabIndex,
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Chi tiết giao dịch",
          actions: [
            IconButton(
              onPressed: () {
                _selectDate(context);
              },
              icon: const Icon(Icons.filter_alt_outlined),
              color: AppColors.contentColorWhite,
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            dividerHeight: 0,
            indicatorWeight: 0,
            tabAlignment: TabAlignment.start,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: AppColors.contentColorGrey,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: AppColors.screenBgColor,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            unselectedLabelStyle: const TextStyle(
                color: AppColors.contentColorWhite,
                fontWeight: FontWeight.w500),
            labelStyle: const TextStyle(
                color: AppColors.contentColorBlack,
                fontWeight: FontWeight.w700),
            tabs: [
              for (int i = 0; i < widget.listTab.length; i++)
                Tab(
                  text: widget.listTab[i]['name'],
                ),
            ],
            onTap: (index) {
              setState(() {
                _selectedTabIndex = index;
                _fetchData(); // Step 1: Update selected tab index
              });
            },
          ),
        ),
        body: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.screenBgColor,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredData.length > _itemsToShow
                      ? _itemsToShow
                      : filteredData.length, // Step 2: Use filtered data
                  itemBuilder: (context, index) {
                    final expense = filteredData[index]; // Use filtered expense
                    return InkWell(
                      onTap: () {
                        _handleOption(expense);
                      },
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${expense['category'] != '' ? expense['category'] : 'Không rõ'}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${formatPrice(expense['amount'])}₫',
                              style: const TextStyle(
                                color: AppColors.contentColorGreen,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          '${expense['date']}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.contentColorPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                if (filteredData.length >
                    _itemsToShow) // Show Load More button if there are more items
                  TextButton(
                    onPressed: _loadMore,
                    child: const Text(
                      'Tải thêm',
                      style: TextStyle(
                        color: AppColors.contentColorWhite,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
