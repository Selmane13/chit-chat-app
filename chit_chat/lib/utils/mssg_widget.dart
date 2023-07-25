import 'package:chit_chat/utils/Dimensions.dart';
import 'package:flutter/material.dart';

class MssgWidget extends StatelessWidget {
  final String message;
  final Color color;
  final Color txtColor;
  final String? image;
  final maxChars = 30;
  bool isMe;
  MssgWidget(
      {super.key,
      required this.message,
      required this.color,
      this.image,
      this.isMe = false,
      required this.txtColor});

  String formatStringWithLineLength(String text, int lineLength) {
    List<String> words = text.split(' ');
    StringBuffer buffer = StringBuffer();
    String currentLine = '';

    for (String word in words) {
      if (currentLine.isEmpty) {
        // If the current line is empty, add the word to it
        currentLine = word;
      } else if (currentLine.length + word.length + 1 <= lineLength) {
        // If adding the word to the current line doesn't exceed the line length, add it with a space
        currentLine += ' $word';
      } else {
        // If adding the word to the current line exceeds the line length, start a new line
        buffer.writeln(currentLine);
        currentLine = word;
      }
    }

    // Add the last line to the buffer
    buffer.writeln(currentLine);

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          isMe
              ? Container()
              : Container(
                  child: image == null || image == ""
                      ? Container(
                          height: 50,
                          width: 50,
                          child: CircleAvatar(
                            backgroundColor: Colors.blueGrey[200],
                            child: const Icon(
                              Icons.person,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Container(
                          height: 50,
                          width: 50,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(image!),
                          ))),
          SizedBox(
            width: Dimensions.height10,
          ),
          Container(
            padding: EdgeInsets.only(
              left: Dimensions.height20,
              right: Dimensions.height20,
              top: Dimensions.height10,
              //bottom: Dimensions.height10
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30), color: color),
            child: Center(
                child: Text(
              formatStringWithLineLength(message, maxChars),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: txtColor),
            )),
          )
        ],
      ),
    );
  }
}
