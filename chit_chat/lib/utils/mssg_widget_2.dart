import 'package:chit_chat/utils/Dimensions.dart';
import 'package:flutter/material.dart';

class MssgWidget2 extends StatelessWidget {
  final String message;
  final Color color;
  final Color? textColor;
  MssgWidget2(
      {super.key, required this.message, required this.color, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          SizedBox(
            width: Dimensions.height10,
          ),
          Container(
            padding: EdgeInsets.only(
                left: Dimensions.height20,
                right: Dimensions.height20,
                top: Dimensions.height10,
                bottom: Dimensions.height10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30), color: color),
            child: Center(
                child: Text(
              message,
              style: TextStyle(color: textColor ?? Colors.black),
            )),
          )
        ],
      ),
    );
  }
}
