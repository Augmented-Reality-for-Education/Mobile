import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class DemoScreen extends StatefulWidget {
  const DemoScreen({Key? key}) : super(key: key);

  @override
  _DemoScreenState createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
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
                        onPressed: () => placeObject(mariusUrl),
                        child: const Text('Place Marius'),
                      ),
                      ElevatedButton(
                        onPressed: () => placeObject(oveUrl),
                        child: const Text('Place Ove'),
                      )
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
    // _unityWidgetController.postMessage(gameObject, methodName, message)
  }

  static const String mariusUrl =
      'https://ca.slack-edge.com/T0JL2AS8Y-U013PJA4BU6-4efbd2c46d72-512';

  static const String oveUrl =
      'https://ca.slack-edge.com/T0JL2AS8Y-U02B96G9EF2-16219205fe96-512';

  void placeObject(String imageUrl) {
    _unityWidgetController.postMessage("Interaction", "PlaceImageFromUrl", imageUrl);
  }
}
