import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:apploan/core/core.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    Key? key,
    required this.items,
    required this.onTap,
    this.initialActiveIndex = 0,
    this.navKey,
  }) : super(key: key);

  final List<TabItem> items;
  final Function(int) onTap;
  final int initialActiveIndex;
  final ValueKey<String>? navKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15),
        ],
      ),
      child: StyleProvider(
        style: _AppNavStyle(),
        child: ConvexAppBar(
          key: navKey,
          backgroundColor: AppColor.white,
          color: AppColor.grey,
          activeColor: AppColor.primary,
          height: 66,
          style: TabStyle.reactCircle,
          initialActiveIndex: initialActiveIndex,
          onTap: onTap,
          shadowColor: const Color(0xFF9DB2CE),
          items: items,
        ),
      ),
    );
  }
}

class _AppNavStyle extends StyleHook {
  @override
  double? get iconSize => 22;

  @override
  double get activeIconMargin => 8;

  @override
  double get activeIconSize => 24;

  @override
  TextStyle textStyle(Color color, String? fontFamily) {
    return TextStyle(
      color: color,
      fontFamily: fontFamily,
      fontSize: 10,
      fontWeight: FontWeight.w700,
      height: 1.0,
    );
  }
}
