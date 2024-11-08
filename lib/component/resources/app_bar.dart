import 'package:expense_manager/component/resources/app_color.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final String title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  const CustomAppBar({
    super.key,
    this.leading,
    this.actions,
    this.bottom,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading ??
          IconButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            color: AppColors.contentColorWhite,
          ),
      title: Text(title),
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
      backgroundColor: AppColors.primary,
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize {
    double bottomHeight = bottom?.preferredSize.height ?? 0;
    return Size.fromHeight(kToolbarHeight + bottomHeight);
  }
}
