import 'package:flutter/material.dart';
import 'package:open_media_server_app/gallery.dart';
import 'package:open_media_server_app/player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenMediaStation Movie and Shows',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _openPlayer() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const PlayerView()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Gallery(),
      floatingActionButton: FloatingActionButton(
        onPressed: _openPlayer,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
