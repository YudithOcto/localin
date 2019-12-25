import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:localin/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SocialSignIn {
  final facebookLogin = FacebookLogin();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<Map<String, dynamic>> signInFacebook() async {
    final result = await facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final AuthCredential credential =
            FacebookAuthProvider.getCredential(accessToken: token);
        final AuthResult authResult =
            await _auth.signInWithCredential(credential);
        final FirebaseUser user = authResult.user;

        Map<String, dynamic> _userResult = Map();
        _userResult['user_id'] = user.uid;
        _userResult['user_email'] = user.email;
        _userResult['user_name'] = user.displayName;
        _userResult['user_photo'] = user.photoUrl;
        _userResult['source'] = credential.providerId;

        SharedPreferences sf = await SharedPreferences.getInstance();
        sf.setString(
            kFacebookExpired, result.accessToken.expires.toIso8601String());
        return _userResult;
        break;

      case FacebookLoginStatus.cancelledByUser:
        Map<String, dynamic> _userResult = Map();
        _userResult['error'] = 'Cancelled';
        return _userResult;
        break;
      case FacebookLoginStatus.error:
        Map<String, dynamic> _userResult = Map();
        _userResult['error'] = 'Sign in error';
        return _userResult;
        break;
    }
    return null;
  }

  Future<Map<String, dynamic>> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    Map<String, dynamic> _userResult = Map();
    try {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final AuthResult authResult =
          await _auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);

      _userResult['user_id'] = user.uid;
      _userResult['user_email'] = user.email;
      _userResult['user_name'] = user.displayName;
      _userResult['user_photo'] = user.photoUrl;
      _userResult['source'] = credential.providerId;
    } catch (error) {
      _userResult['error'] = 'Authentication failed';
    }

    return _userResult;
  }

  Future<Null> signOutGoogle() async {
    var result = await googleSignIn.signOut();
    print(result);
    await _auth.signOut();
  }

  Future<Null> facebookLogout() async {
    await facebookLogin.logOut();
  }
}
