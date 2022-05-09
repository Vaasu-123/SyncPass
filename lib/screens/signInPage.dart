import 'package:flutter/material.dart';
import 'package:passwordmanager/resources/auth.dart';
import 'package:passwordmanager/screens/homePage.dart';
import 'package:passwordmanager/utils/colors.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          //gradient: mobileBackgroundColor,
          image: DecorationImage(
            image: AssetImage(
              "assets/images/BG.jpg",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                flex: 1,
                child: Container(),
              ),
              GlassmorphicContainer(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.8,
                borderRadius: MediaQuery.of(context).size.height * 0.02,
                blur: 15,
                alignment: Alignment.center,
                border: 2,
                linearGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFFFFF).withAlpha(0),
                    Color(0xFFFFFFF).withAlpha(0),
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
                child: Column(
                  children: [
                    Flexible(
                      child: Container(),
                      flex: 1,
                    ),
                    Image.asset(
                      "assets/images/Logoo.png",
                      height: 200,
                      //repeat: ImageRepeat.repeat,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sync",
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w900,
                            fontSize: 40,
                          ),
                        ),
                        const Text(
                          "Pass",
                          style: TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.w900,
                            fontSize: 40,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 75,
                    ),
                    Center(
                      child: TextButton(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 25,
                          ),
                          //color: Colors.white,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/googleLogo.png',
                                height: 25,
                              ),
                              const Text(
                                "Sign in with Google",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onPressed: () {
                          final provider = Provider.of<GoogleSignInProvider>(
                            context,
                            listen: false,
                          );
                          provider.googleLogin();
                          // provider.user.email != null ? Navigator.of(context).push(HomePage()) :
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: const [
                        Text(
                          "Save all your passwords",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "In one place",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      child: Container(),
                      flex: 1,
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
