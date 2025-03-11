import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:madistock/constants/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ccaColor,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          scaffoldKey.currentState?.openDrawer();
        },
        child: Padding(
          padding: EdgeInsets.all(1.w),
          child: CircleAvatar(
            backgroundColor: whiteColor,
            radius: 1.h,
            child: ClipOval(
              child: Image.asset(
                'assets/logo.png',
                width: 8.w,
                height: 8.w,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
          color: whiteColor,
          fontSize: 18.dp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(7.h);
}
