import 'package:chit_chat/controllers/conversation_controller.dart';
import 'package:chit_chat/models/conversation_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

import '../controllers/user_controller.dart';
import '../routes/route_helper.dart';
import '../utils/Dimensions.dart';
import '../utils/account_widget.dart';
import '../utils/app_constants.dart';

class InfoPage extends GetView<UserController> {
  const InfoPage({super.key});

  Future<void> _loadData() async {
    await Get.find<ConversationController>().getParticipantsOfAllConversation();
    await Get.find<ConversationController>().getMssgsOfParticipants();
    await Get.find<ConversationController>().getOtherParticipants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Information'),
          centerTitle: true,
          backgroundColor: Color(0xff8640DF),
        ),
        body: ListView(children: [
          Container(
              padding: EdgeInsets.only(bottom: Dimensions.height20),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 2),
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 4),
              ], color: Colors.white),
              child: Column(children: [
                Container(
                    margin: EdgeInsets.only(top: Dimensions.height20),
                    height: Dimensions.height10 * 10,
                    width: Dimensions.height10 * 10,
                    child: (controller.searchedUsersList[
                                    controller.currSearchedUser]["img"] ==
                                null ||
                            controller.searchedUsersList[
                                    controller.currSearchedUser]["img"] ==
                                "")
                        ? CircleAvatar(
                            backgroundColor: Colors.blueGrey[200],
                            child: const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.white,
                            ),
                          )
                        : CircleAvatar(
                            backgroundImage: NetworkImage(
                                AppConstants.BASE_URL +
                                    "/" +
                                    controller.searchedUsersList[
                                        controller.currSearchedUser]["img"]),
                            backgroundColor: Colors.grey,
                          )),
                SizedBox(
                  height: Dimensions.height20,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                      controller.searchedUsersList[controller.currSearchedUser]
                          ["username"]),
                )
              ])),
          SizedBox(
            height: Dimensions.height10 / 2,
          ),
          GestureDetector(
            onTap: () async {
              List<ConversationModel> conversations =
                  Get.find<ConversationController>().conversations;

              bool done = false;
              int i = 0;
              while (i < conversations.length && !done) {
                for (var participant in conversations[i].partcipants) {
                  if (participant.user_id! ==
                      controller.searchedUsersList[controller.currSearchedUser]
                              ["user_id"]
                          .toString()) {
                    Get.find<ConversationController>().currConversation = i - 1;
                    done = true;
                  }
                  i++;
                }
              }
              if (!done) {
                print(done);
                String? convId = await Get.find<ConversationController>()
                    .newConversation(
                        controller.userModel.user_id,
                        controller
                            .searchedUsersList[controller.currSearchedUser]
                                ["user_id"]
                            .toString(),
                        controller
                                .searchedUsersList[controller.currSearchedUser]
                            ["username"]);
                await _loadData();
                Get.find<ConversationController>().currConversation =
                    Get.find<ConversationController>()
                        .findConversation(convId!)!;
                Get.offAndToNamed(RouteHelper.getConversationPage());
                done = true;
              }
            },
            child: AccountWidget(
                icon: Icons.message,
                text:
                    "Contact ${controller.searchedUsersList[controller.currSearchedUser]["username"]}"),
          ),
        ]));
  }
}
