import 'package:domofit/Routes/device_search_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Tools/sd_colors.dart';
import 'Widgets/Popups/exit_popup.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late bool _initialUriIsHandled = false;

  bool getInitialUriIsHandled() {
    return _initialUriIsHandled;
  }

  void setInitialUriIsHandled() {
    _initialUriIsHandled = true;
  }

  void showExitDialog(BuildContext context) {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: const ExitPopup(),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return const SizedBox();
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'My DomoFit',
      theme: ThemeData(
        backgroundColor: SdColors.white,
        primaryColor: Colors.lightBlue,
        primaryIconTheme: const IconThemeData(
          color: Colors.white,
        ),
        primaryTextTheme: const TextTheme(
          headline6: TextStyle(
              color: Colors.white
          ),
          headline5: TextStyle(
              color: Colors.white
          ),
        ),
      ),
      home: DiscoveryRoute(myApp: this),
    );
  }
}
