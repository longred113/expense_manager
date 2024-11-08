import 'package:expense_manager/component/chart/pieChart.dart';
import 'package:expense_manager/component/resources/padding.dart';
import 'package:expense_manager/helpers/navigation_helper.dart';
import 'package:expense_manager/ui/detailScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChartTabScreen extends StatefulWidget {
  final List<Map<String, dynamic>> expenseData;
  final String title;
  final String subTitle;
  final String type;
  final List<Map<String, dynamic>> noteList;
  const ChartTabScreen({
    super.key,
    required this.expenseData,
    required this.title,
    required this.subTitle,
    required this.noteList,
    required this.type,
  });

  @override
  State<ChartTabScreen> createState() => _ChartTabScreenState();
}

class _ChartTabScreenState extends State<ChartTabScreen> {
  @override
  Widget build(BuildContext context) {
    return widget.expenseData.isEmpty
        ? Container()
        : CustomPadding(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: CustomPadding(
                  child: Column(
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      PieChartSample3(
                        listData: widget.expenseData,
                        listIcon: widget.noteList,
                      ),
                      const SizedBox(height: 20),
                      Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget.noteList.map((cate) {
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  int tabIndex = widget.noteList.indexWhere(
                                      (tab) => tab["name"] == cate['name']);
                                  Navigator.push(
                                      context,
                                      createPageRoute(
                                        DetailScreen(
                                          listData: widget.expenseData,
                                          listTab: widget.noteList,
                                          initialTabIndex: tabIndex,
                                          type: widget.type,
                                        ),
                                      ));
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          cate['icon'],
                                          height: 30,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(cate['name']),
                                      ],
                                    ),
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: cate['color'],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
