import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:js_util';
import 'package:consumer_application/wallet.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/src/media_type.dart';
import 'package:logger/logger.dart';

import 'package:xrpl/xrpl.dart';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: TakePictureScreen(
        // Pass the appropriate camera to the TakePictureScreen widget.
        camera: firstCamera,
      ),
    ),
  );
}

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  XRPLWallet? _wallet;
  String? _endPoint;
  Client client = Client('wss://s.altnet.rippletest.net:51233');
  ValueNotifier<String?> balance = ValueNotifier(null);
  String? mnemonic;
  final TextEditingController _mnemonicController = TextEditingController();
  final TextEditingController _endpointController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
        // Get a specific camera from the list of available cameras.
        widget.camera,
        // Define the resolution to use.
        ResolutionPreset.medium,
        imageFormatGroup: ImageFormatGroup.jpeg);

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Take a picture')),
        // You must wait until the controller is initialized before displaying the
        // camera preview. Use a FutureBuilder to display a loading spinner until the
        // controller has finished initializing.
        body: Column(children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the Future is complete, display the preview.
                return CameraPreview(_controller);
              } else {
                // Otherwise, display a loading indicator.
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          _wallet == null
              ? SelectableText('Please activate your wallet',
                  style: const TextStyle(fontSize: 25))
              : ValueListenableBuilder<String?>(
                  valueListenable: _wallet!.balance,
                  builder: (BuildContext context, String? balance, Widget? _) {
                    if (balance == null) {
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Loading wallet: ",
                                style: TextStyle(fontSize: 25)),
                            CircularProgressIndicator()
                          ]);
                    }
                    return Column(
                      children: [
                        SelectableText('Address: ${_wallet!.address}',
                            style: const TextStyle(fontSize: 25)),
                        SelectableText('Balance: $balance XRP',
                            style: const TextStyle(fontSize: 25))
                      ],
                    );
                  })
        ]),
        floatingActionButton: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
                left: 30,
                bottom: 20,
                child: FloatingActionButton(
                  heroTag: "run",
                  tooltip: "Run inference",
                  onPressed: () async {
                    if (_wallet == null) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Inactive wallet'),
                          content: const Text('Please activate your wallet'),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'))
                          ],
                        ),
                      );
                      return;
                    }
                    if (_endPoint == null) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _endPoint = _endpointController.text;
                                      });

                                      Navigator.pop(context);
                                    },
                                    child: const Text('OK'))
                              ],
                              title: const Text('Input Dhali endpoint URL'),
                              content: TextField(
                                onChanged: (value) {},
                                controller: _endpointController,
                              ),
                            );
                          });
                      return;
                    }

                    const snackBar = SnackBar(
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 5),
                      content: Text('Inference in progress. Please wait...'),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    // Take the Picture in a try / catch block. If anything goes wrong,
                    // catch the error.
                    try {
                      // Ensure that the camera is initialized.
                      await _initializeControllerFuture;

                      // Attempt to take a picture and get the file `image`
                      // where it was saved.
                      final image = await _controller.takePicture();
                      print("mime: " + image.mimeType.toString());
                      print("await image.length(): ${await image.length()}");

                      if (!mounted) return;
                      String dest =
                          "rstbSTpPcyxMsiXwkBxS9tFTrg2JsDNxWk"; // Dhali's address
                      String amount =
                          "10000000"; // The total amount escrowed in the channel
                      String authAmount =
                          "3000000"; // The amount to authorise for the claim
                      var openChannels = await _wallet!
                          .getOpenPaymentChannels(destination_address: dest);
                      if (openChannels.isEmpty) {
                        openChannels = [
                          await _wallet!.openPaymentChannel(dest, amount)
                        ];
                      }
                      Map<String, String> paymentClaim = {
                        "account": _wallet!.address,
                        "destination_account": dest,
                        "authorized_to_claim": authAmount,
                        "signature": _wallet!
                            .sendDrops(authAmount, openChannels[0].channelId),
                        "channel_id": openChannels[0].channelId
                      };
                      Map<String, String> header = {
                        "Payment-Claim":
                            const JsonEncoder().convert(paymentClaim)
                      };
                      String entryPointUrlRoot = _endPoint!;
                      var request = http.MultipartRequest(
                          "PUT", Uri.parse(entryPointUrlRoot));
                      request.headers.addAll(header);

                      var logger = Logger();
                      logger.d("Preparing file in body");
                      request.files.add(http.MultipartFile(
                          contentType: MediaType('multipart', 'form-data'),
                          "input",
                          image.openRead(),
                          await image.length(),
                          filename: "input"));

                      var finalResponse = await request.send();
                      logger.d("Status: ${finalResponse.statusCode}");
                      print(finalResponse.headers);
                      var response = await finalResponse.stream.bytesToString();

                      // If the picture was taken, display it on a new screen.
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DisplayPictureScreen(
                            // Pass the automatically generated path to
                            // the DisplayPictureScreen widget.
                            imagePath: image.path,
                            classification: response,
                            lastCost: finalResponse
                                .headers["dhali-latest-request-charge"]!,
                            totalCost: finalResponse
                                .headers["dhali-total-requests-charge"]!,
                            authorizedAmount: authAmount,
                          ),
                        ),
                      );
                    } catch (e) {
                      // If an error occurs, log the error to the console.
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Ooops!'),
                          content: const Text(
                              'An error occured. This may be due to your asset being cold started. Try again.'),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'))
                          ],
                        ),
                      );
                    }
                  },
                  child: const Icon(Icons.camera_alt),
                )),
            Positioned(
              bottom: 20,
              right: 30,
              child: FloatingActionButton(
                heroTag: "topup",
                tooltip: "Activate or top-up my wallet",
                onPressed: () async {
                  if (_wallet == null) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    mnemonic = _mnemonicController.text;
                                    if (mnemonic != null) {
                                      setState(() {
                                        _wallet = XRPLWallet(mnemonic!,
                                            testMode: true);
                                      });
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'))
                            ],
                            title: const Text(
                                'Generate wallet using BIP-39 compatible words'),
                            content: TextField(
                              onChanged: (value) {},
                              controller: _mnemonicController,
                            ),
                          );
                        });
                  }
                  if (mnemonic != null) {
                    setState(() {
                      _wallet = XRPLWallet(mnemonic!, testMode: true);
                    });
                  }
                },
                child: const Icon(
                  Icons.wallet_sharp,
                  size: 40,
                ),
              ),
            ),
// Add more floating buttons if you want
          ],
        ));
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final String classification;
  final String totalCost;
  final String lastCost;
  final String authorizedAmount;

  const DisplayPictureScreen(
      {super.key,
      required this.imagePath,
      required this.classification,
      required this.totalCost,
      required this.lastCost,
      required this.authorizedAmount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(imagePath),
          Text(classification, style: TextStyle(fontSize: 25)),
          Text("\nThis cost you $lastCost Drops",
              style: TextStyle(fontSize: 25)),
          Text("\nIn total, you have consumed $totalCost Drops",
              style: TextStyle(fontSize: 25)),
          Text("\nYour payment channel has authorized $authorizedAmount Drops",
              style: TextStyle(fontSize: 25)),
        ],
      ),
    );
  }
}
