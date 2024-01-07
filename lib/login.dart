//import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:loader_overlay/loader_overlay.dart';
//import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
//import 'package:http/http.dart' as http;
//import 'package:easy_splash_screen/easy_splash_screen.dart';
//import 'package:flutter_fast_forms/flutter_fast_forms.dart';
import 'metadata.dart';
import 'colors.dart';
import 'custom_plugins.dart';
//import 'actlogin.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
  AutovalidateMode autoval = AutovalidateMode.onUserInteraction;
  void _login() {
    Navigator.of(context).popAndPushNamed(customX.route_manage);
  }

  void _submit() async {
    BuildContext ctx = context;
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.saveAndValidate()) {
        ctx.loaderOverlay.show();
        Map<String, dynamic> myobj = {
          'name': _formKey.currentState!.value['name'],
          'pass': _formKey.currentState!.value['pass'],
          'login': 'no'
        };
        if (_formKey.currentState!.value['auto_login'] == true) {
          myobj['login'] = 'yes';
        }
        //print(_formKey.currentState!.value['name']);
        customX.Postx(context, '/api/create-link', myobj, (res, err) async {
          ctx.loaderOverlay.hide();
          if (!err) {
            customX.AlertX(
                    context,
                    Mt.succ,
                    Mt.link_succ + "\n\n User ID: " + res['message'],
                    AlertType.success,
                    Mt.link_btn,
                    res['n'],
                    res['u'] + "/" + res['message'],
                    res['message'],
                    myobj['login'],
                    res['dev'], () {
              //sub_name = "";
              //_formKey.currentState!.fields['name']?.reset();
              //if (_formKey.currentState != null) {
              //_formKey.currentState.setAttributeValue('name', '')?;
              // }
              //sub_name_c.clear();
              //_formKey.currentState!.
            })
                .show();
          } else {
            customX.AlertX(
              context,
              Mt.err,
              res['message'],
              AlertType.error,
            ).show();
          }
        });
      } else {
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
      body: currentIndex == 0
          ? Stack(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        decoration: InputDecoration(
                                          hintText: Mt.ht_nam,
                                          errorText: null,
                                          hintStyle: customX.hsty,
                                          errorMaxLines: 5,
                                          counterText: '',
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
                                        validator:
                                            FormBuilderValidators.compose([
                                          FormBuilderValidators.required(),
                                          (val) {
                                            if (val == null) {
                                              val = "";
                                            }
                                            if (RegExp(Mt.namePattern)
                                                .hasMatch(val)) {
                                              return null;
                                            } else {
                                              return Mt.nameIns;
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
                                        },
                                        onTap: () {
                                          setState(() {
                                            autoval = AutovalidateMode
                                                .onUserInteraction;
                                          });
                                        },
                                      ),
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
                                          counterText: '',
                                          filled: true,
                                          fillColor: Co.d3,
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
                                                  _eyeIcon =
                                                      Icons.visibility_off;
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
                                        validator:
                                            FormBuilderValidators.compose([
                                          FormBuilderValidators.required(),
                                          (val) {
                                            if (val == null) {
                                              val = "";
                                            }
                                            if (RegExp(Mt.passPattern)
                                                .hasMatch(val)) {
                                              return null;
                                            } else {
                                              return Mt.passIns;
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
                                        onTap: () {
                                          setState(() {
                                            autoval = AutovalidateMode
                                                .onUserInteraction;
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Center(
                                        child: FormBuilderCheckbox(
                                          name: 'auto_login',
                                          title: Text(
                                            Mt.auto_login,
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
                                            focusedErrorBorder:
                                                customX.oib_check,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          child: Text(Mt.create_link),
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
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Container(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          child: Text(Mt.login),
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
                                              borderRadius:
                                                  BorderRadius.circular(50),
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
            )
          : Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Co.bg,
                ),
                Positioned.fill(
                  child: Image.asset(
                    'images/bgx.png',
                    repeat: ImageRepeat.repeat,
                  ),
                ),
                SafeArea(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Color(0xff1c1c1c),
                          ),
                          color: Color(0xff1c1c1c),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 5.0,
                              color: Color(0xff111111),
                              offset: Offset(3, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: EasyRichText(
                            Mt.create,
                            selectable: true,
                            textAlign: TextAlign.justify,
                            defaultStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                            patternList: [
                              EasyRichTextPattern(
                                targetString: '.*',
                                style: GoogleFonts.getFont('Source Code Pro'),
                              ),
                              EasyRichTextPattern(
                                targetString: 'STEPS',
                                matchOption: [0],
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff00ff40),
                                  fontSize: 20,
                                  letterSpacing: 3,
                                ),
                              ),
                              EasyRichTextPattern(
                                targetString: 'Please Note That:',
                                matchOption: [0],
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff00ff40),
                                  fontSize: 20,
                                  letterSpacing: 3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.loaderOverlay.show();
          Future.delayed(const Duration(milliseconds: 200), () {
            setState(() {
              if (currentIndex == 0) {
                currentIndex = 1;
                qm = Icons.arrow_back_rounded;
              } else {
                currentIndex = 0;
                qm = Icons.more_horiz;
              }
              context.loaderOverlay.hide();
            });
          });
        },
        backgroundColor: Color(0xff00ff40),
        child: Icon(
          qm,
          color: Color(0xff222222),
          size: 21,
          semanticLabel: Mt.ins,
        ),
      ),
    );
  }
}
