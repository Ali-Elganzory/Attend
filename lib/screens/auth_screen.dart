import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../components/custom_dialog.dart';

import '../providers/auth.dart';

import '../models/http_exception.dart';

import '../utils/validators/email_validator.dart';
import '../utils/validators/fullname_validator.dart';
import '../utils/validators/password_validator.dart';

class AuthScreen extends StatelessWidget {
  static const String routeName = "/AuthScreen";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _nameKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _emailKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _passwordKey = GlobalKey<FormFieldState>();

  String _name;
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    double sh = deviceSize.height;
    double sw = deviceSize.width;
    int _animationDuration = 300;

    Auth _staticAuthProvider = Provider.of<Auth>(context);

    _showErrorDialog(String errorMessage) {
      showDialog(
        context: context,
        builder: (ctx) => CustomDialog(
          title: "Something went wrong..",
          description: errorMessage,
          positiveButtonText: null,
          negativeButtonText: "Okay",
        ),
      );
    }

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: CustomPaint(
          painter: AuthScreenBackground(),
          size: deviceSize,
          child: Container(
            height: sh,
            width: sw,
            padding: EdgeInsets.symmetric(
              horizontal: 0.085 * sw,
            ),
            child: Selector<Auth, bool>(
              selector: (_, auth) => auth.isLogin,
              builder: (_, isLogin, __) => Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  AnimatedContainer(
                    padding: EdgeInsets.only(top: 0.10 * sh, bottom: 0.04 * sh),
                    duration: Duration(milliseconds: _animationDuration),
                    height: isLogin ? 0.338 * sh : 0.256 * sh,
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 5.0,
                            blurRadius: 4.0,
                            color: Theme.of(context).primaryColor
                          ),
                        ],
                      ),
                      child: Image.asset('assets/images/eng_asu_logo.png'),
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: _animationDuration),
                    height: isLogin ? 0.350 * sh : 0.540 * sh,
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(
                      horizontal: 0.054 * sw,
                      vertical: 0.010 * sh,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      color: const Color(0xFFFFFFFF),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          spreadRadius: 5,
                          color: Colors.black12,
                        )
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                height: 0.048 * sh,
                                width: 0.300 * sw,
                                child: FlatButton(
                                  color: isLogin
                                      ? Theme.of(context).primaryColor
                                      : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 1.0,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(0.046 * sh / 2),
                                      bottomLeft:
                                          Radius.circular(0.046 * sh / 2),
                                    ),
                                  ),
                                  child: Text(
                                    'Login',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .apply(
                                          color: isLogin
                                              ? Colors.white
                                              : Theme.of(context).primaryColor,
                                        ),
                                  ),
                                  onPressed: () {
                                    _staticAuthProvider.authMode =
                                        AuthMode.login;
                                  },
                                ),
                              ),
                              Container(
                                height: 0.048 * sh,
                                width: 0.300 * sw,
                                child: FlatButton(
                                  color: isLogin
                                      ? Colors.white
                                      : Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: 1.0,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(0.046 * sh / 2),
                                      bottomRight:
                                          Radius.circular(0.046 * sh / 2),
                                    ),
                                  ),
                                  child: Text(
                                    'Signup',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .apply(
                                          color: isLogin
                                              ? Theme.of(context).primaryColor
                                              : Colors.white,
                                        ),
                                  ),
                                  onPressed: () {
                                    _staticAuthProvider.authMode =
                                        AuthMode.signup;
                                  },
                                ),
                              ),
                            ],
                          ),
                          ...[
                            if (!isLogin)
                              TextFormField(
                                key: _nameKey,
                                keyboardType: TextInputType.text,
                                style: Theme.of(context).textTheme.headline3,
                                decoration: InputDecoration(
                                  labelText: 'Full Name',
                                ),
                                validator: validateFullName,
                                onSaved: (name) {
                                  _name = name;
                                },
                              ),
                            TextFormField(
                              key: _emailKey,
                              keyboardType: TextInputType.emailAddress,
                              style: Theme.of(context).textTheme.headline3,
                              decoration: InputDecoration(
                                labelText: 'Email',
                              ),
                              validator: validateEmail,
                              onSaved: (email) {
                                _email = email;
                              },
                            ),
                            TextFormField(
                              key: _passwordKey,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              style: Theme.of(context).textTheme.headline3,
                              decoration: InputDecoration(
                                labelText: 'Password',
                              ),
                              validator: validatePassword,
                              onChanged: (password) {
                                _password = password;
                              },
                            ),
                            if (!isLogin)
                              TextFormField(
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                style: Theme.of(context).textTheme.headline3,
                                decoration: InputDecoration(
                                  labelText: 'Confirm Password',
                                ),
                                validator: (confirmPassword) {
                                  if (confirmPassword != _password)
                                    return "Passwords don't match.";
                                  return null;
                                },
                              ),
                          ]
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 0.060 * sh),
                  Selector<Auth, bool>(
                    selector: (_, auth) => auth.isLoading,
                    builder: (_, isLoading, __) => Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Container(
                          height: 52,
                          width: double.maxFinite,
                          child: FlatButton(
                            color: Theme.of(context).primaryColor,
                            shape: StadiumBorder(),
                            child: Text(
                              isLogin ? 'LOGIN' : 'SIGNUP',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  .apply(color: Colors.white),
                            ),
                            disabledColor: Colors.grey,
                            onPressed: isLoading
                                ? null
                                : () async {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();

                                      _staticAuthProvider.isLoading = true;

                                      try {
                                        if (isLogin) {
                                          await _staticAuthProvider.login(
                                              _email, _password, null);

                                          /* Navigator.of(context)
                                              .pushReplacementNamed(
                                                  HomeScreen.routeName); */
                                        } else {
                                          await _staticAuthProvider.signup(
                                              _email, _password, _name);

                                          /* Navigator.of(context)
                                              .pushReplacementNamed(
                                                  WalkthroughScreen.routeName); */
                                        }
                                      } on HttpException catch (error) {
                                        var errorMessage =
                                            'Authentication failed';
                                        if (error
                                            .toString()
                                            .contains('EMAIL_EXISTS')) {
                                          errorMessage =
                                              'This email address is already in use.';
                                        } else if (error
                                            .toString()
                                            .contains('INVALID_EMAIL')) {
                                          errorMessage =
                                              'This is not a valid email address';
                                        } else if (error
                                            .toString()
                                            .contains('WEAK_PASSWORD')) {
                                          errorMessage =
                                              'This password is too weak.';
                                        } else if (error
                                            .toString()
                                            .contains('EMAIL_NOT_FOUND')) {
                                          errorMessage =
                                              'Could not find a user with that email.';
                                        } else if (error
                                            .toString()
                                            .contains('INVALID_PASSWORD')) {
                                          errorMessage = 'Invalid password.';
                                        } else {
                                          errorMessage = error.toString();
                                        }
                                        _showErrorDialog(errorMessage);
                                      } catch (error) {
                                        var errorMessage =
                                            'Could not ${isLogin ? 'log you in' : 'sign you up'}. Please try again later.';
                                        _showErrorDialog(errorMessage);
                                      }

                                      _staticAuthProvider.isLoading = false;
                                    }
                                  },
                          ),
                        ),
                        if (isLoading) CircularProgressIndicator(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthScreenBackground extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double sw = size.width;
    double sh = size.height;
    Paint paint = Paint();

    Path firstWave = Path();

    firstWave.lineTo(0, 0.406 * sh);
    firstWave.quadraticBezierTo(0.081 * sw, 0.475 * sh, 0.508 * sw, 0.490 * sh);
    firstWave.quadraticBezierTo(0.912 * sw, 0.500 * sh, 1.000 * sw, 0.558 * sh);
    firstWave.lineTo(sw, 0);
    firstWave.close();

    paint.color = Colors.blueAccent;
    canvas.drawPath(firstWave, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
