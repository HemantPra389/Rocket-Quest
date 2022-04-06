import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/providers/authProvider.dart';
import 'package:quiz_app/screens/home_screen.dart';

class AuthScreen extends StatefulWidget {
  static const routename = '/auth-screen';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  //* it should be final because it is unchangeable
  dynamic image;

  bool isImageLoaded = false;

  bool _isLoading = false;
  bool _isLogin = false;
  final GlobalKey<FormState> _key =
      GlobalKey(); //*Declaring a global key helps the form to be unique FormState defines that the key is dependent on formstate.

  void _pickedImage() async {
    /*
    *For Picking the file from any source which can be gallery or camera the syntax written below which returns us the future 
    *we just have to put the file inside the image by just creating a file of the pickedimagefile.path 
     */
    var pickedImageFile = await ImagePicker.platform
        .getImage(source: ImageSource.gallery, imageQuality: 40, maxWidth: 150);
    setState(() {
      if (pickedImageFile == null) {
        return;
      }
      image = File(pickedImageFile.path);
      isImageLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var authprovider = Provider.of<AuthProvider>(context);
    //*creating a provider helps to not call the whole context when running

    return Scaffold(
        body: Container(
      height: double.infinity,
      width: double.infinity,
      padding: EdgeInsets.only(right: 30, left: 30),
      color: Colors.grey.shade200,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                margin: _isLogin
                    ? EdgeInsets.only(top: 120, bottom: 100)
                    : EdgeInsets.only(top: 90, bottom: 10),
                child: Text(
                  _isLogin ? 'Login' : 'SignUp',
                  style: TextStyle(
                      fontSize: 39,
                      fontFamily: 'Gilroy',
                      color: Colors.grey.shade800),
                )),
            if (!_isLogin)
              InkWell(
                onTap: () {
                  _pickedImage();
                },
                child: CircleAvatar(
                  radius: 50,
                  child: !isImageLoaded
                      ? Icon(
                          Icons.camera_alt_outlined,
                          size: 50,
                          color: Colors.grey.shade700,
                        )
                      : null,
                  backgroundColor: Colors.white,
                  backgroundImage: isImageLoaded ? FileImage(image!) : null,
                ),
              ),
            Container(
              height: _isLogin ? 150 : 230,
              margin: EdgeInsets.only(top: 20),
              child: Form(
                  key: _key,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Material(
                          shadowColor: Colors.white,
                          elevation: 2,
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Enter your email',
                              hintStyle: TextStyle(fontSize: 18),
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7),
                                  borderSide: BorderSide.none),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 18),
                              fillColor: Colors.white,
                            ),
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            validator: (value) {
                              if (value!.isEmpty || !value.contains('@')) {
                                return;
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              if (_isLogin) {
                                //*Validator and saved are the important fields in every textformfield
                                //*trim helps to remove the whitespaces present in the String like last space in email. This helps the code to be bug free.
                                authprovider.userData_login['email'] =
                                    newValue!.trim();
                              } else {
                                authprovider.userData_signup['email'] =
                                    newValue!.trim();
                              }
                            },
                          ),
                        ),
                        if (!_isLogin)
                          Material(
                            shadowColor: Colors.white,
                            elevation: 2,
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Enter your username',
                                filled: true,
                                hintStyle: TextStyle(fontSize: 18),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: BorderSide.none),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 18),
                                fillColor: Colors.white,
                              ),
                              style: TextStyle(
                                fontSize: 20,
                              ),
                              validator: (value) {
                                if (value!.isEmpty ||
                                    value.characters.length < 6) {
                                  return;
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                authprovider.userData_signup['username'] =
                                    newValue!.trim();
                              },
                            ),
                          ),
                        Material(
                          shadowColor: Colors.white,
                          elevation: 2,
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Password',
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7),
                                  borderSide: BorderSide.none),
                              hintStyle: TextStyle(fontSize: 18),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 18),
                              fillColor: Colors.white,
                            ),
                            obscureText: true,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            validator: (value) {
                              if (value!.isEmpty ||
                                  value.characters.length < 6) {
                                return;
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              if (_isLogin) {
                                authprovider.userData_login['password'] =
                                    newValue!;
                              } else {
                                authprovider.userData_signup['password'] =
                                    newValue!;
                              }
                            },
                          ),
                        ),
                      ])),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              alignment: Alignment.centerRight,
              child: Text(
                'Forgot your password ?',
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Ubuntu',
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600),
              ),
            ),
            InkWell(
              onTap: () async {
                setState(() {
                  _isLoading = true;
                });
                if (!_key.currentState!.validate()) {
                  return;
                }
                _key.currentState!.save();
                if (!_isLogin) {
                  authprovider
                      .createUser(authprovider.userData_signup, context, image)
                      .then((value) {
                    _isLoading = false;
                    return Navigator.pushReplacementNamed(
                        context, HomeScreen.routename);
                  });
                } else {
                  authprovider
                      .createUser_login(authprovider.userData_login, context)
                      .then((value) {
                    _isLoading = false;
                    return Navigator.pushReplacementNamed(
                        context, HomeScreen.routename);
                  });
                }
              },
              child: Container(
                height: 60,
                width: 250,
                margin: EdgeInsets.symmetric(vertical: 20),
                alignment: Alignment.center,
                child: _isLoading
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(
                        _isLogin ? 'Login' : 'SignUp',
                        style: TextStyle(
                            fontSize: 28,
                            fontFamily: 'Gilroy',
                            color: Colors.white),
                      ),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/_box.png'))),
              ),
            ),
            Text(
              '- Or -',
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text(
                'Sign in with',
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Ubuntu',
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600),
              ),
            ),
            InkWell(
              onTap: () {
                authprovider.login_google(context).whenComplete(() =>
                    Navigator.pushReplacementNamed(
                        context, HomeScreen.routename));
              },
              child: Image.asset(
                'assets/images/googleIcon.png',
                width: 45,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isLogin
                        ? 'Don\'t have an Account?'
                        : 'Already have an Account?',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600),
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin ? 'SignUp' : 'Login',
                          style: TextStyle(
                              fontSize: 17,
                              fontFamily: 'Ubuntu',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800)))
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
