import 'dart:convert';

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

    if (image.dataUrl == null) {
      fetchImageFromId(image.id).then((value) => image = value);
    }

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('AR Demonstration'),
        ),
        body: Stack(
          children: <Widget>[
            UnityWidget(
              onUnityCreated: _onUnityCreated,
              onUnityMessage: onUnityMessage,
            ),
            Positioned.fill(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(children: <Widget>[
                      ElevatedButton(
                          onPressed: () => {
                                if (image.dataUrl != null)
                                  {
                                    placeObjectFromDataUrl(image.dataUrl!),
                                  }
                              },
                          child: const Text('Place'))
                    ])))
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

  void placeObject(String imageUrl) {
    _unityWidgetController.postMessage(
        "Interaction", "PlaceImageFromUrl", imageUrl);
  }

  void placeObjectFromDataUrl(String dataUrl) {
    _unityWidgetController.postMessage(
        "Interaction", "PlaceImageFromDataUrl", dataUrl);
  }

  Future<ArImage> fetchImageFromId(int id) async {
    final response = await http.get(
        Uri.parse('https://ar-for-education-api.azurewebsites.net/Image/$id'));

    if (response.statusCode == 200) {
      return ArImage.fromJson(jsonDecode(response.body));
    }

    throw Exception('Failed to load images to display in menu');
  }
}
