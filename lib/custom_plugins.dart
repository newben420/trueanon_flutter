import 'dart:async';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dashboard.dart';
import 'colors.dart';
import 'metadata.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_switch/flutter_switch.dart';

class customX {
  static int refresh_wait_time_s = 10;

  //routes
  static String route_home = "/home";
  static String route_create = "/create-link";
  static String route_manage = "/manage-messages";
  static String route_dashboard = "/dashboard";

  static var emptyDialog = DialogButton(
    child: null,
    onPressed: () {},
    width: 10.0,
  );

  static Future<bool> shareText(String txt, BuildContext context) async {
    try {
      final box = context.findRenderObject() as RenderBox?;

      await Share.share(txt,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
      return true;
    } catch (e) {
      customX.makeToast(Mt.gen_err);
      return false;
    }
  }

  static Alert AlertX(
      BuildContext context, String? titX, String? desX, AlertType altX,
      [String btnTXT = "Ok, Cool",
      String nameX = "",
      String urx = "",
      String uid = "",
      String login = "",
      String dev = "",
      var fn]) {
    return Alert(
      context: context,
      padding: EdgeInsets.all(10),
      closeIcon: Icon(
        Icons.close_rounded,
        color: Co.d8,
        size: 30,
      ),
      style: AlertStyle(
        alertBorder: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.transparent,
            width: 0.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Co.bg,
        buttonAreaPadding: EdgeInsets.only(
          bottom: 10,
        ),
        descPadding: EdgeInsets.all(10),
        titlePadding: EdgeInsets.all(10),
        titleStyle: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontFamily: 'SCP',
          fontWeight: FontWeight.w400,
        ),
        descStyle: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontFamily: 'SCP',
          fontWeight: FontWeight.w400,
        ),
      ),
      type: altX,
      title: titX,
      desc: desX,
      onWillPopActive: btnTXT == Mt.link_btn ? true : false,
      closeFunction: () async {
        if (btnTXT == Mt.link_btn) {
          FocusManager.instance.primaryFocus?.unfocus();
          if (login == "yes") {
            await customX.deleteLocalFile();
            customX.saveDevice(uid, dev).then((saved) {
              if (saved) {
                customX.createSession(uid, nameX).then((value) {
                  context.loaderOverlay.hide();
                  if (value) {
                    print("dash");
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        customX.route_dashboard, (route) => false);
                  } else {
                    customX.makeToast(Mt.login_fail_man);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }
                });
              } else {
                customX.makeToast(Mt.login_fail_man);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              }
            });
          } else {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          }
          //Navigator.of(context).pushNamed(customX.route_manage);
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
              customX.route_dashboard, (route) => false);
        }
      },
      buttons: [
        DialogButton(
          child: Text(
            btnTXT,
            style: TextStyle(
              color: Co.bg,
              fontSize: 15,
              fontFamily: 'SCP',
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: () {
            if (btnTXT == Mt.link_btn) {
              customX.shareText(
                  nameX + ": " + Mt.share_txt + " " + urx, context);
              fn();
            } else {
              Navigator.pop(context);
            }
          },
          width: 120,
          color: Co.g,
          radius: BorderRadius.circular(40),
        ),
      ],
    );
  }

  //styles

  static OutlineInputBorder oib = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.transparent,
      width: 0.0,
    ),
    borderRadius: BorderRadius.circular(50),
  );

  static OutlineInputBorder oib_check = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.transparent,
      width: 0.0,
      strokeAlign: 0,
      style: BorderStyle.none,
    ),
    borderRadius: BorderRadius.circular(0),
  );

  static TextStyle hsty = TextStyle(
    color: Color(0xffaaaaaa),
    fontWeight: FontWeight.w600,
  );

  static TextStyle CheckTextStyle = TextStyle(
    color: Colors.white,
    fontFamily: 'SCP',
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static TextStyle dashappstyle = TextStyle(
    color: Co.d8,
    fontFamily: 'SCP',
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static ButtonStyle dashmenubtn = ButtonStyle(
    elevation: MaterialStatePropertyAll(0),
    iconSize: MaterialStatePropertyAll(30),
    iconColor: MaterialStatePropertyAll(Co.d8),
    padding: MaterialStatePropertyAll(EdgeInsets.all(0)),
    shadowColor: MaterialStatePropertyAll(Colors.transparent),
    backgroundColor: MaterialStatePropertyAll(Colors.transparent),
    enableFeedback: false,
    animationDuration: Duration(milliseconds: 0),
    overlayColor: MaterialStatePropertyAll(Colors.transparent),
  );

  static TextStyle esty = TextStyle(
    color: Colors.red,
    fontFamily: 'SCP',
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static TextStyle fts = TextStyle(
    color: Color(0xffffffff),
    fontFamily: 'SCP',
    fontWeight: FontWeight.w600,
    fontSize: 14,
  );

  static TextStyle loaderTextStyle = TextStyle(
    color: Color(0xffffffff),
    fontFamily: 'SCP',
    fontWeight: FontWeight.w600,
    fontSize: 12,
  );

  static TextStyle versionStyle = TextStyle(
    color: Co.d8,
    fontFamily: 'SCP',
    fontWeight: FontWeight.w300,
    fontSize: 12,
  );

  static TextStyle helloStyle = TextStyle(
    color: Colors.white,
    fontFamily: 'SCP',
    fontWeight: FontWeight.w400,
    fontSize: 45,
  );
  static TextStyle nameStyle = TextStyle(
    color: Colors.white,
    fontFamily: 'SCP',
    fontWeight: FontWeight.w600,
    fontSize: 42,
  );
  // file and loader

  static void makeToast(String txt) {
    try {
      Fluttertoast.showToast(
          msg: txt,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Co.g,
          textColor: Co.bg,
          webShowClose: true,
          fontSize: 14.0);
    } catch (e) {}
  }

  static Future<String> get _localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/user_token.txt');
  }

  static Future<bool> deleteLocalFile() async {
    try {
      final file = await _localFile;
      await file.delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  static dynamic Loader(dynamic page) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayColor: Co.d1,
      overlayOpacity: 1,
      overlayWidget: Center(
        child: SpinKitWave(
          color: Co.g,
          size: 40.0,
        ),
      ),
      child: page,
    );
  }

  static Future<Object> AppLoader(BuildContext ctx) async {
    //await Future.delayed(Duration(milliseconds: 5000));
    try {
      final file = await _localFile;
      final ct = await file.readAsString();
      try {
        final test_co = RegExp(r'^\d{6}\s[a-zA-Z0-9]+$');
        if (test_co.hasMatch(ct)) {
          final connectivityResult = await (Connectivity().checkConnectivity());
          if (connectivityResult == ConnectivityResult.none) {
            return Future.value(Loader(Dashboard()));
          } else {
            Map<String, dynamic> body = {
              'content': ct,
            };
            try {
              var response = await http
                  .post(customX.urlx('/api/decode-token'), body: body)
                  .timeout(Duration(seconds: customX.timeout));
              JsonDecoder decoder = JsonDecoder();
              Map<String, dynamic> res = decoder.convert(response.body);
              if (res['succ'] != 1) {
                if (res['nodel'] == 1) {
                  return Future.value(Loader(Dashboard()));
                } else {
                  await customX.deleteLocalFile();
                  customX.makeToast(Mt.login_fail_man);
                  return Future.value(Loader(LoginPage()));
                }
              } else {
                await customX.createSession(res['uid'], res['name']);
                return Future.value(Loader(Dashboard()));
              }
            } catch (exx) {
              return Future.value(Loader(Dashboard()));
            }
          }
        } else {
          await customX.deleteLocalFile();
          customX.makeToast(Mt.login_fail_man);
          return Future.value(Loader(LoginPage()));
        }
      } catch (e) {
        customX.makeToast(Mt.login_fail_man);
        await Future.delayed(Duration(milliseconds: 1000));
        return Future.value(Loader(LoginPage()));
      }
    } catch (exp) {
      await Future.delayed(Duration(milliseconds: 1000));
      return Future.value(Loader(LoginPage()));
    }
  }

  static Future<Map<String, dynamic>> userStat() async {
    Map<String, dynamic> obj = {};
    obj['succ'] = false;
    try {
      dynamic uid = await SessionManager().get("uid");
      dynamic name = await SessionManager().get("name");
      if (uid == null || name == null) {
        //session not set
        final file = await _localFile;
        final ct = await file.readAsString();
        final test_co = RegExp(r'^\d{6}\s[a-zA-Z0-9]+$');
        if (test_co.hasMatch(ct)) {
          final connectivityResult = await (Connectivity().checkConnectivity());
          if (connectivityResult == ConnectivityResult.none) {
            obj['offline'] = true;
            return obj;
          } else {
            Map<String, dynamic> body = {
              'content': ct,
            };
            try {
              var response = await http.post(customX.urlx('/api/decode-token'),
                  body: body);
              JsonDecoder decoder = JsonDecoder();
              Map<String, dynamic> res = decoder.convert(response.body);
              if (res['succ'] != 1) {
                if (res['nodel'] == 1) {
                  return obj;
                } else {
                  await customX.deleteLocalFile();
                  customX.makeToast(Mt.invalid_session);
                  obj['kick'] = true;
                  return obj;
                }
              } else {
                await customX.createSession(res['uid'], res['name']);
                obj['succ'] = true;
                obj['uid'] = res['uid'];
                obj['name'] = res['name'];
                return obj;
              }
            } catch (exx) {
              return obj;
            }
          }
        } else {
          await customX.deleteLocalFile();
          customX.makeToast(Mt.invalid_session);
          obj['kick'] = true;
          return obj;
        }
      } else {
        obj['succ'] = true;
        obj['uid'] = uid;
        obj['name'] = name;
        return obj;
      }
    } catch (e) {
      return obj;
    }
  }

  static Future<bool> saveDevice(String uid, String tok) async {
    try {
      final file = await _localFile;
      await file.writeAsString(uid + " " + tok);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> createSession(String uid, String name) async {
    try {
      await SessionManager().set("uid", uid);
      await SessionManager().set("name", name);
      return true;
    } catch (e) {
      return false;
    }
    //dynamic id = await SessionManager().get("id");
  }

  static Future<bool> onWillPop(BuildContext context) async {
    bool? exitResult = await showDialog(
      context: context,
      builder: (context) => _buildExitDialog(context),
    );
    return exitResult ?? false;
  }

  static Widget hr() {
    return Container(
      width: double.infinity,
      height: 21,
      padding: EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 10,
      ),
      child: Container(
        color: Co.d8.withOpacity(0.2),
      ),
    );
  }

  static Widget btn(String txt, IconData ico, dynamic fn,
      [double mw = double.infinity]) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: mw,
      ),
      child: (TextButton(
        onPressed: fn,
        clipBehavior: Clip.antiAlias,
        style: ButtonStyle(
          side: MaterialStatePropertyAll(BorderSide(
            color: Co.d8,
            width: 1,
          )),
          padding: MaterialStatePropertyAll(
              EdgeInsets.symmetric(vertical: 10, horizontal: 12)),
          enableFeedback: false,
          animationDuration: Duration(milliseconds: 150),
          overlayColor: MaterialStatePropertyAll(Co.d8.withOpacity(0.1)),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          alignment: Alignment.center,
        ),
        child: Row(
          children: [
            Icon(
              ico,
              color: Co.d8,
              size: 22,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                txt,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: "SCP",
                  fontSize: 16,
                  color: Co.d8,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  static double icon_width = 50;

  static Widget menuItem(String txt, IconData ico, dynamic fn,
      [bool status = false]) {
    return (GestureDetector(
      onTap: txt == Mt.menu_3_1 ? () {} : fn,
      child: Container(
        width: double.infinity,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
        constraints: BoxConstraints(
          minHeight: icon_width,
        ),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              width: icon_width,
              child: Icon(
                ico,
                color: Co.g,
                size: 24,
              ),
            ),
            Expanded(
              child: Container(
                child: Text(
                  txt,
                  style: TextStyle(
                    fontFamily: 'SCP',
                    color: txt == Mt.menu_4 ? Colors.red : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            txt == Mt.menu_3_1
                ? FlutterSwitch(
                    width: 45.0,
                    height: 20.0,
                    valueFontSize: 25.0,
                    toggleSize: 35.0,
                    value: status,
                    activeColor: Co.g,
                    activeToggleColor: Co.d3,
                    toggleColor: Co.d3,
                    borderRadius: 30.0,
                    padding: 2.0,
                    showOnOff: false,
                    onToggle: (val) {
                      fn(val);
                    },
                  )
                : Container()
          ],
        ),
      ),
    ));
  }

  // Future<bool?> _showExitDialog(BuildContext context) async {
  //   return await showDialog(
  //     context: context,
  //     builder: (context) => _buildExitDialog(context),
  //   );
  // }

  static AlertDialog _buildExitDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Please confirm'),
      content: const Text('Do you want to exit the app?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'No',
            style: TextStyle(
              color: Co.d3,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            'Yes',
            style: TextStyle(
              color: Co.d8,
            ),
          ),
        ),
      ],
    );
  }

  //connectors
  static int timeout = 10;
  static Uri urlx(String link) {
    return Uri.http(Mt.api_url, link);
  }

  static dynamic Postx(
      BuildContext ctx, var url, dynamic body, dynamic fn) async {
    try {
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        ctx.loaderOverlay.hide();
        customX.AlertX(
          ctx,
          Mt.err,
          Mt.conn_err,
          AlertType.error,
        ).show();
      } else {
        var response = await http
            .post(customX.urlx(url), body: body)
            .timeout(Duration(seconds: customX.timeout));
        JsonDecoder decoder = JsonDecoder();
        Map<String, dynamic> res = decoder.convert(response.body);
        if (res['succ'] != 1) {
          fn(res, true);
        } else {
          fn(res, false);
        }
      }
    } catch (err) {
      ctx.loaderOverlay.hide();
      customX.AlertX(
        ctx,
        Mt.err,
        Mt.generic_err,
        AlertType.error,
      ).show();
    }
  }
}
