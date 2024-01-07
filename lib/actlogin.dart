//import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:loader_overlay/loader_overlay.dart';
//import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
//import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
//import 'package:http/http.dart' as http;
//import 'package:easy_splash_screen/easy_splash_screen.dart';
//import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'metadata.dart';
import 'colors.dart';
import 'custom_plugins.dart';
//import 'actlogin.dart';

class ActLogin extends StatefulWidget {
  const ActLogin({super.key});

  @override
  State<ActLogin> createState() => _ActLoginState();
}

class _ActLoginState extends State<ActLogin> {
  @override
  Widget build(BuildContext context) {
    return customX.Loader(MyLogin());
  }
}

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  int currentIndex = 0;

  IconData qm = Icons.more_horiz;
  var sub_name_c = TextEditingController();
  var sub_pass_c = TextEditingController();
  String sub_name = "";
  String sub_pass = "";
  bool _passNotVisible = true;
  AutovalidateMode autoval = AutovalidateMode.disabled;
  void _login() {
    Navigator.of(context).popAndPushNamed(customX.route_create);
  }

  void _submit() async {
    BuildContext ctx = context;
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.saveAndValidate()) {
        ctx.loaderOverlay.show();
        Map<String, dynamic> myobj = {
          'uid': _formKey.currentState!.value['name'],
          'pass': _formKey.currentState!.value['pass'],
          'save': 'no'
        };
        if (_formKey.currentState!.value['save_device'] == true) {
          myobj['save'] = 'yes';
        }
        customX.Postx(context, '/api/user-login', myobj, (res, err) async {
          ctx.loaderOverlay.hide();
          if (!err) {
            if (myobj['save'] == 'yes') {
              customX.saveDevice(myobj['uid'], res['message']).then((value) {
                if (value) {
                  customX
                      .createSession(myobj['uid'], res['name'])
                      .then((value) {
                    ctx.loaderOverlay.hide();
                    if (value) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          customX.route_dashboard, (route) => false);
                    } else {
                      customX.AlertX(
                        context,
                        Mt.err,
                        Mt.login_fail,
                        AlertType.error,
                      ).show();
                    }
                  });
                } else {
                  ctx.loaderOverlay.hide();
                  customX.AlertX(
                    context,
                    Mt.err,
                    Mt.dev_unsave_err,
                    AlertType.error,
                  ).show();
                }
              });
            } else {
              customX.createSession(myobj['uid'], res['name']).then((value) {
                ctx.loaderOverlay.hide();
                if (value) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      customX.route_dashboard, (route) => false);
                } else {
                  customX.AlertX(
                    context,
                    Mt.err,
                    Mt.login_fail,
                    AlertType.error,
                  ).show();
                }
              });
            }
          } else {
            ctx.loaderOverlay.hide();
            customX.AlertX(
              context,
              Mt.err,
              res['message'],
              AlertType.error,
            ).show();
          }
        });
      } else {
        ctx.loaderOverlay.hide();
        customX.AlertX(
          context,
          Mt.err,
          Mt.val_err,
          AlertType.error,
        ).show();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            Mt.gen_err,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'SCP',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }
  }

  IconData _eyeIcon = Icons.visibility;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: /*AppBar(
        backgroundColor: Color(0xff00ff40),
        foregroundColor: Color(0xff282828),
        title: Text(
          'Create Link',
          style: GoogleFonts.getFont(
            'Source Code Pro',
            fontWeight: FontWeight.w600,
          ),
        ),
      )*/
          null,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff080808),
                  Color(0xff181818),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        maxWidth: 600,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Container(
                          child: FormBuilder(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FormBuilderTextField(
                                    name: 'name',
                                    maxLines: 1,
                                    enabled: true,
                                    controller: sub_name_c,
                                    autovalidateMode: autoval,
                                    cursorColor: Co.d8,
                                    style: customX.fts,
                                    maxLength: 50,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: Mt.ht_uid,
                                      errorText: null,
                                      counterText: '',
                                      hintStyle: customX.hsty,
                                      errorMaxLines: 5,
                                      errorStyle: customX.esty,
                                      filled: true,
                                      fillColor: Co.d3,
                                      enabledBorder: customX.oib,
                                      focusedErrorBorder: customX.oib,
                                      focusedBorder: customX.oib,
                                      errorBorder: customX.oib,
                                      prefixIcon: Icon(
                                        Icons.person_rounded,
                                        color: Co.d8,
                                      ),
                                    ),
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(),
                                      (val) {
                                        if (val == null) {
                                          val = "";
                                        }
                                        if (RegExp(Mt.uidPattern)
                                            .hasMatch(val)) {
                                          return null;
                                        } else {
                                          return Mt.uidIns;
                                        }
                                      }
                                    ]),
                                    onChanged: (val) {
                                      setState(() {
                                        if (val != null) {
                                          sub_name = val;
                                        } else {
                                          sub_name = "";
                                        }
                                      });
                                    }),
                                SizedBox(
                                  height: 25,
                                ),
                                FormBuilderTextField(
                                  name: 'pass',
                                  maxLines: 1,
                                  enabled: true,
                                  maxLength: 100,
                                  controller: sub_pass_c,
                                  autovalidateMode: autoval,
                                  cursorColor: Co.d8,
                                  obscureText: _passNotVisible,
                                  style: customX.fts,
                                  decoration: InputDecoration(
                                    hintText: Mt.ht_pas,
                                    errorText: null,
                                    hintStyle: customX.hsty,
                                    errorMaxLines: 5,
                                    errorStyle: customX.esty,
                                    filled: true,
                                    fillColor: Co.d3,
                                    counterText: '',
                                    enabledBorder: customX.oib,
                                    focusedErrorBorder: customX.oib,
                                    focusedBorder: customX.oib,
                                    errorBorder: customX.oib,
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Co.d8,
                                    ),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (_passNotVisible == true) {
                                            _passNotVisible = false;
                                            _eyeIcon = Icons.visibility_off;
                                          } else {
                                            _passNotVisible = true;
                                            _eyeIcon = Icons.visibility;
                                          }
                                        });
                                      },
                                      child: Icon(
                                        _eyeIcon,
                                        color: Co.c7,
                                      ),
                                    ),
                                  ),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    (val) {
                                      if (val == null) {
                                        val = "";
                                      }
                                      if (RegExp(Mt.passPattern)
                                          .hasMatch(val)) {
                                        return null;
                                      } else {
                                        return Mt.passInsLog;
                                      }
                                    },
                                  ]),
                                  onChanged: (val) {
                                    setState(() {
                                      if (val != null) {
                                        sub_pass = val;
                                      } else {
                                        sub_pass = "";
                                      }
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: FormBuilderCheckbox(
                                    name: 'save_device',
                                    title: Text(
                                      Mt.save_device,
                                      style: customX.CheckTextStyle,
                                    ),
                                    activeColor: Co.g,
                                    checkColor: Co.bg,
                                    contentPadding:
                                        EdgeInsets.fromLTRB(20, 5, 5, 5),
                                    initialValue: false,
                                    side: BorderSide(
                                      color: Co.g,
                                    ),
                                    decoration: InputDecoration(
                                      border: customX.oib_check,
                                      contentPadding: EdgeInsets.all(0),
                                      counterText: '',
                                      disabledBorder: customX.oib_check,
                                      enabledBorder: customX.oib_check,
                                      errorBorder: customX.oib_check,
                                      focusedBorder: customX.oib_check,
                                      focusedErrorBorder: customX.oib_check,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    child: Text(Mt.loginBtn),
                                    onPressed: _submit,
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Co.c2,
                                      backgroundColor: Co.c4,
                                      textStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'SCP',
                                      ),
                                      padding: EdgeInsets.all(15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    child: Text(Mt.create_link_btn),
                                    onPressed: _login,
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Color(0xffaaaaaa),
                                      backgroundColor: Colors.transparent,
                                      textStyle: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'SCP',
                                      ),
                                      elevation: 0,
                                      padding: EdgeInsets.all(15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
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
            ),
          ),
        ],
      ),
    );
  }
}
