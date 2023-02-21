import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyAPI {
  Future<List<dynamic>> fetchSomeData(String query) async {
    var apikey =
        'c5de17dd587cea9b22bd1bde4533efc3837a87c8cd01222cbededbb641e0c96f';
    Set<dynamic> uniqueTitles = {};
    List<dynamic> webData = [];

    var url = Uri.parse(
        'https://serpapi.com/search?q=$query&engine=google_events&api_key=$apikey');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['events_results'];
      webData.addAll(data);
    }

    for (var start = 0; start <= 150; start += 10) {
      var url = Uri.parse(
          'https://serpapi.com/search?q=$query&engine=google_events&api_key=$apikey&start=$start');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['events_results'];
        for (var item in data) {
          var title = item['title'];
          if (!uniqueTitles.contains(title)) {
            uniqueTitles.add(title);
            webData.add(item);
          }
        }
        /*debugPrint(jsonEncode(data));*/
      } else {
        throw Exception('Failed to fetch data from API');
      }
    }
    return webData;

  }
}

class SerpApiListScreen extends StatefulWidget {
  final String query;

  const SerpApiListScreen({required this.query, Key? key}) : super(key: key);

  @override
  SerpApiListScreenState createState() => SerpApiListScreenState();
}

class SerpApiListScreenState extends State<SerpApiListScreen> {
  List<dynamic> _data = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      List<dynamic> data = await MyAPI().fetchSomeData(widget.query);
      setState(() {
        _data = data;
      });
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.query),
      ),
      body: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (BuildContext context, int index) {
          var item = _data[index];
          String leading = item['date']['start_date'];
          String title = item['title'];
          String link = item['link'];
          String trailing = item['thumbnail'];
          return ListTile(
            leading: Text(leading),
            title: Text(title),
            subtitle: Text(link),
            trailing: Image.network(trailing),
          );
        },
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SerpApiListScreen(query: "Events in Santa Cruz"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const Center(
        child: Text(
          'events tester',
        ),
      ),
    );
  }
}
