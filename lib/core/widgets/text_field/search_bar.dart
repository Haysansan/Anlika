import 'package:flutter/material.dart';
import 'package:apploan/core/core.dart';

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    Key? key,
    required this.controller,
    this.hintText,
    this.onSubmitted,
    this.onChanged,
    this.onClear,
  }) : super(key: key);

  final TextEditingController controller;
  final String? hintText;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onFieldSubmitted: onSubmitted,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hintText ?? 'Search by CID or Client name...',
        hintStyle: const TextStyle(
          color: AppColor.lightGrey,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: const Icon(Icons.search, color: AppColor.red, size: 22),
        suffixIcon: _ClearButton(controller: controller, onClear: onClear),
        filled: true,
        fillColor: AppColor.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColor.lightGrey, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColor.lightGrey, width: 1.5),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColor.lightGrey, width: 1.5),
        ),
      ),
    );
  }
}

// Separate widget so the clear button can rebuild reactively
// without rebuilding the whole search bar
class _ClearButton extends StatefulWidget {
  const _ClearButton({required this.controller, this.onClear});

  final TextEditingController controller;
  final VoidCallback? onClear;

  @override
  State<_ClearButton> createState() => _ClearButtonState();
}

class _ClearButtonState extends State<_ClearButton> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_rebuild);
  }

  void _rebuild() => setState(() {});

  @override
  void dispose() {
    widget.controller.removeListener(_rebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller.text.isEmpty) return const SizedBox.shrink();
    return IconButton(
      icon: const Icon(Icons.close, color: AppColor.grey, size: 18),
      onPressed: () {
        widget.controller.clear();
        widget.onClear?.call();
      },
    );
  }
}
