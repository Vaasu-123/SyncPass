import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:passwordmanager/utils/colors.dart';
import 'package:passwordmanager/widgets/passCard.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: import_of_legacy_library_into_null_safe
// import 'package:sort/sort.dart';
import '../widgets/centerTitle.dart';
import 'dart:io';

class PasswordsScreen extends StatefulWidget {
  PasswordsScreen({Key? key}) : super(key: key);

  @override
  State<PasswordsScreen> createState() => _PasswordsScreenState();
}

class _PasswordsScreenState extends State<PasswordsScreen> {
  final user = FirebaseAuth.instance.currentUser;
  bool connectivityStatus = true;

  void savePassword(BuildContext context) {
    CenterTitle obj = CenterTitle();
    obj.savePass(context);
  }

  void initState() {
    super.initState();
    internetStatus();
  }

  Future internetStatus() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          connectivityStatus = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        connectivityStatus = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () => savePassword(context),
            icon: Icon(
              Icons.add_circle_outline,
            ),
          ),
        ],
        title: RichText(
          text: const TextSpan(
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
            children: <TextSpan>[
              TextSpan(
                text: "Sync",
              ),
              TextSpan(
                text: "Pass",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: mobileBackgroundColor,
        ),
        child: SafeArea(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("passes")
                .doc(user!.uid)
                .collection("passwords")
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                print(snapshot.data!.docs.length);
                final snapss = snapshot.data!.docs;

                snapss.sort((m1, m2) {
                  var r = m1["websiteName"].compareTo(m2["websiteName"]);
                  if (r != 0) return r;
                  return m1["password"].compareTo(m2["password"]);
                });

                // snapss.simpleSort();
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: ((context, index) {
                    return Container(
                      child: PassCard(
                        snap: snapss[index].data(),
                      ),
                    );
                  }),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}
