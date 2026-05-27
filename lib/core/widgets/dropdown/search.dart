import 'package:apploan/core/configs/app_style.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class SearchDropDown<T> extends StatelessWidget {
  const SearchDropDown({
    Key? key,
    required this.items,
    required this.onChanged,
    required this.itemAsString,
    this.selectedItem,
  }) : super(key: key);

  final List<T> items;
  final Function(T?) onChanged;
  final String Function(T) itemAsString;
  final T? selectedItem;

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      items: items,
      itemAsString: itemAsString,
      selectedItem: selectedItem,
      onChanged: onChanged,

      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColor.darkGrey, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColor.darkGrey, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColor.darkGrey, width: 1),
          ),
        ),
      ),

      popupProps: PopupProps.menu(
        showSearchBox: true,
        menuProps: MenuProps(
          backgroundColor: const Color(0xFFFFF5F5),
          borderRadius: BorderRadius.circular(10),
          elevation: 4,
        ),
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 12.0),
            hintText: 'Search...',
            hintStyle: TextStyle(color: AppColor.darkGrey, fontSize: 14),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.lightred),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.darkGrey, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
