import 'dart:io';

import 'package:domofit/Managers/connexions_manager.dart';
import 'package:domofit/Models/connexion.dart';
import 'package:domofit/Tools/Animations/fade_in_animation.dart';
import 'package:domofit/Widgets/ListEntries/connexion_list_entry.dart';
import 'package:domofit/Widgets/home_page_header_widget.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:domofit/main.dart';
import 'package:domofit/Tools/Animations/height_animation.dart';
import 'package:domofit/Tools/sd_colors.dart';
import 'package:flutter/material.dart';

import 'main_route.dart';

class DiscoveryRoute extends StatefulWidget {
  final MyApp myApp;
  final bool start;

  const DiscoveryRoute({
    Key? key,
    required this.myApp,
    this.start = true
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DiscoveryRouteState();
  }
}

class _DiscoveryRouteState extends State<DiscoveryRoute> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  late double delay = 3.5;
  late List<Connexion> connexions = <Connexion>[];

  late bool scanQRCode = false;
  late Barcode result;

  QRViewController? controller;

  @override
  initState() {
    _getLastConnexions();

    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();

    super.dispose();
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();

    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  void _getLastConnexions() async {
    List<Connexion> connexions = await ConnexionsManager.instance.getAllConnexions();

    setState(() {
      this.connexions = connexions;
    });
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;

        RegExp exp = RegExp(r"\?ip=([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})");
        RegExpMatch? matche = exp.firstMatch(result.code);

        if (matche != null) {
          setState(() {
            scanQRCode = false;
          });

          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) => MainRoute(myApp: widget.myApp, ipAddress: matche.group(1)),
              transitionDuration: const Duration(seconds: 0),
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    var scanArea = (screenWidth < 400 || screenHeight < 400) ? 200.0 : 400.0;

    return WillPopScope(
      onWillPop: () async {
        widget.myApp.showExitDialog(context);
        return true;
      },
      child: Scaffold(
        backgroundColor: SdColors.white,
        body: Stack(
          children: [
            Material(
              color: Colors.lightBlue,
              elevation: 2.0,
              child: Padding(
                padding: const EdgeInsets.only(top: 90),
                child: HeightAnimation(
                  delay: 0,
                  from: 109.5,
                  to: screenHeight / 2.5 - 90,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.lightBlue, Colors.lightBlueAccent],
                    ),
                  ),
                ),
              ),
            ),
            HomePageHeaderWidget(screenHeight: screenHeight, screenWidth: screenWidth, scanQRCode: scanQRCode),
            SizedBox(
              height: 100,
              child: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                title: const Text('My DomoFit'),
                actions: <Widget>[
                  FloatingActionButton(
                    heroTag: "qrCodeReader",
                    backgroundColor: Colors.white,
                    splashColor: Colors.lightBlue,
                    elevation: 0,
                    mini: true,
                    child: Icon(
                      scanQRCode ? Icons.close : Icons.qr_code,
                      color: Colors.lightBlue,
                    ),
                    onPressed: () {
                      setState(() {
                        delay = 0;
                        scanQRCode = !scanQRCode;
                      });
                    },
                  ),
                ],
              ),
            ),
            scanQRCode
                ? Padding(
                    padding: EdgeInsets.only(top: screenHeight / 2.5 - 60, bottom: 60, left: 15, right: 15),
                    child: FadeInAnimation(
                      delay: 0,
                      child: Card(
                        elevation: 5.0,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                          child: Stack(
                            children: [
                              QRView(
                                key: qrKey,
                                onQRViewCreated: _onQRViewCreated,
                                overlay: QrScannerOverlayShape(
                                    borderColor: Colors.white,
                                    borderRadius: 10,
                                    borderLength: 30,
                                    borderWidth: 10,
                                    cutOutSize: scanArea),
                              ),
                              const Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 25.0),
                                  child: Card(
                                    elevation: 0,
                                    color: Colors.black54,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Placez le QR Code dans le cadre",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(top: screenHeight / 2.5 - 70, bottom: 50),
                    child: ListView.separated(
                      itemCount: connexions.length,
                      padding: const EdgeInsets.all(15.0),
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(height: 8.0);
                      },
                      itemBuilder: (BuildContext context, index) {
                        return ConnexionListEntry(
                            delay: delay + index,
                            connexion: connexions[index],
                            myApp: widget.myApp
                        );
                      },
                    ),
                  ),
            Align(
              alignment: Alignment.bottomCenter,
              child: MaterialButton(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(0.0)),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minWidth: double.infinity,
                height: 50,
                color: Colors.lightBlue,
                splashColor: Colors.white,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) => MainRoute(myApp: widget.myApp),
                      transitionDuration: const Duration(seconds: 0),
                    ),
                  );
                },
                child: const Text(
                  "Continuer sans se connecter à un appareil",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
