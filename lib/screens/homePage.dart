import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:passwordmanager/resources/auth.dart';
import 'package:passwordmanager/resources/firestore_methods.dart';
// import 'package:passwordmanager/resources/firestore_methods.dart';
import 'package:passwordmanager/utils/colors.dart';
import 'package:passwordmanager/widgets/alert_dialog_box.dart';
import 'package:passwordmanager/widgets/centerTitle.dart';
import 'package:passwordmanager/widgets/homepage_drawer.dart';
import 'package:provider/provider.dart';
// import 'package:is_first_run/is_first_run.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  static bool _firstRun = true;
  void initialRun() async {
    if (_firstRun) {
      FireStoreMethods fireStoreMethods = FireStoreMethods();

      fireStoreMethods.loadFromOfflinetoOnline(firstTime: true);
      internetCheck();
    }
    _firstRun = false;
  }

  bool internetAvailable = false;

  Future internetCheck() async {
    internetAvailable = await InternetConnectionChecker().hasConnection;
    if (!internetAvailable) {
      CustomAlertDialogBox alertDialogBox = CustomAlertDialogBox();
      alertDialogBox.dialogBox(
          textToDisplay: "Please connect to the Internet!");
    }
  }
  // void automaticData() async {
  //   bool firstCall = await IsFirstRun.isFirstCall();
  //   if (firstCall) {
  //     FireStoreMethods fireStoreMethods = FireStoreMethods();
  //     await fireStoreMethods.loadFromOnlinetoOffline();
  //   }
  // }

  // void newUser() {
  //   FireStoreMethods fireStoreMethods = FireStoreMethods();
  //   fireStoreMethods.loadFromOnlinetoOffline();
  // }

  @override
  Widget build(BuildContext context) {
    // automaticData();
    // newUser();
    initialRun();
    print("App was rebuilt");
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: HomePageDrawer(),
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
