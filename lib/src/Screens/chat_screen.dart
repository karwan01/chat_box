import 'package:chat_box/src/helper/constants.dart';
import 'package:chat_box/src/services/auth_service.dart';
import 'package:chat_box/src/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key, this.chatRoomId}) : super(key: key);

  final String? chatRoomId;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final AuthService _auth = AuthService();
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController _message = TextEditingController();
  Stream<QuerySnapshot>? chats;

//calling addChatMessages inside addMessage()
  addMessage() {
    if (_message.value.text.isNotEmpty) {
      Map<String, dynamic> mapMessage = {
        "message": _message.value.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addChatMessage(widget.chatRoomId!, mapMessage);
    }
  }

//stream builder (list of messages)
  Widget messageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: chats,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          debugPrint("<<<<<<<<<<<<<<<<<<<<<<<<${snapshot.error}");
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(
              child: CircularProgressIndicator(
            color: Colors.lightGreen,
          ));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(
            color: Colors.lightGreen,
          );
        }
        return ListView.builder(
          itemCount: snapshot.data?.docs.length,
          itemBuilder: (contex, index) {
            return messageStyle(
              message: snapshot.data?.docs[index].get('message'),
              sendByMe:
                  Constants.myName == snapshot.data?.docs[index].get('sendBy'),
            );
          },
        );
      },
    );
  }

// message style
  Widget messageStyle({required String message, required bool sendByMe}) {
    return Container(
      padding: EdgeInsets.only(
        top: 8,
        bottom: 8,
        left: sendByMe ? 15 : 24,
        right: sendByMe ? 24 : 15,
      ),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        decoration: BoxDecoration(
          color: sendByMe
              ? Color.fromRGBO(14, 246, 204, 0.5)
              : Color.fromRGBO(14, 246, 204, 0.1),
          borderRadius: sendByMe
              ? const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                  bottomLeft: Radius.circular(40),
                )
              : const BorderRadius.only(
                  topRight: Radius.circular(40),
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
        ),
        child: Text(
          message,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  @override
  void initState() {
    DatabaseMethods().getUserMessages(widget.chatRoomId!).then((val) {
      setState(() {
        chats = val;
        // _message.value.text = "";
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(27, 34, 35, 1),
          leading: null,
          actions: [
            IconButton(
              onPressed: () {
                _auth.logOut();
                Navigator.pushReplacementNamed(context, '/');
              },
              icon: Icon(Icons.logout),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 70),
                child: messageList(),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 10),
                        child: TextFormField(
                          controller: _message,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(left: 20, right: 10),
                            filled: true,
                            fillColor: Color.fromRGBO(58, 79, 80, 1),
                            hintText: "Message",
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1.0,
                                color: Color.fromRGBO(58, 79, 80, 1),
                              ),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2.0,
                                color: Color.fromRGBO(58, 79, 90, 1),
                              ),
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: IconButton(
                        // color: Color.fromRGBO(14, 246, 204, 1),
                        onPressed: () {
                          addMessage();
                        },
                        icon: Icon(Icons.send),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
