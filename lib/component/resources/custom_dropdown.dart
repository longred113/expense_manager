import 'package:expense_manager/component/resources/app_color.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final String? defaultValue;
  final void Function(String)? onItemSelected;
  final List<Map<String, dynamic>> dropdownItems;
  final String label;
  final String hintTitle;
  final Function(bool)? onDropdownOpenChanged;
  bool isDropdownOpened = false;
  CustomDropdown({
    super.key,
    required this.label,
    this.defaultValue,
    required this.dropdownItems,
    required this.hintTitle,
    required this.onItemSelected,
    this.onDropdownOpenChanged,
    this.isDropdownOpened = false,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String selectedItem = '';
  @override
  void initState() {
    super.initState();
    if (widget.defaultValue != null) {
      selectedItem = widget.defaultValue!;
    }
  }

  void toggleDropdown() {
    setState(() {
      widget.isDropdownOpened = !widget.isDropdownOpened;
    });
    widget.onDropdownOpenChanged?.call(widget.isDropdownOpened);
    if (widget.isDropdownOpened) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Text(
              widget.label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.itemsBackground,
              ),
            ),
          ),
        GestureDetector(
          onTap: toggleDropdown,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.contentColorWhite,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
              border: Border.all(
                color: AppColors.itemsBackground,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 10, bottom: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedItem == ''
                                ? widget.hintTitle
                                : selectedItem,
                            style: TextStyle(
                              fontFamily: 'SUIT',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: selectedItem == ''
                                  ? AppColors.contentColorOrange
                                  : AppColors.contentColorBlack,
                            ),
                          ),
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: Icon(
                              widget.isDropdownOpened
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              color: AppColors.itemsBackground,
                            ),
                          ),
                        ],
                      ),
                      widget.isDropdownOpened == true
                          ? const SizedBox(height: 10)
                          : const SizedBox(height: 0),
                      Container(
                        height: widget.isDropdownOpened ? 1 : 0,
                        color: AppColors.itemsBackground,
                      ),
                    ],
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: SizedBox(
                    height: widget.isDropdownOpened
                        ? 42 * widget.dropdownItems.length.toDouble()
                        : 0,
                    child: AnimatedOpacity(
                      opacity: widget.isDropdownOpened ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Column(
                        children: widget.dropdownItems
                            .map((item) => GestureDetector(
                                  onTap: () {
                                    handleDropdownItemSelected(item['name']);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 5, top: 1),
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 15),
                                      height: 35,
                                      decoration: BoxDecoration(
                                        // color: item['name'] == selectedItem
                                        //     ? AppColors.contentColorWhite
                                        //     : AppColors.contentColorWhite,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(
                                              widget.dropdownItems.last == item
                                                  ? 15
                                                  : 0),
                                          bottomRight: Radius.circular(
                                              widget.dropdownItems.last == item
                                                  ? 15
                                                  : 0),
                                        ),
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            item['name'],
                                            style: TextStyle(
                                              color: item['name'] ==
                                                      selectedItem
                                                  ? AppColors.contentColorBlack
                                                  : AppColors.itemsBackground,
                                            ),
                                          )),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void handleDropdownItemSelected(String item) {
    setState(() {
      widget.isDropdownOpened = false;
      selectedItem = item;
    });
    widget.onDropdownOpenChanged?.call(false);
    if (widget.onItemSelected != null) {
      widget.onItemSelected!(item);
    }
  }
}
