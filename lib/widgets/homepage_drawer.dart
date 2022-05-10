import 'package:flutter/material.dart';
import 'package:passwordmanager/utils/colors.dart';
import '../resources/firestore_methods.dart';

class HomePageDrawer extends StatelessWidget {
  HomePageDrawer({Key? key}) : super(key: key);
  final firestoremethods = FireStoreMethods();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: blueColor,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Container(),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 15,
                  offset: Offset(3, 8), // changes position of shadow
                ),
              ],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(100),
              ),
              color: const Color.fromRGBO(213, 0, 45, 1),
              image: const DecorationImage(
                image: AssetImage(
                  "assets/images/sideProfile.jpeg",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black, width: 1),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        spreadRadius: 0,
                        blurRadius: 0,
                        offset: Offset(3, 6),
                      )
                    ],
                  ),
                  child: TextButton(
                    onPressed: () {
                      firestoremethods.loadFromOnlinetoOffline();
                    },
                    child: const Text(
                      "Upload Passwords \nFrom Online To Offline",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Ubuntu',
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black, width: 1),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        spreadRadius: 0,
                        blurRadius: 0,
                        offset: Offset(3, 6),
                      )
                    ],
                  ),
                  child: TextButton(
                    onPressed: () {
                      firestoremethods.loadFromOnlinetoOffline();
                    },
                    child: const Text(
                      "Upload Passwords \nFrom Offline To Online",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Ubuntu',
                      ),
                    ),
                  ),
                ),
                const Text(
                      "Made by Vaasu Garg",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Ubuntu',
                      ),
                    ),
                // Flexible(
                //   flex: 3,
                //   child: Container(),
                // ),
                // Expanded(
                //   child: Container(),
                // ),
                // Row(
                //   // mainAxisSize: MainAxisSize.max,
                //   // crossAxisAlignment: CrossAxisAlignment.center,
                //   children: const [
                    
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
