import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jengapp/utils/constants.dart';

class InputWidget extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final double height;
  final String topLabel;
  final bool obscureText;
  final bool enableText;
  final int maxLines;
  final bool multiline;
  final TextEditingController textEditingController;

  InputWidget({
    required this.hintText,
    required this.prefixIcon,
    this.height = 45.0,
    this.topLabel = "",
    this.obscureText = false,
    required this.textEditingController,
    this.enableText = true,
    this.maxLines = 1,
    this.multiline = false
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          this.topLabel,
          style: TextStyle(fontSize: 15),
        ),
        SizedBox(height: 5.0),
        Container(
          height: ScreenUtil().setHeight(height),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TextFormField(
            enabled: enableText,
            controller: textEditingController,
            obscureText: this.obscureText,
            maxLines: maxLines,
            keyboardType: multiline ? TextInputType.multiline : null,
            decoration: InputDecoration(
              prefixIcon: Icon(
                this.prefixIcon,
                color: Color.fromRGBO(105, 108, 121, 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(74, 77, 84, 0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Constants.primaryColor,
                ),
              ),
              hintText: this.hintText,
              hintStyle: TextStyle(
                fontSize: 14.0,
                color: Color.fromRGBO(105, 108, 121, 0.7),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class InputWidget2 extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final double height;
  final String topLabel;
  final bool obscureText;
  final bool enableText;

  final bool multiline;
  final TextEditingController textEditingController;

  InputWidget2({
    required this.hintText,
    required this.prefixIcon,
    this.height = 45.0,
    this.topLabel = "",
    this.obscureText = false,
    required this.textEditingController,
    this.enableText = true,
    this.multiline = false
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          this.topLabel,
          style: TextStyle(fontSize: 15),
        ),
        SizedBox(height: 5.0),
        Container(
          //height: ScreenUtil().setHeight(height),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TextFormField(
            enabled: enableText,
            controller: textEditingController,
            obscureText: false,
            minLines: 1,
            // <-- SEE HERE
            maxLines: 3,
            //expands: true,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              prefixIcon: Icon(
                this.prefixIcon,
                color: Color.fromRGBO(105, 108, 121, 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(74, 77, 84, 0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Constants.primaryColor,
                ),
              ),
              hintText: this.hintText,
              hintStyle: TextStyle(
                fontSize: 14.0,
                color: Color.fromRGBO(105, 108, 121, 0.7),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class SizedInputWidget extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final double height;
  final double width;
  final String topLabel;
  final bool obscureText;
  final bool enableText;
  final TextEditingController textEditingController;

  SizedInputWidget({
    required this.hintText,
    required this.prefixIcon,
    this.height = 40.0,
    this.width = 100.0,
    this.topLabel = "",
    this.obscureText = false,
    required this.textEditingController,
    this.enableText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(
          height: ScreenUtil().setHeight(height),
          width: ScreenUtil().setWidth(width),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TextFormField(
            enabled: enableText,
            controller: textEditingController,
            obscureText: false,
            //expands: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              // prefixIcon: Icon(
              //   this.prefixIcon,
              //   color: Color.fromRGBO(105, 108, 121, 1),
              // ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(74, 77, 84, 0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Constants.primaryColor,
                ),
              ),
              hintText: this.hintText,
              hintStyle: TextStyle(
                fontSize: 14.0,
                color: Color.fromRGBO(105, 108, 121, 0.7),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class SizedInputWidget2 extends StatelessWidget {
  final IconData prefixIcon;
  final double height;
  final double width;
  final String topLabel;
  final bool obscureText;
  final bool enableText;
  final String newVal;
  final TextEditingController textEditingController;
  final VoidCallback action;


  SizedInputWidget2({
    required this.prefixIcon,
    this.height = 40.0,
    this.width = 100.0,
    this.topLabel = "",
    this.obscureText = false,
    required this.textEditingController,
    this.enableText = true,
    required this.newVal,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(
          height: ScreenUtil().setHeight(height),
          width: ScreenUtil().setWidth(width),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TextFormField(
            enabled: enableText,
            controller: textEditingController,
            obscureText: false,
            onChanged: (newVal) {
              action();

            },
            //onEditingComplete: action,
            //expands: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              // prefixIcon: Icon(
              //   this.prefixIcon,
              //   color: Color.fromRGBO(105, 108, 121, 1),
              // ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(74, 77, 84, 0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Constants.primaryColor,
                ),
              ),

              hintStyle: TextStyle(
                fontSize: 14.0,
                color: Color.fromRGBO(105, 108, 121, 0.7),
              ),
            ),
          ),
        )
      ],
    );
  }
}
