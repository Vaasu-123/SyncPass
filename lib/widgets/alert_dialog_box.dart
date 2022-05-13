import 'package:flutter/material.dart';
import 'package:passwordmanager/main.dart';

class CustomAlertDialogBox {
  // const CustomAlertDialogBox({Key? key}) : super(key: key);

  Future dialogBox({required textToDisplay}) async {
    await showDialog(
        context: navigatorKey.currentContext!,
        builder: (ctx) {
          Future.delayed(Duration(milliseconds: 1500), () {
            try {
              Navigator.of(ctx).pop(true);
            } catch (e) {}
          });
          return AlertDialog(
            alignment: Alignment.bottomCenter,
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            content: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                textToDisplay,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Ubuntu',
                  fontSize: 14,
                  // fontWeight: FontWeight.w900,
                ),
              ),
            ),
          );
        });
    // await Future.delayed(const Duration(seconds: 2), () {});
    // Navigator.pop;
  }
}
