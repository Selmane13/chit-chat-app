import 'package:flutter/material.dart';

import 'Dimensions.dart';

class AccountWidget extends StatelessWidget {
  IconData icon;
  String text;
  Color? color;
  Color? textColor;

  AccountWidget(
      {super.key,
      required this.icon,
      required this.text,
      this.color,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: Dimensions.height20,
          top: Dimensions.height10,
          bottom: Dimensions.height10),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: Dimensions.height10 * 5,
                width: Dimensions.height10 * 5,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(Dimensions.height10 * 4),
                    color: color ?? const Color(0xffCAA0FF)),
                child: Icon(
                  icon,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: Dimensions.height20,
              ),
              Text(
                text,
                style: TextStyle(
                    color: textColor ?? Colors.black,
                    fontSize: Dimensions.height10 * 1.7),
              ),
            ],
          ),
          SizedBox(
            width: Dimensions.height20,
          ),
          Container(
              margin: EdgeInsets.only(right: Dimensions.height10),
              child: const Icon(Icons.arrow_forward_ios_rounded))
        ],
      ),
    );
  }
}
