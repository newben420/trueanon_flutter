//import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:core';
import 'package:path/path.dart' as Path;
//import 'package:google_fonts/google_fonts.dart';
//import 'package:flutter_form_builder/flutter_form_builder.dart';
//import 'package:loader_overlay/loader_overlay.dart';
//import 'package:flutter_spinkit/flutter_spinkit.dart';
//import 'package:form_builder_validators/form_builder_validators.dart';
//import 'package:easy_rich_text/easy_rich_text.dart';
//import 'package:rflutter_alert/rflutter_alert.dart';
//import 'package:http/http.dart' as http;
//import 'package:easy_splash_screen/easy_splash_screen.dart';
//import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'metadata.dart';
import 'colors.dart';
import 'custom_plugins.dart';
//import 'actlogin.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:sqflite/sqflite.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return customX.Loader(MyDash());
  }
}

class MyDash extends StatefulWidget {
  const MyDash({super.key});

  @override
  State<MyDash> createState() => _MyDashState();
}

class _MyDashState extends State<MyDash> {
  late Database db;
  late var subscription;
  List<int> ids = [0];
  bool tablex = false;

  // IO.Socket socket;
  late IO.Socket socket;

  _loadUser([dynamic search = false]) {
    socket.emit("load_user_0ei9uy3", [search, ids.join(", ")]);
  }

