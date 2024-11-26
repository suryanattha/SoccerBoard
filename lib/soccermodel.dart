class SoccerMatch {
  // Data pertandingan sepak bola
  Fixture fixture;
  Team home;
  Team away;
  Goal goal;

  SoccerMatch(this.fixture, this.home, this.away, this.goal);

  // Factory method untuk membangun objek SoccerMatch dari JSON
  factory SoccerMatch.fromJson(Map<String, dynamic> json) {
    return SoccerMatch(
      Fixture.fromJson(json['fixture']),
      Team.fromJson(json['teams']['home']),
      Team.fromJson(json['teams']['away']),
      Goal.fromJson(json['goals']),
    );
  }
}

// Kelas untuk menyimpan informasi fixture (jadwal)
class Fixture {
  int id;
  String date;
  Status status;

  Fixture(this.id, this.date, this.status);

  // Factory method untuk membangun objek Fixture dari JSON
  factory Fixture.fromJson(Map<String, dynamic> json) {
    return Fixture(
      json['id'],
      json['date'] ?? '', // Default ke string kosong jika null
      Status.fromJson(json['status']),
    );
  }
}

// Kelas untuk menyimpan status pertandingan
class Status {
  int elapsedTime; // Waktu yang telah berlalu
  String long;

  Status(this.elapsedTime, this.long);

  // Factory method untuk membangun objek Status dari JSON
  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      json['elapsed'] ?? 0, // Default ke 0 jika 'elapsed' null
      json['long'] ?? '', // Default ke string kosong jika 'long' null
    );
  }
}

// Kelas untuk menyimpan data tim (home dan away)
class Team {
  int id;
  String name;
  String logoUrl;
  bool winner;

  Team(this.id, this.name, this.logoUrl, this.winner);

  // Factory method untuk membangun objek Team dari JSON
  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      json['id'],
      json['name'],
      json['logo'],
      json['winner'] ?? false, // Default ke false jika null
    );
  }
}

// Kelas untuk menyimpan data gol (home dan away)
class Goal {
  int home;
  int away;

  Goal(this.home, this.away);

  // Factory method untuk membangun objek Goal dari JSON
  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      json['home'] ?? 0, // Default ke 0 jika 'home' null
      json['away'] ?? 0, // Default ke 0 jika 'away' null
    );
  }
}

class FixtureStatistics {
  final Team team;
  final List<Statistic> statistics;

  FixtureStatistics({required this.team, required this.statistics});

  factory FixtureStatistics.fromJson(Map<String, dynamic> json) {
    print("FixtureStatistics JSON: $json");
    return FixtureStatistics(
      team: Team.fromJson(json['team']),
      statistics: (json['statistics'] as List)
          .map((stat) => Statistic.fromJson(stat))
          .toList(),
    );
  }
}

class Statistic {
  final String type;
  final dynamic value;

  Statistic({required this.type, required this.value});

  factory Statistic.fromJson(Map<String, dynamic> json) {
    return Statistic(
      type: json['type'] ?? 'Unknown',
      value: json['value'] ?? 0,
    );
  }
}

class TeamLineup {
  final Team team;
  final List<Player> startXI;
  final List<Player> substitutes;
  final Coach coach;

  TeamLineup({
    required this.team,
    required this.startXI,
    required this.substitutes,
    required this.coach,
  });

  factory TeamLineup.fromJson(Map<String, dynamic> json) {
    return TeamLineup(
      team: Team.fromJson(json['team']),
      startXI: (json['startXI'] as List)
          .map((player) => Player.fromJson(player))
          .toList(),
      substitutes: (json['substitutes'] as List)
          .map((player) => Player.fromJson(player))
          .toList(),
      coach: Coach.fromJson(json['coach']),
    );
  }
}

class Player {
  final int id;
  final String name;
  final int number;
  final String pos;
  final String? grid;

  Player({
    required this.id,
    required this.name,
    required this.number,
    required this.pos,
    this.grid,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['player']['id'],
      name: json['player']['name'],
      number: json['player']['number'],
      pos: json['player']['pos'],
      grid: json['player']['grid'],
    );
  }
}

class Coach {
  final int id;
  final String name;
  final String? photo;

  Coach({
    required this.id,
    required this.name,
    this.photo,
  });

  factory Coach.fromJson(Map<String, dynamic> json) {
    return Coach(
      id: json['id'],
      name: json['name'],
      photo: json['photo'],
    );
  }
}
