import 'package:chit_chat/views/InfoPage.dart';
import 'package:chit_chat/views/conversation.dart';
import 'package:chit_chat/views/edit_page.dart';
import 'package:chit_chat/views/home_page.dart';
import 'package:chit_chat/views/sign_in_page.dart';
import 'package:chit_chat/views/sign_up_page.dart';
import 'package:get/get.dart';

class RouteHelper {
  static const String signInPage = "/sign_in_page";
  static const String signUpPage = "/sign_up_page";
  static const String homePage = "/home_page";
  static const String conversationPage = "/conversation_page";
  static const String editPage = "/edit_page";
  static const String infoPage = "/infoPage";

  static String getSignInPage() => "$signInPage";
  static String getSignUpPage() => "$signUpPage";
  static String getHomePage() => "$homePage";
  static String getConversationPage() => "$conversationPage";
  static String getEditPage() => "$editPage";
  static String getInfoPage() => "$infoPage";

  static List<GetPage> getPages = [
    GetPage(name: signInPage, page: () => SignInPage()),
    GetPage(name: signUpPage, page: () => SignUpPage()),
    GetPage(name: homePage, page: () => HomePage()),
    GetPage(
        name: conversationPage,
        page: () => ConversationPage(),
        transition: Transition.rightToLeft),
    GetPage(
      name: editPage,
      page: () {
        final String pageArgument = Get.parameters['page']!;
        return EditPage(page: pageArgument);
      },
      transition: Transition.rightToLeft,
    ),
    GetPage(name: infoPage, page: () => InfoPage())
  ];
}
