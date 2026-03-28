import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/character.dart';
import '../../../../core/routes/route_manager.dart';

class CharacterCard extends StatelessWidget {
  final Character character;

  const CharacterCard({
    super.key,
    required this.character,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.characterDetailRoute,
          arguments: character,
        );
      },
      child: Card(
        color: Colors.grey[900],
        child: SizedBox(
          height: 185.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(4.r)),
                child: Image.network(
                  character.image,
                  width: double.infinity,
                  height: 110.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 110.h,
                      color: Colors.grey[700],
                      child: const Icon(Icons.image_not_supported,
                          color: Colors.white),
                    );
                  },
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        character.name,
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.sp,
                        ),
                      ),
                      SizedBox(height: 8.h,),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: character.status == 'Alive'
                              ? Colors.green.withOpacity(0.6)
                              : Colors.red.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                        child: Text(
                          character.status,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 7.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
