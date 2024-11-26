import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  final String appVersion = "1.0.0";
  final String developedBy = "I Made Suryanatha";
  final String apiSource = "API-Sports Football API";

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0.0,
        title: const Text(
          "About",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture or App Icon
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blue,
                child: Icon(
                  Icons.sports_soccer,
                  size: 80,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),

              // App Name and Version
              Text(
                "SoccerBoard",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Version $appVersion",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),

              SizedBox(height: 30),

              // App Information Section
              _buildSectionTitle("About the App"),
              _buildInfoCard(
                title: "Description",
                content:
                    "SoccerBoard is your ultimate companion for football match information, score board, team statistics, and player lineups.",
              ),

              SizedBox(height: 20),

              _buildSectionTitle("App Details"),
              _buildInfoCard(
                title: "Data Source",
                content: apiSource,
                trailing: IconButton(
                  icon: Icon(Icons.open_in_new, color: Colors.blue),
                  onPressed: () => _launchURL("https://www.api-football.com/"),
                ),
              ),

              SizedBox(height: 20),

              _buildSectionTitle("Developer"),
              _buildInfoCard(
                title: "Developed By",
                content: developedBy,
              ),

              SizedBox(height: 30),

              // Contact and Social Links
              _buildSectionTitle("Contact"),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.link,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    "GitHub Profile",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("https://github.com/suryanattha"),
                  onTap: () => _launchURL("https://github.com/suryanattha"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String content,
    Widget? trailing,
  }) {
    return Card(
      elevation: 3,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(content),
        trailing: trailing,
      ),
    );
  }
}
