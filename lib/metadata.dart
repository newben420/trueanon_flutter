// import 'dart:convert';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:loader_overlay/loader_overlay.dart';
// import 'package:http/http.dart' as http;
// import 'custom_plugins.dart';
// import 'package:rflutter_alert/rflutter_alert.dart';

class Mt {
  //general

  static String app = "TrueAnon";
  static String rights = "All rights reserved.";
  static String about_head = 'About';
  static String create_link = "Create a Link";
  static String create_link_btn = "Without a Link Yet? Create One";
  static String login = "Created Already? Manage Messages";
  static String api_url = "192.168.1.20:3000";
  static String socket_protocol = "http://";
  static String loginBtn = "Login";
  static String unloaded = "Data could not be loaded.";
  static String learn_more = "Learn More";
  static String please_wait = "Please wait for";
  static String auto_login = "Automatically Login and save device?";
  static String app_intro = "Anonymous Messages with TrueAnon";
  static String slogan =
      "Receive anonymous messages simply by creating and sharing your link";
  static String loader_txt = "Starting App...";
  static String version = "1.0.0";
  static String url = "https://trueanon.online";
  static String hello = "Hello";
  static String share = "Share Link";
  static String refresh = "Manually Update Messages";
  static String succ = "SUCCESS";
  static String unparse = "Error: Could not process data";
  static String login_fail = "Login failed... Please try again";
  static String login_fail_man = "Login failed... Please try manually";
  static String invalid_session = "Session expired. please login again";
  static String dev_unsave_err =
      "Device could not be configured to your account. Please try again";
  static String err = "ERROR";
  static String save_device = 'Save device?';
  static String link_succ =
      "Congratulations! \n Your link has been successfully generated. Click the button below to copy/share your link.\n\nYour audience can send you anonymous messages by visiting your link. Also, they are not required to install this app.";
  static String generic_err =
      "An unexpected error was encountered. Please check your connection and try again";
  static String link_btn = "Share Link";
  static String no_network =
      "Please connect to the internet to update messages";
  static String conn_err =
      "Error connecting to server. Please check your internet connectivity.";
  static String share_txt = "Send me an anonymous message on " + Mt.app;

  //forms
  static String val_err =
      "Please make sure all input fields are validated successfully";
  static String gen_err = "An error was encountered... Please try again";
  static String ht_uid = "User ID";
  static String ht_nam = "Name on Link";
  static String ht_pas = "Password";
  static String ins = 'Instruction';

  //validators
  static String passPattern =
      r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$";
  static String passIns =
      "Must contain at least one uppercase, lowercase, number, symbol, and at least 8 characters.";
  static String passInsLog = "Please enter a valid password.";
  static String namePattern =
      r"^((\s+)?((?=.*[a-zA-Z])[a-zA-Z\d_\-']{1,})(\s+)?((?=.*[a-zA-Z])[a-zA-Z\d_\-']{1,})?(\s+)?((?=.*[a-zA-Z])[a-zA-Z\d_\-']{1,})?(\s+)?){1,50}$";
  static String nameIns =
      "Name requires at least one alphabet in each, no special characters other than _,', and -, and a maximum of three separate names or 50 characters.";
  static String uidPattern = r"^\d{6}$";
  static String uidIns = "Please enter a valid User ID.";

  //menu
  static String menu_1 = "Create New Link";
  static String menu_2_1 = "Change Name";
  static String menu_2_2 = "Change Password";
  static String menu_2_3 = "Logout";
  static String menu_3_1 = "Save Device";
  static String menu_3_2 = "Remove Other Devices";
  static String menu_4 = "Delete Link";

  //huge
  static String about =
      """TrueAnon is an application which provides a service that allows its users to create links (profiles) which they can share to their family, friends, fans, followers, groups, e. t. c. to receive completely anonymous messages from them. Such links are completely free and permanent in which anonymous messages remain accessible forever.
      \n\nThis application can be of great importance in getting to know how people actually feel about you by allowing them express themselves to you without fear of being known. For example, when your crush creates a link and shares it, you can use it to anonymously tell him/her/them how you feel about him/her/them.
    \n\nThis application can also be used/utilised in gathering the anonymous and actual opinions of individual persons in a group, conduct surveys and polls, get anonymous confessions, gather anonymous votes, and all other ways within and beyond the boundaries of creativity.
    \n\nPlease note that TrueAnon does not in any form track the senders of anonymous messages and is not responsible for those anonymous messages or any effect(s) that may be caused by them. TrueAnon only provies a platform to exchange anonymous messages with the aim of allowing people fully express themselves, hence, it is advisable to use this platform responsibly and to avoid using it as a tool to cause harm to other people.
    \n\nFor queries, suggestions, reports, e.t.c., please feel free to email us at admin@trueanon.online and we will get back to you as soon as we can. Thank you for using this website !
    \n\nNote that by using this app, you agree to our Terms and Conditions (${url}/terms-and-conditions) and Privacy Policy (${url}/privacy-policy).
    \n\nPlease have fun !!
    """;
  static String create = """STEPS
    \n1. Fill in your details which include the name you want displayed on your profile, and also a strong password which you will use to log in and read the anonymous messages you receive.
    \n2. CLick on 'Create Link' to proceed.
    \n3. Share your link to an audience from the pop-up by copying it or clicking the social media icons to receive anonymous messages from them, and also note down your login details.
    \n4. Click on "Manage Messages" from the main page to have access to anonymous messages sent to you.
    \n\n\nPlease Note That:
    \n1. You can only change your password when you are logged in, for security purposes. Also, you agree to our Terms and Conditions and Privacy Policy by submitting your details.
    Create Link Now
    \n2. Link (Profile) stays active forever for you to receive anonymous messages and read them until you delete it. You also get real-time notifications for new anonymous messages.
    \n3. Maximum of 1k messages per link.""";
}
