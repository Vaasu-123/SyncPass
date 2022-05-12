import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:passwordmanager/resources/firestore_methods.dart';

class SaveButton extends StatefulWidget {
  TextEditingController websiteNameController;
  TextEditingController? savedPasswordController = TextEditingController();
  String? pass;
  FireStoreMethods fireStoreMethods = FireStoreMethods();

  
  SaveButton({
    Key? key,
    required this.websiteNameController,
    this.savedPasswordController,
    
    this.pass,
  }) : super(key: key);

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  bool isLoading = false;
  FireStoreMethods fireStoreMethods = FireStoreMethods();
  final user = FirebaseAuth.instance.currentUser;
  void save() async {
    if (widget.savedPasswordController == null) {
      print("Generated password vala");
      await fireStoreMethods.addPassword(
        password: widget.pass,
        website: widget.websiteNameController.text,
        uid: user!.uid,
        
      );
      widget.websiteNameController.clear();
      // Navigator.of(widget.ctx).pop();
    } else {
      print("Saved password vala");
      await fireStoreMethods.addPassword(
        password: widget.savedPasswordController!.text,
        website: widget.websiteNameController.text,
        uid: user!.uid,
    
      );
      widget.savedPasswordController!.clear();
      widget.websiteNameController.clear();
      // Navigator.of(widget.ctx).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // style: ButtonStyle(
      //   overlayColor:
      //       MaterialStateColor.resolveWith((states) => Colors.transparent),
      // ),
      onTap: () {
        setState(() {
          isLoading = true;
        });
        save();
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
              color: Colors.white,
            ),
            child: isLoading
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Container(
                          // padding: EdgeInsets.symmetric(horizontal: 40),
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ],
                  )
                : Text(
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
    );
  }
}
