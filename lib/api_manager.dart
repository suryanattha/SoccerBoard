import 'dart:convert';
import 'package:http/http.dart';
import 'soccermodel.dart';
import 'package:flutter/services.dart' show rootBundle;


class SoccerApi {
  // Daftar ID liga utama
  static const Map<String, int> leagues = {
    'Premier League': 39, // Inggris
    'La Liga': 140, // Spanyol
    'Serie A': 135, // Italia
    'Bundesliga': 78, // Jerman
    'Ligue 1': 61, // Prancis
    'Eredivisie': 88, // Belanda
    'Primeira Liga': 94, // Portugal
  };

  static const headers = {
    'x-rapidapi-host': "v3.football.api-sports.io",
    'x-rapidapi-key': "91b309c6e6e5335cbeac9b906414711a"
  };

  // Method untuk mengambil pertandingan dari satu liga
  Future<List<SoccerMatch>> getMatchesByLeague(int leagueId) async {

      String dataliga = await rootBundle.loadString('liga/$leagueId.json');

      var body = jsonDecode(dataliga);
      List<dynamic> matchesList = body['response'];
      print(
          "Api service for league $leagueId: ${matchesList.length} matches"); // Debugging

      List<SoccerMatch> matches = matchesList
          .map((dynamic item) => SoccerMatch.fromJson(item))
          .toList();

      return matches;

  }

  // Method untuk mengambil semua pertandingan dari semua liga
  Future<Map<String, List<SoccerMatch>>> getAllLeaguesMatches() async {
    Map<String, List<SoccerMatch>> allMatches = {};

    for (var entry in leagues.entries) {
      try {
        List<SoccerMatch> leagueMatches = await getMatchesByLeague(entry.value);
        allMatches[entry.key] = leagueMatches;
      } catch (e) {
        print("Error fetching matches for ${entry.key}: $e");
        allMatches[entry.key] = []; // Empty list in case of error
      }
    }

    return allMatches;
  }

  // Method untuk mengambil detail pertandingan berdasarkan fixtureId
  Future<List<FixtureStatistics>> getFixtureStatistics(
      int fixtureId, int teamId) async {
    final String apiUrl =
        "https://v3.football.api-sports.io/fixtures/statistics?fixture=$fixtureId&team=$teamId";

    Response res = await get(Uri.parse(apiUrl), headers: headers);

    if (res.statusCode == 200) {
      var body = jsonDecode(res.body);
      List<dynamic> statsList = body['response'];
      print("Fixture Statistics: $body");

      List<FixtureStatistics> stats = statsList
          .map((dynamic item) => FixtureStatistics.fromJson(item))
          .toList();

      return stats;
    } else {
      throw Exception("Failed to load fixture statistics");
    }
  }
}
