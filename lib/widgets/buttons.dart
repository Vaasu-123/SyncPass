import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function func;
  final text;
  const CustomButton({
    Key? key,
    required this.func,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => func(),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.all(10),
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
            ]),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Ubuntu',
              // fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
