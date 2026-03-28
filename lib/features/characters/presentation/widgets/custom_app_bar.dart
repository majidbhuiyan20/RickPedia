import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  const CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      title: Row(
        children: [
          Text(AppStrings.characters, style: TextStyle(color: Colors.white, fontSize: 29.sp, fontWeight: FontWeight.w700)),
          Spacer(),
          Icon(Icons.error_outline, color: Color(0XFFBBB9C3),size: 30.sp,)
        ],
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.0);
}
