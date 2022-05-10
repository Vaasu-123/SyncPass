import 'package:flutter/material.dart';
import 'package:passwordmanager/utils/colors.dart';
import '../resources/firestore_methods.dart';

class HomePageDrawer extends StatelessWidget {
  HomePageDrawer({Key? key}) : super(key: key);
  final firestoremethods = FireStoreMethods();

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width*0.3,
      child: Drawer(
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
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                ),
                color: Color.fromRGBO(213, 0, 45, 1),
                image: DecorationImage(
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
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(5),
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
                    child: TextButton(
                      onPressed: () {
                        firestoremethods.loadFromOnlinetoOffline();
                      },
                      child: Text(
                        "From Online To Offline",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Ubuntu',
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(5),
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
                    child: TextButton(
                      onPressed: () {
                        firestoremethods.loadFromOnlinetoOffline();
                      },
                      child: Text(
                        "From Offline To Online",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Ubuntu',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
