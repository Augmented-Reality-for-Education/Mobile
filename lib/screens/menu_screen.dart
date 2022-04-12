import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_unity/classes/ar_image.dart';
import 'package:http/http.dart' as http;

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<ArImage> menus = [];

  Future<List<ArImage>> fetchMenus() async {
    final response = await http
        .get(Uri.parse('https://ar-for-education-api.azurewebsites.net/Image'));

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((e) => ArImage.fromJson(e))
          .toList();
    }

    throw Exception('Failed to load images to display in menu');
  }

  @override
  void initState() {
    super.initState();
    fetchMenus().then((menus) => setState(() => this.menus = menus));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: menus.length,
          itemBuilder: (BuildContext context, int i) {
            return ListTile(
              title: Text(menus[i].name ?? 'No name'),
              onTap: () {
                Navigator.of(context).pushNamed(
                  '/ar',
                  arguments: menus[i],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
