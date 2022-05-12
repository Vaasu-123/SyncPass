import 'package:flutter/material.dart';

import '../resources/firestore_methods.dart';

class CustomButtons extends StatefulWidget {
  String buttonText;
  CustomButtons({Key? key, required this.buttonText}) : super(key: key);

  @override
  State<CustomButtons> createState() => _CustomButtonsState();
}

class _CustomButtonsState extends State<CustomButtons> {
  final firestoremethods = FireStoreMethods();
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 50,
      ),
      child: TextButton(
        // splashCOlor
        // style: ButtonStyle(
        //   overlayColor: ,
        // ),
        style: ButtonStyle(
          overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
        ),
        onPressed: () async {
          setState(() {
            isLoading = true;
          });
          widget.buttonText == "Upload Passwords \nFrom Offline to Online"
              ? await firestoremethods.loadFromOfflinetoOnline()
              : await firestoremethods.loadFromOnlinetoOffline();
          Navigator.of(context).pop();
        },
        child: isLoading
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  // padding: EdgeInsets.symmetric(horizontal: 40),
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(),
                ),
              )
            : Text(
                widget.buttonText,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Ubuntu',
                ),
              ),
      ),
    );
  }
}
