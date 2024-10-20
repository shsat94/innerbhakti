import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'audio_player_screen.dart';

class ProgramDetailsScreen extends StatefulWidget {
  final String programId;

  const ProgramDetailsScreen({super.key, required this.programId});

  @override
  _ProgramDetailsScreenState createState() => _ProgramDetailsScreenState();
}

class _ProgramDetailsScreenState extends State<ProgramDetailsScreen> {
  List tracks = [];

  @override
  void initState() {
    super.initState();
    fetchProgramDetails();
  }

  Future<void> fetchProgramDetails() async {
    final response = await http
        .get(Uri.parse('http://localhost:3000/programs/${widget.programId}'));
    if (response.statusCode == 200) {
      setState(() {
        tracks = json.decode(response.body)['tracks'];
      });
    } else {
      throw Exception('Failed to load program details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Program Details'),
      ),
      body: ListView.builder(
        itemCount: tracks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(tracks[index]['name']),
            subtitle: Text(tracks[index]['duration']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AudioPlayerScreen(trackUrl: tracks[index]['audioUrl']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
