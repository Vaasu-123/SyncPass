import 'package:flutter/material.dart';
import 'package:passwordmanager/resources/firestore_methods.dart';
import 'package:passwordmanager/widgets/centerTitle.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import '../utils/colors.dart';

class PassCard extends StatefulWidget {
  final snap;
  PassCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PassCard> createState() => _PassCardState();
}

class _PassCardState extends State<PassCard> {
  List<Widget> pass = [];
  bool isVisible = false;
  bool didAuthenticate = false;
  final LocalAuthentication auth = LocalAuthentication();
  FireStoreMethods _fireStoreMethods = FireStoreMethods();

  Future authenticate() async {
    try {
      didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to show account balance',
        options: const AuthenticationOptions(useErrorDialogs: true),
      );
      // ···
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future copyToClipBoard() async {
    if (!didAuthenticate) {
      await authenticate();
    }
    if (didAuthenticate) {
      Clipboard.setData(
        ClipboardData(
          text: widget.snap['password'],
        ),
      );
    }
  }

  Future visibilityStatus() async {
    if (!didAuthenticate) {
      await authenticate();
    }
    if (didAuthenticate) {
      setState(() {
        isVisible = !isVisible;
      });
    }
  }

  Future deletePass() async {
    if (!didAuthenticate) {
      await authenticate();
    }
    if (didAuthenticate) {
      _fireStoreMethods.deletePass(passId: widget.snap['uid']);
    }
  }

  void loadPass() {
    pass = [];
    for (int i = 0; i < widget.snap['password'].toString().length; i++) {
      pass.add(
        Icon(
          Icons.circle,
          size: 7,
        ),
      );
    }
  }

  Future editDetails(BuildContext context) async {
    if (!didAuthenticate) {
      await authenticate();
    }
    if (didAuthenticate) {
      TextEditingController savedPasswordController = TextEditingController();
      TextEditingController websiteNameController = TextEditingController();
      savedPasswordController.text = widget.snap['password'];
      websiteNameController.text = widget.snap['websiteName'];

      showModalBottomSheet(
        backgroundColor: blueColor,
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    "Your Password",
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    controller: savedPasswordController,
                    decoration: InputDecoration(
                      hintText: "Password@123",
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
                      border: InputBorder.none,
                      fillColor: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    "Website",
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  //margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    controller: websiteNameController,
                    decoration: InputDecoration(
                      hintText: "Amazon",
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
                      border: InputBorder.none,
                      fillColor: Colors.black,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    // await fireStoreMethods.addPassword(
                    //   password: savedPasswordController.text,
                    //   website: websiteNameController.text,
                    //   uid: user!.uid,
                    // );
                    await _fireStoreMethods.updateCredentials(
                      passId: widget.snap['uid'],
                      password: savedPasswordController.text,
                      website: websiteNameController.text,
                    );
                    // savedPasswordController.clear();
                    // websiteNameController.clear();
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    children: [
                      Flexible(
                        child: Container(),
                        flex: 1,
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: Text(
                          "Save Password",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(),
                        flex: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Yha tk toh aa gya");
    loadPass();
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: 1),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 0,
            blurRadius: 0,
            offset: Offset(3, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                widget.snap['websiteName'],
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.w900,
                ),
              ),
              Flexible(
                child: Container(),
                flex: 1,
              ),
              IconButton(
                onPressed: () async {
                  //TODO: check visibility status before copying to clipboard
                  await copyToClipBoard();
                },
                icon: Icon(Icons.copy),
              ),
              // SizedBox(
              //   width: 2,
              // ),
              IconButton(
                onPressed: () async {
                  await editDetails(context);
                  //TODO: check visibility status before editing
                },
                icon: Icon(Icons.edit),
              ),
              // SizedBox(
              //   width: 2,
              // ),
              IconButton(
                onPressed: () async {
                  //TODO: check visibility status before deleting
                  await deletePass();
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              isVisible
                  ? Text(
                      widget.snap['password'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontFamily: 'Ubuntu',
                      ),
                    )
                  : Row(
                      children: pass,
                    ),
              Flexible(
                child: Container(),
                flex: 1,
              ),
              IconButton(
                onPressed: () async {
                  await visibilityStatus();
                },
                icon: Icon(
                  isVisible ? Icons.visibility : Icons.visibility_off_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}