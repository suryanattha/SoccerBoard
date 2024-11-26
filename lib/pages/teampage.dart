import 'package:flutter/material.dart';
import '/api_manager.dart';
import '/soccermodel.dart';
import 'teamdetail.dart'; // Import halaman detail tim

class TeamPage extends StatefulWidget {
  @override
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  late Future<List<Team>> _teamsFuture;
  late Future<Map<String, List<SoccerMatch>>> _matchesFuture;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    SoccerApi api = SoccerApi();
    _matchesFuture = api.getAllLeaguesMatches();
    _teamsFuture = _fetchTeams();
  }

  Future<List<Team>> _fetchTeams() async {
    try {
      Map<String, List<SoccerMatch>> allLeagueMatches = await _matchesFuture;

      // Gunakan Map untuk menghindari duplikasi berdasarkan ID tim
      Map<int, Team> uniqueTeams = {};

      // Iterasi semua liga dan pertandingan
      allLeagueMatches.forEach((league, matches) {
        for (var match in matches) {
          uniqueTeams[match.home.id] = match.home;
          uniqueTeams[match.away.id] = match.away;
        }
      });

      // Konversi map menjadi list
      return uniqueTeams.values.toList();
    } catch (e) {
      print("Error fetching teams: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0.0,
        title: const Text(
          "Teams",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Team>>(
        future: _teamsFuture,
        builder: (context, teamSnapshot) {
          return FutureBuilder<Map<String, List<SoccerMatch>>>(
            future: _matchesFuture,
            builder: (context, matchSnapshot) {
              if (teamSnapshot.connectionState == ConnectionState.waiting ||
                  matchSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (teamSnapshot.hasError) {
                return Center(
                  child: Text("Error: ${teamSnapshot.error}"),
                );
              } else if (teamSnapshot.hasData &&
                  teamSnapshot.data!.isNotEmpty) {
                List<Team> teams = teamSnapshot.data!;

                // Flatten all matches into a single list
                List<SoccerMatch> allMatches = [];
                matchSnapshot.data!.forEach((league, matches) {
                  allMatches.addAll(matches);
                });

                // Urutkan tim berdasarkan nama
                teams.sort((a, b) => a.name.compareTo(b.name));

                return ListView.builder(
                  itemCount: teams.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Image.network(teams[index].logoUrl, width: 36.0),
                      title: Text(teams[index].name),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Cari fixture ID yang sesuai dengan tim yang dipilih
                        SoccerMatch? matchWithTeam = allMatches.firstWhere(
                          (match) =>
                              match.home.id == teams[index].id ||
                              match.away.id == teams[index].id,
                          orElse: () => allMatches[0],
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TeamDetailPage(
                              team: teams[index],
                              fixtureId: matchWithTeam.fixture.id,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text("No teams available."),
                );
              }
            },
          );
        },
      ),
    );
  }
}
