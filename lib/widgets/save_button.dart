import 'package:flutter/material.dart';

class SaveButton extends StatefulWidget {
  SaveButton({Key? key}) : super(key: key);

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        setState(() {
          isLoading = true;
        });
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
