import 'package:flutter/material.dart';
import 'package:passwordmanager/resources/auth.dart';
import 'package:passwordmanager/utils/colors.dart';
import 'package:passwordmanager/widgets/centerTitle.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
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
        actions: [
          IconButton(
            onPressed: () {
              final provider = Provider.of<GoogleSignInProvider>(
                context,
                listen: false,
              );
              provider.logout();
            },
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: mobileBackgroundColor,
        ),
        child: SafeArea(
          child: CenterTitle(),
        ),
      ),
    );
  }
}
