import 'dart:convert';

import 'package:ar_for_education/classes/ar_sequence.dart';
import 'package:ar_for_education/globals.dart';
import 'package:flutter/material.dart';
import 'package:ar_for_education/classes/ar_image.dart';
import 'package:http/http.dart' as http;

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<ArImage> images = [];
  List<ArSequence> sequences = [];

  Future<List<ArImage>> fetchImages() async {
    final response = await http.get(Uri.parse(api_url + 'Image'));

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((e) => ArImage.fromJson(e))
          .toList();
    }

    throw Exception('Failed to load images');
  }

  Future<List<ArSequence>> fetchSequences() async {
    final response = await http.get(Uri.parse(api_url + 'Sequence'));

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((e) => ArSequence.fromJson(e))
          .toList();
    }

    throw Exception('Failed to load sequences');
  }

  @override
  void initState() {
    super.initState();
    fetchImages().then((images) => setState(() => this.images = images));
    fetchSequences()
        .then((sequences) => setState(() => this.sequences = sequences));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Menu'),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Images', style: TextStyle(fontSize: 20)),
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: images.length,
                itemBuilder: (BuildContext context, int i) {
                  return ListTile(
                    title: Text(images[i].name ?? 'No name'),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        '/ar',
                        arguments: images[i],
                      );
                    },
                  );
                }),
            const Divider(),
            const Text('Sequences', style: TextStyle(fontSize: 20)),
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: sequences.length,
                itemBuilder: (BuildContext context, int i) {
                  return ListTile(
                    title: Text(sequences[i].name ?? 'No name'),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        '/ar-sequence',
                        arguments: sequences[i],
                      );
                    },
                  );
                }),
          ],
        ));
  }
}
