//import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:loader_overlay/loader_overlay.dart';
//import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/services.dart';
//import 'package:interactive_bezier/interactive_bezier.dart';
import 'metadata.dart';
import 'login.dart';
import 'actlogin.dart';
import 'colors.dart';
import 'custom_plugins.dart';
import 'dashboard.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // FlutterError.onError = (FlutterErrorDetails details) {
  //   print("EXCEPTION CAUGHT FROM INSIDE");
  //   print("error: ${details.exception}");
  //   print("stack trace: ${details.stack}");
  // };
  //runZonedGuarded(() {
  runApp(const MyApp());
  // }, (error, stack) {
  //   print("EXCEPTION CAUGHT FROM OUTSIDE");
  //   print("error: $error");
  //   print("stack trace: $stack");
  // });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return MaterialApp(
      home: EasySplashScreen(
        logo: Image.asset(
          'images/trueanon_new_icon.png',
        ),
        title: null,
        // loadingText: Text(
        //   loader_txt,
        //   style: customX.loaderTextStyle,
        // ),
        backgroundColor: Co.d1,
        loaderColor: Colors.white,
        showLoader: true,
        futureNavigator: customX.AppLoader(context),
      ),
      debugShowCheckedModeBanner: false,
      color: Co.bg,
      theme: ThemeData(),
      routes: {
        customX.route_home: (ctx) => LoginPage(),
        customX.route_create: (ctx) => Login(),
        customX.route_manage: (ctx) => ActLogin(),
        customX.route_dashboard: (ctx) => Dashboard(),
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int currentIndex = 0;
  IconData qm = Icons.lightbulb_rounded;
  double botHeight = 100.0;
  double aboutHeight = 0;
  double headHeight = 60;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => customX.onWillPop(context),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Color(0xff181818),
          child: Stack(
            children: [
              Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 1000,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - botHeight,
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              Container(
                                height: ((MediaQuery.of(context).size.height -
                                        botHeight) *
                                    0.6),
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(40),
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'images/ta_text_icons.png'),
                                      fit: BoxFit.contain,
                                      alignment: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight:
                                      ((MediaQuery.of(context).size.height -
                                              botHeight) *
                                          0.4),
                                  minWidth: MediaQuery.of(context).size.width,
                                  maxWidth: MediaQuery.of(context).size.width,
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        Mt.app,
                                        overflow: TextOverflow.clip,
                                        maxLines: 1,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'SCP',
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 30.0,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        Mt.slogan,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        maxLines: 3,
                                        style: TextStyle(
                                          fontFamily: 'SCP',
                                          color: Colors.white,
                                          height: 1.7,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            aboutHeight = MediaQuery.of(context)
                                                .size
                                                .height;
                                          });
                                        },
                                        child: Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Co.d8,
                                          size: 27,
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          padding: EdgeInsets.all(8),
                                          backgroundColor: Colors.transparent,
                                          shape: CircleBorder(
                                            side: BorderSide(
                                              width: 0,
                                              color: Colors.transparent,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        height: botHeight,
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: botHeight / 2,
                              padding: EdgeInsets.all(2.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(customX.route_create);
                                },
                                child: Text(
                                  Mt.create_link,
                                  style: TextStyle(
                                    fontFamily: "SCP",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Co.g,
                                  foregroundColor: Co.d2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: botHeight / 2,
                              padding: EdgeInsets.all(2.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(customX.route_manage);
                                },
                                child: Text(
                                  Mt.login,
                                  style: TextStyle(
                                    fontFamily: "SCP",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  animationDuration: Duration(seconds: 0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  width: double.infinity,
                  duration: Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: Co.bg,
                  ),
                  clipBehavior: Clip.hardEdge,
                  height: aboutHeight,
                  curve: accelerateEasing,
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: headHeight,
                            clipBehavior: Clip.hardEdge,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Co.bg,
                            ),
                            padding: EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Container(
                                  height: headHeight - 10,
                                  width: headHeight - 10,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        aboutHeight = 0.0;
                                      });
                                    },
                                    child: Icon(
                                      Icons.keyboard_arrow_left_rounded,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(2),
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: headHeight - 10,
                                  width: MediaQuery.of(context).size.width -
                                      headHeight -
                                      10,
                                  clipBehavior: Clip.hardEdge,
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(
                                    left: 20,
                                  ),
                                  decoration: BoxDecoration(),
                                  child: Text(
                                    Mt.about_head + ' ' + Mt.app,
                                    style: TextStyle(
                                      fontFamily: "SCP",
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height -
                                MediaQuery.of(context).padding.top -
                                MediaQuery.of(context).padding.bottom -
                                headHeight,
                            width: double.infinity,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(),
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                  bottom: 20,
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 2,
                                      color: Co.d2,
                                    ),
                                    color: Color(0xff111111),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 5.0,
                                        color: Color(0xff111111),
                                        offset: Offset(3, 3),
                                      ),
                                    ],
                                  ),
                                  child: EasyRichText(
                                    Mt.about,
                                    selectable: true,
                                    textAlign: TextAlign.justify,
                                    defaultStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                    ),
                                    patternList: [
                                      EasyRichTextPattern(
                                        targetString: '.*',
                                        style: GoogleFonts.getFont(
                                            'Source Code Pro'),
                                      ),
                                      EasyRichTextPattern(
                                          targetString: 'TrueAnon',
                                          matchOption: [0],
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
