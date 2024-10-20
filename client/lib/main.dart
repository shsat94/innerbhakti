import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'audio_player_screen.dart';
import 'program_details_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InnerBhakti',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const ProgramListScreen(),
    );
  }
}

class ProgramListScreen extends StatefulWidget {
  const ProgramListScreen({super.key});

  @override
  _ProgramListScreenState createState() => _ProgramListScreenState();
}

class _ProgramListScreenState extends State<ProgramListScreen> {
  List programs = [];

  @override
  void initState() {
    super.initState();
    fetchPrograms();
  }

  Future<void> fetchPrograms() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/programs'));
    if (response.statusCode == 200) {
      setState(() {
        programs = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load programs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Programs'),
      ),
      body: ListView.builder(
        itemCount: programs.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.network(programs[index]['image']),
            title: Text(programs[index]['name']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProgramDetailsScreen(programId: programs[index]['_id']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
