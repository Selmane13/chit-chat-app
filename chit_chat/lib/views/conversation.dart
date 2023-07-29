import 'dart:async';

import 'package:chit_chat/controllers/conversation_controller.dart';
import 'package:chit_chat/controllers/user_controller.dart';
import 'package:chit_chat/routes/route_helper.dart';
import 'package:chit_chat/utils/Dimensions.dart';
import 'package:chit_chat/utils/app_constants.dart';
import 'package:chit_chat/utils/mssg_widget.dart';
import 'package:chit_chat/views/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import '../utils/mssg_widget_2.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  late ConversationController _conversationController;
  TextEditingController _mssgController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  final int maxChars = 10;

  void _startAnimation() {
    if (animationController.status != AnimationStatus.forward) {
      animationController.reset();
      animationController.forward();
    }
  }

  void _revertAnimation() {
    if (animationController.status != AnimationStatus.forward) {
      animationController.reverse();
    }
  }

  void _scrollDown() {
    Timer(Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _conversationController = Get.find<ConversationController>();
    animationController = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 100,
        ));
    animation = Tween(begin: 0.0, end: 0.25).animate(animationController);
    _mssgController.addListener(_checkForLineWrap);
    _scrollDown();
  }

  @override
  void dispose() {
    // Dispose of controllers and animation when the state is being disposed of.
    _scrollController.dispose();
    _mssgController.dispose();
    animationController.dispose();

    super.dispose();
  }

  void _checkForLineWrap() {
    if (_mssgController.text.length % maxChars == 0) {
      // If the current text length is a multiple of maxChars, move focus to the next line
      _moveToNextLine();
    }
  }

  void _moveToNextLine() {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.nextFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () async {
              _revertAnimation();
              await Get.find<ConversationController>().getMssgsOfParticipants();
              Get.find<ConversationController>().sortMessages();
              await Get.find<ConversationController>().getOtherParticipants();
              Get.back();
            },
            child: Icon(Icons.arrow_back_ios_new_outlined)),
        title: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              child: (_conversationController.otherPartcipant[
                              _conversationController
                                  .currConversation]!["img"] ==
                          null ||
                      _conversationController.otherPartcipant[
                              _conversationController
                                  .currConversation]!["img"] ==
                          "")
                  ? CircleAvatar(
                      backgroundColor: Colors.blueGrey[200],
                      child: Icon(
                        Icons.person,
                        size: Dimensions.height10 * 2.5,
                        color: Colors.white,
                      ),
                    )
                  : CircleAvatar(
                      backgroundImage: NetworkImage(AppConstants.BASE_URL +
                          "/" +
                          _conversationController.otherPartcipant[
                              _conversationController
                                  .currConversation]!["img"]),
                    ),
            ),
            SizedBox(
              width: Dimensions.height10,
            ),
            Text(_conversationController.otherPartcipant[
                _conversationController.currConversation]!['username'])
          ],
        ),
        backgroundColor: Color(0xff8640DF),
        actions: [
          GestureDetector(
            onTap: (){
              Get.defaultDialog(
                  buttonColor:Color(0xff8640DF) ,
                  titlePadding: EdgeInsets.only(
                      top: Dimensions.height20,
                      left: Dimensions.height20,
                      right: Dimensions.height20),
                  title: "Audio call",
                  contentPadding: EdgeInsets.all(
                      Dimensions.height20),
                  middleText:
                  "Audio call is comming soon...",
                  textConfirm: "OK",
                  confirmTextColor: Colors.white,
                  onConfirm: (){
                    Get.back();
                  }
              );
            },
            child: Container(
                margin: EdgeInsets.only(right: Dimensions.height20),
                child: Icon(Icons.phone)),
          ),
          GestureDetector(
            onTap: (){
              Get.find<UserController>().searchedUsersList.clear();
              Get.find<UserController>().setCurrSearchedUser = 0;
              Get.find<UserController>().searchedUsersList.add({
                "user_id":_conversationController.otherPartcipant[_conversationController.currConversation]!["user_id"],
                "username":_conversationController.otherPartcipant[_conversationController.currConversation]!["username"],
                "img":_conversationController.otherPartcipant[_conversationController.currConversation]!["img"]
              });
              Get.toNamed(RouteHelper.getInfoPage());
            },
            child: Container(
                margin: EdgeInsets.only(right: Dimensions.height20),
                child: Icon(Icons.info_outline_rounded)),
          )
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            //top: Dimensions.screenHeight * 0.78,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.transparent,
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: Dimensions.height10,
                          bottom: Dimensions.height10,
                          left: Dimensions.height20,
                          right: Dimensions.height20),
                      padding: EdgeInsets.only(
                          left: Dimensions.height10,
                          right: Dimensions.height10,
                          top: Dimensions.height10,
                          bottom: Dimensions.height10),
                      height: Dimensions.height10 * 5,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.black12),
                          borderRadius:
                              BorderRadius.circular(Dimensions.height10 * 3),
                          color: Color.fromARGB(255, 245, 245, 245),
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 2),
                                color: Colors.grey.withOpacity(0.2))
                          ]),
                      child: TextField(
                        controller: _mssgController,
                        maxLines: null,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.height10 * 1.5),
                                borderSide: const BorderSide(
                                  width: 1.0,
                                  color: Color.fromARGB(255, 245, 245, 245),
                                )),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.height10 * 1.5),
                                borderSide: const BorderSide(
                                  width: 1.0,
                                  color: Color.fromARGB(255, 245, 245, 245),
                                )),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.height10 * 1.5),
                            ),
                            hintText: "Message...",
                            suffixIcon: RotationTransition(
                                turns: animation,
                                child: GestureDetector(
                                  onTap: () {
                                    if (!_mssgController.value.text.isEmpty) {
                                      _conversationController.sendMessage({
                                        "conversation_id":
                                            _conversationController
                                                .conversations[
                                                    _conversationController
                                                        .currConversation]
                                                .conversation_id,
                                        "sender_id": Get.find<UserController>()
                                            .userModel
                                            .user_id,
                                        "message_content":
                                            _mssgController.value.text,
                                        "receiver_id": _conversationController
                                                .otherPartcipant[
                                            _conversationController
                                                .currConversation]!["user_id"]
                                      });
                                      _mssgController.clear();
                                    }
                                  },
                                  child: SvgPicture.asset(
                                      "assets/images/send_up.svg"),
                                )),
                            contentPadding: EdgeInsets.only(
                                top: Dimensions.height10 / 2,
                                left: Dimensions.height10 / 2)),
                        onTap: () {
                          _startAnimation();
                        },
                        onTapOutside: (event) {
                          _revertAnimation();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              top: Dimensions.height20,
              left: 0,
              right: 0,
              bottom: Dimensions.screenHeight * 0.1,
              child: GetBuilder<ConversationController>(
                builder: (_conversationController) {
                  _scrollDown();
                  return ListView.builder(
                      controller: _scrollController,
                      itemCount: _conversationController
                          .conversations[
                              _conversationController.currConversation]
                          .sortedMessages
                          .length,
                      itemBuilder: (itemBuilder, index) {
                        return Row(
                          mainAxisAlignment: _conversationController
                                      .conversations[_conversationController
                                          .currConversation]
                                      .sortedMessages[index]
                                      .senderId! ==
                                  Get.find<UserController>().userModel.user_id
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onLongPress: () {
                                if(_conversationController
                                    .conversations[_conversationController
                                    .currConversation]
                                    .sortedMessages[index]
                                    .senderId! ==
                                    Get.find<UserController>()
                                        .userModel
                                        .user_id){
                                Get.defaultDialog(
                                    title: "Delete message",
                                    middleText:
                                        'Do you really want to delete this message? ',
                                    radius: 10.0,
                                    actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              _conversationController.deleteMessage(
                                                  _conversationController
                                                      .conversations[
                                                          _conversationController
                                                              .currConversation]
                                                      .sortedMessages[index]
                                                      .messageId!,
                                                  index);

                                              Get.back();
                                            },
                                            child: Text('Confirm'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xffFF0000),
                                            ), // Change the cancel button color
                                          ),
                                        ],
                                      )
                                    ]);}
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: Dimensions.height10,
                                    right: Dimensions.height10,
                                    top: Dimensions.height10 / 2,
                                    bottom: Dimensions.height10 / 2),
                                child: MssgWidget(
                                  isMe: _conversationController
                                          .conversations[_conversationController
                                              .currConversation]
                                          .sortedMessages[index]
                                          .senderId! ==
                                      Get.find<UserController>()
                                          .userModel
                                          .user_id,
                                  message: _conversationController
                                      .conversations[_conversationController
                                          .currConversation]
                                      .sortedMessages[index]
                                      .messageContent!,
                                  color: _conversationController
                                              .conversations[
                                                  _conversationController
                                                      .currConversation]
                                              .sortedMessages[index]
                                              .senderId! ==
                                          Get.find<UserController>()
                                              .userModel
                                              .user_id
                                      ? Colors.grey.withOpacity(0.2)
                                      : Color(0xff8640DF),
                                  txtColor: _conversationController
                                              .conversations[
                                                  _conversationController
                                                      .currConversation]
                                              .sortedMessages[index]
                                              .senderId! ==
                                          Get.find<UserController>()
                                              .userModel
                                              .user_id
                                      ? Colors.black
                                      : Colors.white,
                                  image: _conversationController
                                                  .otherPartcipant[
                                              _conversationController
                                                  .currConversation]!["img"] !=
                                          null
                                      ? AppConstants.BASE_URL +
                                          "/" +
                                          _conversationController
                                                  .otherPartcipant[
                                              _conversationController
                                                  .currConversation]!["img"]
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                },
              )),
        ],
      ),
    );
  }
}
