// ignore_for_file: file_names, avoid_init_to_null, empty_catches, prefer_typing_uninitialized_variables

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import '/main.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:app_museo/utils/CimelioHelper.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xffEF5347)),
                          ),
                          onPressed: () async {
                            await controller?.toggleFlash();
                            setState(() {});
                          },
                          child: FutureBuilder(
                            future: controller?.getFlashStatus(),
                            builder: (context, snapshot) {
                              if (snapshot.data == true) {
                                return const Icon(Icons.flashlight_on_rounded,
                                    size: 20);
                              } else {
                                return const Icon(Icons.flashlight_off_rounded,
                                    size: 20);
                              }
                            },
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xffEF5347)),
                            ),
                            onPressed: () async {
                              await controller?.flipCamera();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getCameraInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return const Icon(
                                      Icons.compare_arrows_rounded,
                                      size: 20);
                                } else {
                                  return const Text('Caricando..');
                                }
                              },
                            )),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      /***** luke original ****/
      /*
      _qrcode = data.code;
      String message = 'QR Code Error: '+data.code.toString();
      String code = data.code!=null ? data.code!.substring(data.code!.length-2) : ''; 
      int val = int.tryParse(code) ?? -1;
      if(val >= 0) {
        message = 'QR code item: $val';
        _item = val;
      } */
      /*********/

      var qrcode = null;
      if ((scanData.code)!.length >=
          2) // the code is in the last tro characters
        qrcode = (scanData.code) != null
            ? (scanData.code)?.substring((scanData.code)!.length - 2)
            : '';
      else
        qrcode = (scanData.code) != null ? (scanData.code) : '';
      // var qrcode = (scanData.code)?.replaceAll("jfkmuseum", "");

      var code = null;

      try {
        code = int.tryParse(qrcode!);
      } catch (ex) {}

      if (code != null) {
        var cimelio;

        print("(ScanScreen) cimeli.length: " + cimeli.length.toString());
        cimelio = CimelioHelper.getScannedCimelio(code);
        // for (int i = 0; i < cimeli.length; i++) {
        //   if (cimeli[i].id == code) {
        //     cimelio = cimeli[i];
        //   }
        // }
        if (cimelio != null) {
          Navigator.of(context).pushReplacementNamed("/result", arguments: {
            "cimelio": cimelio,
          });
          dispose();
        } else {
          final String? message = ((scanData.code)?.toString() ?? " ") +
              " code: " +
              code.toString();
          final snackbar = SnackBar(
            duration: Duration(seconds: 3),
            content: Text(message ?? ''),
            action: SnackBarAction(
              label: 'ok',
              onPressed: () =>
                  ScaffoldMessenger.of(context).hideCurrentSnackBar(),
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackbar);
          dispose();
          Navigator.of(context).pop();
        }
      }
    });
    if (Platform.isAndroid) {
      // fix black camera screen bug - Luke (10/10/2022)
      controller.pauseCamera();
      controller.resumeCamera();
    }
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    try {
      super.dispose();
    } catch (ex) {}
  }
}
