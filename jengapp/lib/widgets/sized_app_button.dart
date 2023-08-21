import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jengapp/utils/constants.dart';

enum SizedButtonType { PRIMARY, PLAIN, SECONDARY }

class SizedAppButton extends StatelessWidget {
  final SizedButtonType type;
  final VoidCallback onPressed;
  final String text;

  SizedAppButton({required this.type, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onPressed,
      child: Container(
        alignment: Alignment.center,
       width: 150,
        height: ScreenUtil().setHeight(48.0),
        decoration: BoxDecoration(
          color: getButtonColor(type),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(169, 176, 185, 0.42),
              spreadRadius: 0,
              blurRadius: 8.0,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Center(
          child: Text(
            this.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: getTextColor(type),
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

Color getButtonColor(SizedButtonType type) {
  switch (type) {
    case SizedButtonType.PRIMARY:
      return Constants.primaryColor;
    case SizedButtonType.PLAIN:
      return Colors.white;
    case SizedButtonType.SECONDARY:
      return Constants.secondaryColor;
    default:
      return Constants.primaryColor;
  }
}

Color getTextColor(SizedButtonType type) {
  switch (type) {
    case SizedButtonType.PLAIN:
      return Constants.primaryColor;
    case SizedButtonType.PRIMARY:
      return Colors.white;
    default:
      return Colors.white;
  }
}
