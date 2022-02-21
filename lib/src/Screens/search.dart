import 'package:chat_box/src/Screens/chat_screen.dart';
import 'package:chat_box/src/components/myButton.dart';
import 'package:chat_box/src/helper/constants.dart';
import 'package:chat_box/src/helper/helper_functions.dart';
import 'package:chat_box/src/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  HelperFunctions _helperFunctions = HelperFunctions();
  TextEditingController _search = TextEditingController();
  QuerySnapshot? snapshot;

  bool isUserLoggedIn = false;

  Future initiateSearch() async {
    if (_search.value.text.isNotEmpty) {
      databaseMethods.searchByName(_search.value.text).then((snapShot) {
        setState(() {
          snapshot = snapShot;
        });
      });
    }
  }

  Widget searchList() {
    return snapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot!.docs.length,
            itemBuilder: (context, index) {
              return searchTile(
                name: snapshot!.docs[index].get('name'),
                email: snapshot!.docs[index].get('email'),
              );
            })
        : Container();
  }

  getUserInfo() async {
    Constants.myName = (await _helperFunctions.getNameInSharedPreference())!;
    setState(() {});
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      controller: _search,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search for a name",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    child: IconButton(
                      icon: Icon(Icons.search),
                      color: Colors.black87,
                      onPressed: () {
                        initiateSearch();
                      },
                    ),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(14, 246, 204, 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 2,
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
              child: Divider(
                color: Color.fromRGBO(14, 246, 204, 1),
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }

  // 1.create a chatroom, send user to the chatroom, other userdetails
  sendMessage({String? name}) {
    List<String> users = [Constants.myName, name!];
    String chatRoomId = getChatRoomId(Constants.myName, name);

    debugPrint(
        '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${Constants.myName}>>>>>>>>>>>>>>$name');

    if (name != Constants.myName) {
      Map<String, dynamic> chatRoom = {
        "users": users,
        "chatRoomId": chatRoomId,
      };
      databaseMethods.addChatRoom(chatRoom, chatRoomId);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatScreen(
                    chatRoomId: chatRoomId,
                  )));
    } else {
      Container();
    }
  }

  Widget searchTile({String? name, String? email}) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name!,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(14, 246, 204, 1),
                ),
              ),
              Text(
                email!,
                style: TextStyle(fontSize: 11),
              ),
            ],
          ),
          MyButton(
            buttonName: "Message",
            onPressed: () {
              sendMessage(name: name);
            },
          )
        ],
      ),
    );
  }

//to get the chatroom id of the users
  String getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
}
