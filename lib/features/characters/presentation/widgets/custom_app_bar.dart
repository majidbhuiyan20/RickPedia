import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/routes/route_manager.dart';

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
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.red, size: 26.sp),
            onPressed: () {
              Navigator.pushNamed(context, Routes.favoritesRoute);
            },
          ),
        ],
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.0);
}
