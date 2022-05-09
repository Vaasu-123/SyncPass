import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:passwordmanager/resources/firestore_methods.dart';
import 'package:passwordmanager/resources/passwords.dart';
import 'package:passwordmanager/utils/colors.dart';
import 'buttons.dart';

class CenterTitle extends StatelessWidget {
  CenterTitle({Key? key}) : super(key: key);
  final user = FirebaseAuth.instance.currentUser;
  TextEditingController websiteNameController = TextEditingController();
  TextEditingController savedPasswordController = TextEditingController();
  FireStoreMethods fireStoreMethods = FireStoreMethods();

  void generatePass(BuildContext context) {
    Passwords object = Passwords();
    String generated_password = object.generatePasswords();
    showModalBottomSheet(
      backgroundColor: blueColor,
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.all(10),
                child: Text(
                  "Generated Password",
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "${generated_password}",
                  style: TextStyle(
                    color: Colors.black,
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
                  await fireStoreMethods.addPassword(
                    password: generated_password,
                    website: websiteNameController.text,
                    uid: user!.uid,
                  );
                  websiteNameController.clear();
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

  void savePass(BuildContext context) {
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
                  await fireStoreMethods.addPassword(
                    password: savedPasswordController.text,
                    website: websiteNameController.text,
                    uid: user!.uid,
                  );
                  savedPasswordController.clear();
                  websiteNameController.clear();
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Flexible(
        //   flex: 1,
        //   child: Container(),
        // ),
        Flexible(
          flex: 1,
          child: Container(),
        ),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 15,
                offset: Offset(3, 8), // changes position of shadow
              ),
            ],
          ),
          child: GlassmorphicContainer(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.3,
            borderRadius: MediaQuery.of(context).size.height * 0.02,
            blur: 100,
            alignment: Alignment.center,
            border: 0.5,
            linearGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFFFF).withAlpha(50),
                Color(0xFFFFFFF).withAlpha(50),
              ],
              stops: [
                0.3,
                1,
              ],
            ),
            borderGradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.7),
                Colors.white.withOpacity(1)
              ],
            ),
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 41,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            user!.photoURL.toString(),
                          ),
                          radius: 40,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user!.displayName.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Ubuntu',
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            'All your passwords in one place',
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Ubuntu',
                              // fontWeight: FontWeight.w900,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 50,
        ),

        CustomButton(
          func: () => generatePass(context),
          text: "Generate Password",
        ),
        const SizedBox(
          height: 20,
        ),
        CustomButton(
          func: () => savePass(context),
          text: "Save Password",
        ),
        const SizedBox(
          height: 20,
        ),
        GestureDetector(
          onHorizontalDragEnd: (detailsss) {
            Navigator.of(context).pushNamed('/savedPasses');
          },
          onTap: () {},
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.keyboard_double_arrow_right_sharp,
                  color: Colors.white,
                ),
                Text(
                  "Swipe right to view saved passwords",
                  style: TextStyle(
                    fontFamily: 'Ubuntu',
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(),
        ),
      ],
    );
  }
}