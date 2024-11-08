import 'package:expense_manager/component/resources/app_color.dart';
import 'package:expense_manager/ui/addExpenseScreen.dart';
import 'package:flutter/material.dart';

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
              color: AppColors.contentColorBlack,
            ),
          ),
        ),
      ],
    );
  }

  static onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.home:
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return const AddExpenseScreen(
              type: "add_spend",
              click: 1,
            );
          },
        )).then((value) {
          if (value == true) {
            (context as Element).reassemble();
          }
        });
        break;
      case MenuItems.share:
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return const AddExpenseScreen(
              type: "add_revenue",
              click: 1,
            );
          },
        )).then((value) {
          if (value == true) {
            (context as Element).reassemble();
          }
        });
        break;
    }
  }
}
