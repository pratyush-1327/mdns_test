import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'data_widget.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:multicast_dns/multicast_dns.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<dynamic>? _data;
  late WebSocketChannel channel;
  String connectionStatus = 'Not Connected';

  @override
  void initState() {
    super.initState();
    // _startMdnsDiscovery();
  }

  Future<InternetAddress?> resolveMdnsName(String mdnsName) async {
    try {
      final addresses = await InternetAddress.lookup(mdnsName);
      if (addresses.isNotEmpty) {
        print(addresses.first);
        return addresses.first;
      }
    } catch (e) {
      print('Error resolving $mdnsName: $e');
    }
    return null;
  }

  Future<dynamic> fetchData(String uri) async {
    final dio = Dio();
    final response = await dio.get(uri);
    return response.data;
  }

  void connectWebSocket(String uri) {
    try {
      channel = WebSocketChannel.connect(
        Uri.parse(uri),
      );
      setState(() {
        connectionStatus = 'Connected j';
      });
    } catch (e) {
      setState(() {
        connectionStatus = 'Not Connected';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () async {
        resolveMdnsName("esp32-5a62ec.local");
      }),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => connectWebSocket("ws://esp32-5a62ec.local:80"),
              child: const Text('Connect WebSocket'),
            ),
            Text(
              'Connection Status: $connectionStatus',
              style: const TextStyle(fontSize: 20),
            ),
            FutureBuilder(
              future: _data,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return DataWidget(data: snapshot.data);
                } else {
                  return const Text('No data');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
