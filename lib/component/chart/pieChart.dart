import 'package:expense_manager/component/resources/app_color.dart';
import 'package:expense_manager/component/resources/format.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PieChartSample3 extends StatefulWidget {
  final List<Map<String, dynamic>> listData;
  final List<Map<String, dynamic>> listIcon;
  const PieChartSample3(
      {super.key, required this.listData, required this.listIcon});

  @override
  State<StatefulWidget> createState() => PieChartSample3State();
}

class PieChartSample3State extends State<PieChartSample3> {
  int touchedIndex = -1;
  final totalPercent = 100;
  String getIcon(String categoryName) {
    for (int i = 0; i < widget.listIcon.length; i++) {
      if (categoryName == widget.listIcon[i]['name']) {
        return widget.listIcon[i]['icon'];
      }
    }

    return 'assets/icons/other-svgrepo-com.svg';
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> combinedSpendList =
        combineSpendByCategory(widget.listData);
    return AspectRatio(
      aspectRatio: 1.3,
      child: AspectRatio(
        aspectRatio: 1,
        child: PieChart(
          PieChartData(
            pieTouchData: PieTouchData(
              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                setState(() {
                  if (!event.isInterestedForInteractions ||
                      pieTouchResponse == null ||
                      pieTouchResponse.touchedSection == null) {
                    touchedIndex = -1;
                    return;
                  }
                  touchedIndex =
                      pieTouchResponse.touchedSection!.touchedSectionIndex;
                });
              },
            ),
            borderData: FlBorderData(
              show: false,
            ),
            sectionsSpace: 0,
            centerSpaceRadius: 0,
            sections: showingSections(combinedSpendList),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(
      List<Map<String, dynamic>> combinedSpendList) {
    double totalSpend =
        combinedSpendList.fold(0, (sum, category) => sum + category['amount']);
    return List.generate(combinedSpendList.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 140.0 : 130.0;
      final widgetSize = isTouched ? 65.0 : 55.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      double percent = (combinedSpendList[i]['amount'] / totalSpend) * 100;

      Color? sectionColor;
      for (int j = 0; j < widget.listIcon.length; j++) {
        if (combinedSpendList[i]['category'] == widget.listIcon[j]['name']) {
          sectionColor = widget.listIcon[j]['color'];
          break;
        }
      }
      return PieChartSectionData(
        color: sectionColor ?? AppColors.contentColorGrey,
        value: percent, // Giá trị phần trăm của từng phần
        title: '${percent.toStringAsFixed(1)}%', // Hiển thị phần trăm
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
          shadows: shadows,
        ),
        // badgeWidget: _Badge(
        //   getIcon(combinedSpendList[i]['category']), // Biểu tượng cho từng mục
        //   size: widgetSize,
        //   borderColor: AppColors.contentColorBlack,
        // ),
        badgePositionPercentageOffset: .98,
      );
    });
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
    this.svgAsset, {
    required this.size,
    required this.borderColor,
  });
  final String svgAsset;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: SvgPicture.asset(
          svgAsset,
        ),
      ),
    );
  }
}
