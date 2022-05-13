import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:passwordmanager/resources/firestore_methods.dart';
import 'package:passwordmanager/resources/offlineStorage.dart';
import 'package:passwordmanager/widgets/alert_dialog_box.dart';
import 'package:passwordmanager/widgets/centerTitle.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import '../utils/colors.dart';

class PassCard extends StatefulWidget {
  final snap;
  bool isVisible;
  bool didAuthenticate;
  PassCard({
    Key? key,
    required this.snap,
    required this.isVisible,
    required this.didAuthenticate,
  }) : super(key: key);

  @override
  State<PassCard> createState() => _PassCardState();
}

class _PassCardState extends State<PassCard> {
  List<Widget> pass = [];

  final LocalAuthentication auth = LocalAuthentication();
  FireStoreMethods _fireStoreMethods = FireStoreMethods();
  PasswordDatabase pdoffline = PasswordDatabase.instance;
  CustomAlertDialogBox alertDialogBox = CustomAlertDialogBox();

  Future authenticate() async {
    try {
      widget.didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to access',
        options: const AuthenticationOptions(useErrorDialogs: true),
      );
      // ···
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future copyToClipBoard() async {
    if (!widget.didAuthenticate) {
      await authenticate();
    }
    if (widget.didAuthenticate) {
      Clipboard.setData(
        ClipboardData(
          text: widget.snap['password'],
        ),
      );
    }
  }

  Future visibilityStatus() async {
    if (!widget.didAuthenticate) {
      await authenticate();
    }
    if (widget.didAuthenticate) {
      setState(() {
        widget.isVisible = !widget.isVisible;
      });
    }
  }

  Future deletePass() async {
    if (!widget.didAuthenticate) {
      await authenticate();
    }
    if (widget.didAuthenticate) {
      await pdoffline.delete(id: widget.snap['uid']);
      await _fireStoreMethods.deletePass(passId: widget.snap['uid']);
    }
    // widget.didAuthenticate = false;
    // widget.isVisible = false;
  }

  void loadPass() {
    pass = [];
    for (int i = 0; i < 'password'.length; i++) {
      pass.add(
        Icon(
          Icons.circle,
          size: 7,
        ),
      );
    }
    // print(pass);
  }

  Future editDetails(BuildContext context) async {
    if (!widget.didAuthenticate) {
      await authenticate();
    }
    if (widget.didAuthenticate) {
      TextEditingController savedPasswordController = TextEditingController();
      TextEditingController websiteNameController = TextEditingController();
      savedPasswordController.text = widget.snap['password'];
      websiteNameController.text = widget.snap['websiteName'];

      showModalBottomSheet(
        backgroundColor: blueColor,
        isScrollControlled: true,
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
                    if (savedPasswordController.text == "" ||
                        websiteNameController.text == "") {
                          alertDialogBox.dialogBox(textToDisplay: "Values cannot be empty!");
                    } else {
                      await _fireStoreMethods.updateCredentials(
                        passId: widget.snap['uid'],
                        password: savedPasswordController.text,
                        website: websiteNameController.text,
                      );
                    }
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
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(),
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
    // print("Yha tk toh aa gya");
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
              Expanded(
                child: Text(
                  widget.snap['websiteName'],
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontFamily: 'Ubuntu',
                    fontWeight: FontWeight.w900,
                  ),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // mainAxisSize: MainAxisAlignment.spaceBetween,
            children: [
              widget.isVisible
                  ? Flexible(
                      child: Text(
                        widget.snap['password'],
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontFamily: 'Ubuntu',
                        ),
                      ),
                    )
                  : Row(
                      children: pass,
                    ),
              // Flexible(
              //   child: Container(),

              // ),
              IconButton(
                onPressed: () async {
                  await visibilityStatus();
                },
                icon: Icon(
                  widget.isVisible
                      ? Icons.visibility
                      : Icons.visibility_off_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
