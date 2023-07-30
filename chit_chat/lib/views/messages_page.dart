import 'package:chit_chat/controllers/conversation_controller.dart';
import 'package:chit_chat/controllers/user_controller.dart';
import 'package:chit_chat/routes/route_helper.dart';
import 'package:chit_chat/utils/Dimensions.dart';
import 'package:chit_chat/utils/message_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/app_constants.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  Future<void> _loadRessources() async {
    await Get.find<ConversationController>().getAllConversations();
    await Get.find<ConversationController>().getParticipantsOfAllConversation();
    await Get.find<ConversationController>().getMssgsOfParticipants();
    Get.find<ConversationController>().sortMessages();
    await Get.find<ConversationController>().getOtherParticipants();
  }

  Future<bool> _mockFuture() async {
    // Simulate a time-consuming operation here (5 seconds in this case)
    await Future.delayed(Duration(seconds: 3));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final FocusNode focusNode = FocusNode();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff8640DF),
        title: const Text('Messages'),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              Get.defaultDialog(
                  buttonColor: Color(0xff8640DF),
                  titlePadding: EdgeInsets.only(
                      top: Dimensions.height20,
                      left: Dimensions.height20,
                      right: Dimensions.height20),
                  title: "Chat with friends",
                  contentPadding: EdgeInsets.all(Dimensions.height20),
                  middleText:
                      "Use the search bar to find users to chat with them ",
                  textConfirm: "OK",
                  confirmTextColor: Colors.white,
                  onConfirm: () {
                    Get.back();
                  });
            },
            child: Container(
                margin: EdgeInsets.only(right: Dimensions.height20),
                child: Icon(Icons.message_rounded)),
          )
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: RefreshIndicator(
              onRefresh: _loadRessources,
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
                        color: Color(0xffD9D9D9),
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 2),
                              color: Colors.grey.withOpacity(0.2))
                        ]),
                    child: TextField(
                      focusNode: focusNode,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.height10 * 1.5),
                              borderSide: const BorderSide(
                                width: 1.0,
                                color: Color(0xffD9D9D9),
                              )),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.height10 * 1.5),
                              borderSide: const BorderSide(
                                width: 1.0,
                                color: Color(0xffD9D9D9),
                              )),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                Dimensions.height10 * 1.5),
                          ),
                          hintText: "Search ...",
                          prefixIcon: Icon(Icons.search_rounded),
                          prefixIconColor: Colors.black,
                          contentPadding: EdgeInsets.only(
                              top: Dimensions.height10 / 2,
                              left: Dimensions.height10 / 2)),
                      onChanged: (value) async {
                        await Get.find<UserController>().searchUsers(value);
                      },
                      onTapOutside: (event) {
                        focusNode.unfocus();
                      },
                    ),
                  ),
                  GetBuilder<ConversationController>(
                    builder: (_conversationController) {
                      return !_conversationController.loading
                          ? Expanded(
                              child: ListView.builder(
                                  itemCount: 10,
                                  itemBuilder: (builder, index) {
                                    return Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: Dimensions.height20,
                                              vertical: Dimensions.height20),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: Dimensions.height10 * 5,
                                                width: Dimensions.height10 * 5,
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.grey[200],
                                                ),
                                              ),
                                              SizedBox(
                                                width: Dimensions.height10,
                                              ),
                                              Container(
                                                height: Dimensions.height10 * 5,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                        height: Dimensions
                                                                .height10 *
                                                            1.5,
                                                        width: Dimensions
                                                                .height20 *
                                                            3,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.grey[200],
                                                        )),
                                                    SizedBox(
                                                      height:
                                                          Dimensions.height10,
                                                    ),
                                                    Container(
                                                        height: Dimensions
                                                                .height10 *
                                                            1.5,
                                                        width: Dimensions
                                                                .height20 *
                                                            5,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.grey[200],
                                                        )),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: Dimensions.height20 * 4,
                                              ),
                                              Container(
                                                  height:
                                                      Dimensions.height10 * 1.5,
                                                  width:
                                                      Dimensions.height20 * 3,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                  ))
                                            ],
                                          ),
                                        ));
                                  }),
                            )
                          : Expanded(
                              child: ListView.builder(
                                  itemCount: _conversationController
                                      .conversations.length,
                                  itemBuilder: (buildContext, index) =>
                                      GestureDetector(
                                        onTap: () {
                                          _conversationController
                                              .currConversation = index;
                                          Get.toNamed(RouteHelper
                                              .getConversationPage());
                                        },
                                        child: Slidable(
                                          endActionPane: ActionPane(
                                              motion: const StretchMotion(),
                                              children: [
                                                SlidableAction(
                                                  onPressed: (context) {
                                                    Get.defaultDialog(
                                                        title:
                                                            "Delete conversation",
                                                        middleText:
                                                            'Do you really want to delete this conversation? ',
                                                        radius: 10.0,
                                                        actions: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              RichText(
                                                                  text: TextSpan(
                                                                      recognizer: TapGestureRecognizer()
                                                                        ..onTap = () {
                                                                          Get.back();
                                                                        },
                                                                      text: "Cancel",
                                                                      style: TextStyle(color: Colors.black))),
                                                              SizedBox(
                                                                width: Dimensions
                                                                    .height10,
                                                              ),
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  _conversationController.deleteConversation(
                                                                      _conversationController
                                                                          .conversations[
                                                                              index]
                                                                          .conversation_id!,
                                                                      index);

                                                                  Get.back();
                                                                },
                                                                child: Text(
                                                                    'Confirm'),
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      Color(
                                                                          0xffFF0000),
                                                                ), // Change the cancel button color
                                                              ),
                                                            ],
                                                          )
                                                        ]);
                                                  },
                                                  backgroundColor:
                                                      Color(0xffFF0000),
                                                  foregroundColor: Colors.white,
                                                  label: "Delete",
                                                  icon: Icons.delete_outlined,
                                                )
                                              ]),
                                          child: MessageWidget(
                                              image: _conversationController.otherPartcipant[index]!["img"] != null
                                                  ? AppConstants.BASE_URL +
                                                      "/" +
                                                      _conversationController.otherPartcipant[
                                                          index]!["img"]
                                                  : null,
                                              username: _conversationController.otherPartcipant[
                                                  index]!["username"],
                                              message: _conversationController.conversations[index].sortedMessages.isNotEmpty && _conversationController.conversations[index].sortedMessages != null
                                                  ? _conversationController
                                                      .conversations[index]
                                                      .sortedMessages
                                                      .last
                                                      .messageContent!
                                                  : "",
                                              date: _conversationController
                                                      .conversations[index]
                                                      .sortedMessages
                                                      .isNotEmpty
                                                  ? DateFormat('EEE, MMM d, y')
                                                      .format(DateTime.parse(_conversationController.conversations[index].sortedMessages.last.timestamp!))
                                                  : ""),
                                        ),
                                      )));
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: Dimensions.height10 * 6.1,
            bottom: Dimensions.height10 * 2,
            child: GetBuilder<UserController>(builder: (_userController) {
              return _userController.searchedUsersList.isNotEmpty
                  ? Container(
                      width: Dimensions.screenWidth,
                      color: Colors.white,
                      child: ListView.builder(
                          itemCount: _userController.searchedUsersList.length,
                          itemBuilder: (buildContext, index) {
                            return GestureDetector(
                              onTap: () {
                                _userController.setCurrSearchedUser = index;
                                Get.toNamed(RouteHelper.getInfoPage());
                              },
                              child: MessageWidget(
                                username: _userController
                                    .searchedUsersList[index]['username'],
                                message: "",
                                date: "",
                                image: _userController.searchedUsersList[index]
                                            ['img'] !=
                                        null
                                    ? AppConstants.BASE_URL +
                                        "/" +
                                        _userController.searchedUsersList[index]
                                            ['img']
                                    : null,
                              ),
                            );
                          }),
                    )
                  : GetBuilder<ConversationController>(
                      builder: (_convController) {
                      return !Get.find<ConversationController>()
                              .conversations
                              .isEmpty
                          ? Container()
                          : Container(
                              width: Dimensions.screenWidth,
                              child: const Center(
                                child: Text(
                                  "No messages",
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.grey),
                                ),
                              ),
                            );
                    });
            }),
          )
        ],
      ),
    );
  }
}
