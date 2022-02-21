import 'package:chat_box/src/Screens/chat_screen.dart';
import 'package:chat_box/src/Screens/login.dart';
import 'package:chat_box/src/Screens/register.dart';
import 'package:chat_box/src/Screens/search.dart';
import 'package:chat_box/src/helper/helper_functions.dart';
import 'package:chat_box/src/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  HelperFunctions helperFunctions = HelperFunctions();
  bool? isUserLoggedIn;

  Future<bool?> getLoggedInState() async {
    await helperFunctions.getUserLoggedInSharedPreference().then((state) {
      setState(() {
        isUserLoggedIn = state;
      });
    });
  }

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);

          return MaterialApp(
            title: "Chat Box",
            themeMode: themeProvider.themeMode,
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
            initialRoute: isUserLoggedIn == null
                ? isUserLoggedIn == true
                    ? '/search'
                    : '/'
                : '/',
            routes: {
              '/': (context) => const Login(),
              '/register': (context) => Register(),
              '/chat_screen': (context) => ChatScreen(),
              '/search': (context) => Search(),
            },
          );
        },
      );
}
