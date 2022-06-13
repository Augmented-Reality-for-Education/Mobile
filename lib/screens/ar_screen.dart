import 'dart:convert';

import 'package:ar_for_education/globals.dart';
import 'package:flutter/material.dart';
import 'package:ar_for_education/classes/ar_image.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:http/http.dart' as http;

class ArScreen extends StatefulWidget {
  const ArScreen({Key? key}) : super(key: key);

  @override
  _ArScreenState createState() => _ArScreenState();
}

class _ArScreenState extends State<ArScreen> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  late UnityWidgetController _unityWidgetController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _unityWidgetController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var image = ModalRoute.of(context)!.settings.arguments as ArImage;
    var vertical = true;

    if (image.dataUrl == null) {
      fetchImageFromId(image.id).then((value) => image = value);
    }

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(image.name ?? 'AR Demonstration'),
        ),
        body: Stack(
          children: <Widget>[
            UnityWidget(
              onUnityCreated: _onUnityCreated,
              onUnityMessage: onUnityMessage,
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                if (image.dataUrl != null) {
                                  placeObjectFromDataUrl(image.dataUrl!);
                                }
                              },
                              child: const Text('Place')),
                          ElevatedButton(
                              onPressed: () {
                                vertical = !vertical;
                                setVertically(vertical);
                              },
                              child: Text('Switch to ' +
                                  (vertical ? 'Horizontal' : 'Vertical'))),
                        ],
                      ),
                    ]))
          ],
        ));
  }

  void onUnityMessage(message) {
    print('Received message from unity: ${message.toString()}');
  }

  // Callback that connects the created controller to the unity controller
  void _onUnityCreated(controller) {
    _unityWidgetController = controller;
  }

  void placeObjectFromDataUrl(String dataUrl) {
    _unityWidgetController.postMessage(
        "Interaction", "PlaceImageFromDataUrl", dataUrl);
  }

  void setVertically(bool vertical) {
    _unityWidgetController.postMessage(
        "Interaction", "SetVertically", vertical ? 'Vertical' : 'Horizontal');
  }

  Future<ArImage> fetchImageFromId(int id) async {
    final response = await http.get(Uri.parse(api_url + 'Image/$id'));

    if (response.statusCode == 200) {
      return ArImage.fromJson(jsonDecode(response.body));
    }

    throw Exception('Failed to load image');
  }
}
