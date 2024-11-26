import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/soccermodel.dart';

class MatchDetailPage extends StatefulWidget {
  final int fixtureId;

  MatchDetailPage({required this.fixtureId});

  @override
  _MatchDetailPageState createState() => _MatchDetailPageState();
}

class _MatchDetailPageState extends State<MatchDetailPage> {
  late Future<List<FixtureStatistics>> fixtureStatistics;

  @override
  void initState() {
    super.initState();
    fixtureStatistics = _fetchFixtureStatistics();
  }

  Future<List<FixtureStatistics>> _fetchFixtureStatistics() async {
    final String apiUrl =
        "https://v3.football.api-sports.io/fixtures/statistics?fixture=${widget.fixtureId}";

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'x-rapidapi-host': "v3.football.api-sports.io",
        'x-rapidapi-key': "91b309c6e6e5335cbeac9b906414711a",
      },
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      List<dynamic> statsList = body['response'];

      List<FixtureStatistics> stats = statsList
          .map((dynamic item) => FixtureStatistics.fromJson(item))
          .toList();

      return stats;
    } else {
      throw Exception('Failed to load fixture statistics');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Match Statistics"),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<FixtureStatistics>>(
        future: fixtureStatistics,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No statistics available'));
          } else {
            // Pisahkan statistik untuk setiap tim
            return ListView.builder(
              itemCount: snapshot.data![0].statistics.length,
              itemBuilder: (context, index) {
                // Ambil statistik untuk tim pertama dan kedua
                var statHome = snapshot.data![0].statistics[index];
                var statAway = snapshot.data![1].statistics[index];

                return Card(
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          statHome.type,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Tim Home
                            Text(
                              snapshot.data![0].team.name,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            // Statistik Tim Home
                            Text(
                              '${statHome.value ?? "N/A"}',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Tim Away
                            Text(
                              snapshot.data![1].team.name,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            // Statistik Tim Away
                            Text(
                              '${statAway.value ?? "N/A"}',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
