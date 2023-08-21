import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyCustomIcon extends StatelessWidget {
  final IconData iconData;
  final Color iconColor;
  final Color containerColor;

  MyCustomIcon(
      {required this.iconData,
      required this.iconColor,
      required this.containerColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(37.0),
      height: ScreenUtil().setHeight(37.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: containerColor,
      ),
      child: Icon(
        iconData,
        color: iconColor,
      ),
    );
  }
}
