import 'package:chit_chat/controllers/conversation_controller.dart';
import 'package:chit_chat/controllers/user_controller.dart';
import 'package:chit_chat/routes/route_helper.dart';
import 'package:chit_chat/utils/Dimensions.dart';
import 'package:chit_chat/utils/message_widget.dart';
import 'package:chit_chat/views/conversation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
    await Get.find<ConversationController>().getOtherParticipants();
  }

  Future<bool> _mockFuture() async {
    // Simulate a time-consuming operation here (5 seconds in this case)
    await Future.delayed(Duration(seconds: 3));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff8640DF),
        title: const Text('Messages'),
        centerTitle: true,
        actions: [
          Container(
              margin: EdgeInsets.only(right: Dimensions.height20),
              child: Icon(Icons.add_comment_rounded))
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
                        print(Get.find<UserController>().searchedUsersList);
                      },
                    ),
                  ),
                  GetBuilder<ConversationController>(
                    builder: (_conversationController) {
                      return !_conversationController.loading
                          ? FutureBuilder(
                              future: _mockFuture(),
                              builder: ((context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  // While waiting for the Future to complete, show the CircularProgressIndicator
                                  return CircularProgressIndicator();
                                } else {
                                  //_loadRessources();
                                  // After the Future completes, show something else
                                  return Expanded(
                                      child: SingleChildScrollView(
                                          physics:
                                              AlwaysScrollableScrollPhysics(),
                                          child: Column(
                                            children: [
                                              Center(
                                                  child: Text("No messages")),
                                            ],
                                          )));
                                  // You can return any widget you want here.
                                }
                              }))
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
                                        child: MessageWidget(
                                            image: _conversationController.otherPartcipant[index]!["img"] != null
                                                ? AppConstants.BASE_URL +
                                                    "/" +
                                                    _conversationController.otherPartcipant[
                                                        index]!["img"]
                                                : null,
                                            username:
                                                _conversationController.otherPartcipant[
                                                    index]!["username"],
                                            message: _conversationController.sortedMessages[index].isNotEmpty && _conversationController.sortedMessages[index] != null
                                                ? _conversationController
                                                    .sortedMessages[index]
                                                    .last
                                                    .messageContent!
                                                : "",
                                            date: _conversationController
                                                    .sortedMessages[index]
                                                    .isNotEmpty
                                                ? DateFormat('EEE, MMM d, y')
                                                    .format(DateTime.parse(_conversationController.sortedMessages[index].last.timestamp!))
                                                : ""),
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
                              child: Container(
                                height: Dimensions.height10 * 5,
                                padding: EdgeInsets.only(
                                    top: Dimensions.height10,
                                    left: Dimensions.height20),
                                child: Text(
                                  _userController.searchedUsersList[index]
                                      ['username'],
                                  style: TextStyle(
                                      fontSize: Dimensions.height10 * 1.7),
                                ),
                              ),
                            );
                          }),
                    )
                  : Container();
            }),
          )
        ],
      ),
    );
  }
}
