import 'package:chat_box/src/components/formInput.dart';
import 'package:chat_box/src/components/myButton.dart';
import 'package:chat_box/src/helper/helper_functions.dart';
import 'package:chat_box/src/services/auth_service.dart';
import 'package:chat_box/src/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register>
    with SingleTickerProviderStateMixin {
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  AuthService _auth = AuthService();
  DatabaseMethods databaseMethods = DatabaseMethods();
  HelperFunctions helperFunctions = HelperFunctions();

  AnimationController? controller;
  Animation<double>? animation;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    animation = CurvedAnimation(parent: controller!, curve: Curves.decelerate);

    controller?.forward();
    controller?.addListener(() {
      setState(() {});
      // print('${controller?.value.toInt()}');
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.only(top: 90),
                child: SvgPicture.asset('images/register.svg'),
                width: (animation?.value)! * 200,
                height: (animation?.value)! * 200,
              ),
              Padding(
                padding: EdgeInsets.all(40),
                child: Column(
                  children: [
                    FormDesignInput(
                      hintText: "Name",
                      field: TextInputType.name,
                      icon: Icon(Icons.person),
                      fieldController: _name,
                    ),
                    SizedBox(
                      height: 30,
                    ),
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
                      field: TextInputType.visiblePassword,
                      icon: Icon(Icons.lock),
                      fieldController: _password,
                      obsecureText: true,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    MyButton(
                      buttonName: "Register",
                      onPressed: () async {
                        await _auth
                            .registerUsingEmailAndPassword(
                                _email.value.text, _password.value.text)
                            .then((newUser) {
                          if (newUser != null) {
                            Map<String, dynamic> userDataMap = {
                              "name": _name.value.text,
                              "email": _email.value.text
                            };
                            databaseMethods.addUserInfo(userDataMap);
                            helperFunctions
                                .saveUserLoggedInSharedPreference(true);
                            helperFunctions
                                .saveNameInSharedPreference(_name.value.text);
                            helperFunctions
                                .saveEmailInSharedPreference(_email.value.text);

                            Navigator.pushReplacementNamed(context, '/search');
                          }
                        });
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Already have an account?"),
                    )
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