  _loadDB() async {
    try {
      var databasesPath = await getDatabasesPath();
      String path = Path.join(databasesPath, 'trueanon.db');
      //await deleteDatabase(path);
      db = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE IF NOT EXISTS messages (id INTEGER PRIMARY KEY, real_id INTEGER, token TEXT, message TEXT, seen_status INTEGER, date_created TEXT)');
      });
      tablex = true;
    } catch (e) {
      tablex = false;
    }
  }

  _getIDs() async {
    try {
      List<Map> list = await db.rawQuery('SELECT real_id FROM messages');
      int i, l = list.length;
      ids.clear();
      ids.insert(0, 0);
      for (i = 0; i < l; i++) {
        var rid = list[i]['real_id'];
        if (rid == null) {
          rid = 0;
        }
        ids.insert((0 + i), rid);
      }
      ids = ids.toSet().toList();
      tablex = true;
    } catch (e) {
      tablex = false;
    }
  }

  Future<bool> syncLocalDB(dynamic ms, int l) async {
    try {
      await db.transaction((txn) async {
        int i;
        for (i = 0; i < l; i++) {
          await txn.rawInsert(
              'INSERT INTO messages(real_id, token, message, seen_status, date_created) VALUES(?, ?, ?, ?, ?)',
              [
                ms[i]['id'],
                ms[i]['token'],
                ms[i]['message'],
                ms[i]['seen_status'],
                ms[i]['date_created']
              ]);
        }
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  _freshenDB(uid) async {
    try {
      await db.rawDelete('DELETE FROM messages WHERE NOT token = ?', [uid]);
    } catch (e) {}
  }

  String db_name = "There";
  String user_share = "";
  bool sock = false;

  int last_clicked = DateTime.now().millisecondsSinceEpoch;

  bool sub = false;

  _onLayoutDone([_ = null]) async {
    await _loadDB();
    customX.userStat().then((user) async {
      //print(2020);
      //print(user);
      // try {
      //   socket.destroy();
      //   socket.dispose();
      //   sock = false;
      // } catch (e) {}
      if (user['succ']) {
        user_share = user['name'] +
            ": " +
            Mt.share_txt +
            " " +
            Mt.url +
            "/" +
            user['uid'].toString();
        setState(() {
          db_name = user['name'];
        });
        await _freshenDB(user['uid']);
        await _getIDs();
        try {
          print(sock);
          if (!sock) {
            String sock_url = Mt.socket_protocol + Mt.api_url;
            socket = await IO.io(sock_url, <String, dynamic>{
              'transports': ['websocket'],
              'autoConnect': false,
              'retries': 2000000,
            });
            await socket.connect();
            socket.onConnect((_) {
              socket.emit(
                  'app_create_socket.session', [user['uid'], user['name']]);
              _loadUser();
            });
            socket.onConnectError((data) {});
            socket.onError((data) {});
            socket.onDisconnect((_) => null);
            socket.on("reload_device", (data) {
              _loadUser();
            });
            socket.on("load_user_from_server", (data) async {
              try {
                dynamic ms = data['message'];
                print('fetched' + ms.toString());
                int l = ms.length;
                if (l > 0) {
                  syncLocalDB(ms, l).then((vax) {
                    if (!vax) {
                      customX.makeToast(Mt.unparse);
                    } else {}
                  });
                }
              } catch (e) {
                customX.makeToast(Mt.unparse);
              }
            });
            sock = true;
          } else {
            _loadUser();
          }
        } catch (e) {
          customX.makeToast(Mt.unparse);
        }
      } else {
        if (user['kick']) {
          customX.makeToast(Mt.invalid_session);
          Navigator.of(context).popAndPushNamed(customX.route_home);
        } else {
          if (user['offline']) {
            try {
              subscription = Connectivity()
                  .onConnectivityChanged
                  .listen((ConnectivityResult result) {
                customX.makeToast(Mt.no_network);
                if (result != ConnectivityResult.none) {
                  _onLayoutDone(_);
                  subscription.cancel();
                  sub = false;
                }
              });
              sub = true;
            } catch (e) {}
          } else {
            sub = false;
          }
          customX.makeToast(Mt.unloaded);
        }
      }
    });
  }

  @override
  void dispose() {
    print("dispose called");
    try {
      socket.dispose();
      sock = false;
    } catch (e) {}
    try {
      subscription.cancel();
    } catch (e) {}
    // try {
    //   _onLayoutDone();
    // } catch (e) {}
    super.dispose();
  }

  @override
  void initState() {
    print("init called");
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
    super.initState();
  }

  double head_height = 55.0;
  int menu_duration = 350;
  bool menuShow = false;
  double backdrop_height = 0.0;
  double backdrop_opacity = 0.0;
  double menu_left = -1.0 *
      WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width
          .toDouble();

  _menu() {
    setState(() {
      if (menuShow) {
        backdrop_height = 0.0;
        backdrop_opacity = 0.0;
        menuShow = false;
        menu_left = -1.0 *
            WidgetsBinding
                .instance.platformDispatcher.views.first.physicalSize.width
                .toDouble();
      } else {
        backdrop_height = double.infinity;
        backdrop_opacity = 0.5;
        menuShow = true;
        menu_left = 0.0;
      }
    });
  }

  bool toggleState = false;

  // @override
  // void didUpdateWidget(MyDash oldWidget) {
  //   print("did update widget");
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => customX.onWillPop(context),
      child: Scaffold(
        appBar: null,
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Co.bg, Colors.black],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: double.infinity,
              child: SafeArea(
                child: SingleChildScrollView(
                  clipBehavior: Clip.hardEdge,
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: head_height,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: head_height,
                              width: head_height,
                              child: TextButton(
                                onPressed: () {
                                  _menu();
                                },
                                child: Icon(Icons.menu_rounded),
                                style: customX.dashmenubtn,
                              ),
                            ),
                            Container(
                              height: head_height,
                              width: MediaQuery.of(context).size.width -
                                  (2 * head_height),
                              clipBehavior: Clip.hardEdge,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(),
                              child: Text(
                                Mt.app,
                                style: customX.dashappstyle,
                              ),
                            ),
                            Container(
                              height: head_height,
                              width: head_height,
                              child: TextButton(
                                onPressed: () {
                                  print("open search");
                                },
                                child: Icon(Icons.search_rounded),
                                style: customX.dashmenubtn,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height -
                              head_height -
                              MediaQuery.of(context).padding.top -
                              MediaQuery.of(context).padding.bottom,
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                          constraints: BoxConstraints(
                            maxWidth: 1000,
                          ),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  alignment: Alignment.topLeft,
                                  // constraints: BoxConstraints(
                                  //   minHeight: 150,
                                  // ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Mt.hello + ",\n" + db_name + "!",
                                        style: customX.helloStyle,
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      // Text(
                                      //   db_name,
                                      //   style: customX.nameStyle,
                                      // ),
                                      customX.btn(Mt.share, Icons.share_rounded,
                                          () {
                                        customX.shareText(user_share, context);
                                      }, 160),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      customX.btn(
                                          Mt.refresh, Icons.refresh_rounded,
                                          () {
                                        int nowx = DateTime.now()
                                            .millisecondsSinceEpoch;
                                        int diff =
                                            ((nowx - last_clicked) / 1000)
                                                .ceil();
                                        if (diff <
                                            customX.refresh_wait_time_s) {
                                          customX.makeToast(Mt.please_wait +
                                              " " +
                                              (customX.refresh_wait_time_s -
                                                      diff)
                                                  .toString() +
                                              "s");
                                        } else {
                                          last_clicked = nowx;
                                          try {
                                            if (sub) {
                                              subscription.cancel();
                                            }
                                            _onLayoutDone();
                                          } catch (e) {
                                            print(e);
                                          }
                                        }
                                      }, 290)
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _menu();
              },
              child: Container(
                width: double.infinity,
                height: backdrop_height,
                child: AnimatedContainer(
                  height: double.infinity,
                  width: double.infinity,
                  duration: Duration(
                    milliseconds: menu_duration,
                  ),
                  color: Color(0xff000000).withOpacity(backdrop_opacity),
                ),
              ),
            ),
            AnimatedPositioned(
              left: menu_left,
              curve: Curves.decelerate,
              duration: Duration(
                milliseconds: menu_duration,
              ),
              child: SafeArea(
                child: Container(
                  height: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                  width: MediaQuery.of(context).size.width * 0.75,
                  constraints: BoxConstraints(
                    maxWidth: 700,
                  ),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    colors: [Co.d28, Co.bg],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Co.bg,
                          ),
                          padding: EdgeInsets.all(50),
                          child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            foregroundDecoration: BoxDecoration(
                              image: DecorationImage(
                                image:
                                    AssetImage('images/trueanon_new_icon.png'),
                                fit: BoxFit.contain,
                                alignment: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        customX.menuItem(Mt.menu_1, Icons.add_link_rounded, () {
                          _menu();
                          Navigator.of(context)
                              .pushReplacementNamed(customX.route_create);
                          // try {
                          //   socket.dispose();
                          //   sock = false;
                          // } catch (e) {}
                        }),
                        customX.hr(),
                        customX.menuItem(Mt.menu_2_1, Icons.person_rounded, () {
                          _menu();
                        }),
                        customX.menuItem(Mt.menu_2_2, Icons.vpn_key_rounded,
                            () {
                          _menu();
                        }),
                        customX.menuItem(Mt.menu_2_3, Icons.logout_rounded, () {
                          _menu();
                        }),
                        customX.hr(),
                        customX.menuItem(Mt.menu_3_1, Icons.phone_android,
                            (val) {
                          setState(() {
                            if (toggleState) {
                              toggleState = false;
                            } else {
                              toggleState = true;
                            }
                          });
                        }, toggleState),
                        customX.menuItem(
                            Mt.menu_3_2, Icons.phonelink_erase_rounded, () {
                          _menu();
                        }),
                        customX.hr(),
                        customX.menuItem(Mt.menu_4, Icons.link_off_rounded, () {
                          _menu();
                        }),
                        customX.hr(),
                        Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                            vertical: 20,
                          ),
                          child: Text(
                            Mt.app + " V" + Mt.version + "\n" + Mt.rights,
                            style: customX.versionStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
