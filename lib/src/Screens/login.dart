import 'package:chat_box/src/components/changeThemeButton.dart';
import 'package:chat_box/src/components/formInput.dart';
import 'package:chat_box/src/components/myButton.dart';
import 'package:chat_box/src/helper/helper_functions.dart';
import 'package:chat_box/src/provider/theme_provider.dart';
import 'package:chat_box/src/services/auth_service.dart';
import 'package:chat_box/src/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  AuthService _auth = AuthService();
  HelperFunctions helperFunctions = HelperFunctions();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  AnimationController? controller;
  Animation<double>? animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 1,
      ),
    );

    animation = CurvedAnimation(parent: controller!, curve: Curves.decelerate);
    controller?.forward();
    controller?.addListener(() {
      setState(() {});
      debugPrint(animation?.value.toString());
    });
  }

// to clean animation in  memory
  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
        ? "Dark theme"
        : "Light";

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(27, 34, 35, 1),
          shape: Border(
            bottom: BorderSide(color: Colors.teal, width: 2),
          ),
          elevation: 2,
          title: AnimatedTextKit(
            animatedTexts: [
              TyperAnimatedText('Chat Box',
                  speed: Duration(milliseconds: 100), curve: Curves.decelerate),
            ],
            repeatForever: true,
          ),
          actions: [ChangeThemeButton()],
        ),
        body: Form(
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.only(top: 90),
                child: SvgPicture.asset('images/login.svg'),
                width: (animation?.value)! * 200,
                height: (controller?.value)! * 200,
              ),
              Padding(
                padding: EdgeInsets.all(40),
                child: Column(
                  children: [
                    FormDesignInput(
                      hintText: "Email",
                      field: TextInputType.emailAddress,
                      icon: Icon(Icons.email),
                      fieldController: _email,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    FormDesignInput(
                      hintText: "Password",
                      field: TextInputType.emailAddress,
                      icon: Icon(Icons.lock),
                      fieldController: _password,
                      obsecureText: true,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    MyButton(
                      buttonName: "Sign in",
                      onPressed: () {
                        debugPrint(_email.value.text + _password.value.text);
                        _auth
                            .loginWithEmailAndPassword(
                          _email.value.text,
                          _password.value.text,
                        )
                            .then((user) async {
                          if (user != null) {
                            QuerySnapshot userInfoSnapshot =
                                await DatabaseMethods()
                                    .getUserInfo(_email.value.text);
                            helperFunctions
                                .saveUserLoggedInSharedPreference(true);
                            helperFunctions.saveNameInSharedPreference(
                                userInfoSnapshot.docs[0].get('name'));
                            helperFunctions.saveEmailInSharedPreference(
                                userInfoSnapshot.docs[0].get('email'));

                            Navigator.pushReplacementNamed(context, '/search');
                          }
                        });
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text("Create new Account"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
