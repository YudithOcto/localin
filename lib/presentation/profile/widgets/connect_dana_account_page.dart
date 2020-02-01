import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/dana/dana_activate_base_response.dart';
import 'package:localin/presentation/profile/profile_page.dart';
import 'package:localin/presentation/webview/webview_page.dart';

import '../../../themes.dart';

class ConnectDanaAccountPage extends StatefulWidget {
  static const routeName = '/connectDana';
  @override
  _ConnectDanaAccountPageState createState() => _ConnectDanaAccountPageState();
}

class _ConnectDanaAccountPageState extends State<ConnectDanaAccountPage> {
  bool autoValidate = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Repository _repository = Repository();
  TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController();
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 5.0,
        backgroundColor: Theme.of(context).canvasColor,
        title: Image.asset(
          'images/app_bar_logo.png',
          width: MediaQuery.of(context).size.width * 0.3,
          height: 50.0,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.5,
          margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          decoration: BoxDecoration(
              border: Border.all(color: Themes.primaryBlue),
              borderRadius: BorderRadius.circular(10.0)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Enter your DANA Account',
                  style: kValueStyle.copyWith(
                      fontSize: 50.0, color: Themes.primaryBlue),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Form(
                  key: formKey,
                  autovalidate: autoValidate,
                  child: Container(
                    height: 60.0,
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
                      validator: validateMobile,
                      decoration: InputDecoration(
                          hintText: '081123456789',
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Themes.primaryBlue),
                              borderRadius: BorderRadius.circular(12.0)),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Themes.primaryBlue))),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  width: double.infinity,
                  height: 60.0,
                  child: RaisedButton(
                    onPressed: () {
                      validateInput();
                    },
                    elevation: 5.0,
                    color: Themes.primaryBlue,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Themes.primaryBlue),
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Text(
                      'CONNECT',
                      style: kValueStyle.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void validateInput() async {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();
      final result = await authenticateUserDanaAccount();
      if (result.urlRedirect.isNotEmpty && !result.error) {
        final response = await Navigator.of(context).pushNamed(
            WebViewPage.routeName,
            arguments: {WebViewPage.urlName: result.urlRedirect});
        if (response != null && response == 'success') {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('DANA'),
                  content: Text(
                    'Connect to dana success',
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      color: Themes.primaryBlue,
                      onPressed: () => Navigator.of(context).pop('success'),
                      child: Text(
                        'Ok',
                        style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                );
              });
        }
      }
    } else {
      setState(() {
        autoValidate = true;
      });
    }
  }

  String validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  Future<DanaActivateBaseResponse> authenticateUserDanaAccount() async {
    final result = await _repository.activateDana(phoneController.text);
    return result;
  }
}
