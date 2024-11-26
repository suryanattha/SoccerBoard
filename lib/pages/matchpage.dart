import 'package:flutter/material.dart';
import '/api_manager.dart';
import '/matchtile.dart';
import '/soccermodel.dart';
import 'matchdetail.dart';

class MatchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0.0,
        title: const Text(
          "SoccerBoard",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, List<SoccerMatch>>>(
        future: SoccerApi().getAllLeaguesMatches(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data != null) {
            // Flatten all matches into a single list
            List<SoccerMatch> allMatches = [];
            snapshot.data!.forEach((league, matches) {
              allMatches.addAll(matches);
            });

            return ListView.builder(
              itemCount: allMatches.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MatchDetailPage(
                          fixtureId: allMatches[index].fixture.id,
                        ),
                      ),
                    );
                  },
                  child: matchtile(allMatches[index]),
                );
              },
            );
          } else {
            return const Center(child: Text("No matches found"));
          }
        },
      ),
    );
  }
}
