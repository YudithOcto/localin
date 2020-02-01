import 'package:flutter/material.dart';
import 'package:localin/api/repository.dart';
import 'package:localin/model/user/user_base_model.dart';
import 'package:localin/presentation/login/phone_verification_page.dart';

class InputPhoneNumber extends StatefulWidget {
  static const routeName = '/phoneVerify';
  @override
  _InputPhoneNumberState createState() => _InputPhoneNumberState();
}

class _InputPhoneNumberState extends State<InputPhoneNumber> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool autoValidate = false;
  String _phoneNumber = '';
  Repository _repository = Repository();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: size.width * 0.4,
                  height: size.height * 0.2,
                  child: Image.asset(
                    'images/phone_auth.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Masukkan No Hp'),
                ),
                Form(
                  key: formKey,
                  autovalidate: autoValidate,
                  child: Row(
                    children: <Widget>[
                      Text('+62'),
                      SizedBox(
                        width: 20.0,
                      ),
                      Expanded(
                        child: TextFormField(
                          validator: (value) =>
                              value.isEmpty ? 'This field required' : null,
                          textInputAction: TextInputAction.go,
                          keyboardType: TextInputType.phone,
                          onSaved: (value) {
                            _phoneNumber = value;
                          },
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Builder(
                  builder: (ctx) => RaisedButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      if (validateInput()) {
                        final result = await userPhoneRequest();
                        if (result.error == null) {
                          setState(() {
                            _isLoading = false;
                          });
                          Navigator.of(ctx).pushReplacementNamed(
                              PhoneVerificationPage.routeName,
                              arguments: {
                                PhoneVerificationPage.phone: _phoneNumber,
                                PhoneVerificationPage.isBackButtonActive: true,
                              });
                        } else {
                          Scaffold.of(ctx).showSnackBar(SnackBar(
                            content: Text('${result?.error}'),
                          ));
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      }
                    },
                    color: Colors.blue,
                    child: Text('Submit'),
                  ),
                )
              ],
            ),
            Visibility(
              visible: _isLoading,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<UserBaseModel> userPhoneRequest() async {
    if (!_phoneNumber.startsWith('0')) {
      this._phoneNumber = '0$_phoneNumber';
    }
    final response = await _repository.userPhoneRequestCode(_phoneNumber);
    return response;
  }

  bool validateInput() {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      setState(() {
        autoValidate = true;
      });
      return false;
    }
  }
}
