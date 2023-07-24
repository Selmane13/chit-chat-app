import 'package:chit_chat/utils/Dimensions.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  final String? image;
  final String username;
  final String message;
  final String date;
  const MessageWidget(
      {super.key,
      this.image,
      required this.username,
      required this.message,
      required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      padding: EdgeInsets.only(
          left: Dimensions.height10, right: Dimensions.height10),
      height: Dimensions.height10 * 10,
      width: double.maxFinite,
      child: Row(
        children: [
          Container(
              child: image == null
                  ? Container(
                      height: Dimensions.height10 * 5,
                      width: Dimensions.height10 * 5,
                      child: CircleAvatar(
                        backgroundColor: Colors.blueGrey[200],
                        child: Icon(
                          Icons.person,
                          size: Dimensions.height10 * 2.5,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Container(
                      height: Dimensions.height10 * 5,
                      width: Dimensions.height10 * 5,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(image!),
                      ))),
          SizedBox(
            width: Dimensions.height10 * 2,
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  username,
                  style: TextStyle(
                      fontSize: Dimensions.height10 * 1.7,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: Dimensions.height10 / 2,
                ),
                Container(
                  width: Dimensions.height10 * 10,
                  child: Text(
                    message,
                    style: TextStyle(
                        fontSize: Dimensions.height10 * 1.4,
                        color: Colors.grey[700]),
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: Dimensions.height10 * 5.5,
          ),
          Text(date)
        ],
      ),
    );
  }
}
