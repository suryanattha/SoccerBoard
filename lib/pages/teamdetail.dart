import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/soccermodel.dart';

class TeamDetailPage extends StatefulWidget {
  final Team team;
  final int fixtureId;

  TeamDetailPage({required this.team, required this.fixtureId});

  @override
  _TeamDetailPageState createState() => _TeamDetailPageState();
}

class _TeamDetailPageState extends State<TeamDetailPage> {
  late Future<TeamLineup> _teamLineup;

  @override
  void initState() {
    super.initState();
    _teamLineup = _fetchTeamLineup();
  }

  Future<TeamLineup> _fetchTeamLineup() async {
    final String apiUrl =
        "https://v3.football.api-sports.io/fixtures/lineups?fixture=${widget.fixtureId}&team=${widget.team.id}";

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'x-rapidapi-host': "v3.football.api-sports.io",
        'x-rapidapi-key': "91b309c6e6e5335cbeac9b906414711a",
      },
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      List<dynamic> lineupList = body['response'];

      if (lineupList.isNotEmpty) {
        return TeamLineup.fromJson(lineupList[0]);
      } else {
        throw Exception('No lineup data available');
      }
    } else {
      throw Exception('Failed to load team lineup');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.team.name} Lineup"),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<TeamLineup>(
        future: _teamLineup,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No lineup available'));
          }

          TeamLineup lineup = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                // Team Logo and Name
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Image.network(
                        widget.team.logoUrl,
                        width: 100,
                        height: 100,
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.team.name,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Coach Section
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "Coach: ${lineup.coach.name}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // Starting XI
                _buildPlayerSection("Starting XI", lineup.startXI),

                // Substitutes
                _buildPlayerSection("Substitutes", lineup.substitutes),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlayerSection(String title, List<Player> players) {
    return ExpansionTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      children: players.map((player) {
        return ListTile(
          title: Text(
            player.name,
            style: TextStyle(fontSize: 16),
          ),
          trailing: Text(
            "No. ${player.number} | ${player.pos}",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        );
      }).toList(),
    );
  }
}
