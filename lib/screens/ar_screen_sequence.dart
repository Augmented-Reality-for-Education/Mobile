import 'dart:convert';

import 'package:ar_for_education/classes/ar_sequence.dart';
import 'package:ar_for_education/globals.dart';
import 'package:flutter/material.dart';
import 'package:ar_for_education/classes/ar_image.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:http/http.dart' as http;

class ArScreenSequence extends StatefulWidget {
  const ArScreenSequence({Key? key}) : super(key: key);

  @override
  _ArScreenSequenceState createState() => _ArScreenSequenceState();
}

class _ArScreenSequenceState extends State<ArScreenSequence> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  late UnityWidgetController _unityWidgetController;
  late ArImage _currentImage;
  late int _currentImageIndex = 0;
  late bool _ready = false;
  ArSequence? _sequence;
  bool _vertical = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _unityWidgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_sequence == null) {
      setState(() {
        _sequence = ModalRoute.of(context)!.settings.arguments as ArSequence;
      });
    }

    if (_sequence?.id != null && _sequence?.images?[0].dataUrl == null) {
      fetchSequenceFromId(_sequence?.id).then((value) {
        setState(() {
          _sequence = value;
          _currentImage = value.images![0];
          _ready = true;
        });
      });
    }

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(_sequence?.name ?? 'AR Demonstration'),
        ),
        body: Stack(
          children: <Widget>[
            UnityWidget(
              onUnityCreated: _onUnityCreated,
              onUnityMessage: onUnityMessage,
              fullscreen: false,
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: _ready
                        ? [
                            Slider(
                              max: _sequence!.images!.length.toDouble() - 1,
                              divisions: _sequence!.images!.length - 1,
                              value: _currentImageIndex.toDouble(),
                              onChanged: (double value) {
                                debugPrint(value.toString());
                                setState(() {
                                  if (_sequence != null) {
                                    _currentImageIndex = value.toInt();
                                    _currentImage =
                                        _sequence!.images![value.toInt()];
                                  }
                                });
                              },
                              onChangeEnd: (value) {
                                updateSequenceTexture();
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      if (_currentImage.dataUrl != null) {
                                        placeObject();
                                      }
                                    },
                                    child: const Text('Place')),
                                ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _vertical = !_vertical;
                                      });
                                      setVertically();
                                    },
                                    child: Text('Switch to ' +
                                        (_vertical
                                            ? 'Horizontal'
                                            : 'Vertical'))),
                              ],
                            ),
                          ]
                        : [const CircularProgressIndicator()]))
          ],
        ));
  }

  void onUnityMessage(message) {
    print('Received message from unity: ${message.toString()}');
  }

  // Callback that connects the created controller to the unity controller
  void _onUnityCreated(controller) {
    controller.resume();
    _unityWidgetController = controller;
  }

  void placeObject() {
    _unityWidgetController.postMessage(
        "Interaction", "PlaceImageFromDataUrl", _currentImage.dataUrl);
  }

  void updateSequenceTexture() {
    _unityWidgetController.postMessage(
        "Interaction", "UpdateTexture", _currentImage.dataUrl);
  }

  void setVertically() {
    _unityWidgetController.postMessage(
        "Interaction", "SetVertically", _vertical ? 'Vertical' : 'Horizontal');
  }

  Future<ArSequence> fetchSequenceFromId(int? id) async {
    final response = await http.get(Uri.parse(api_url + 'Sequence/$id'));

    if (response.statusCode == 200) {
      return ArSequence.fromJson(jsonDecode(response.body));
    }

    throw Exception('Failed to load image');
  }
}
