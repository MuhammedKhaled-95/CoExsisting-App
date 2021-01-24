import 'package:cloud_firestore/cloud_firestore.dart';

class SquadModelClass {
  static final String ownerId = "ownerId";
  static final String duration = "duration";
  static final String squadName = "squadName";
  static final String time = "time";
  static final String timestamp = "timestamp";
  static final String date = "date";
  static final String game = "game";
  static final String membersId = "membersId";

  SquadModelClass(
      {this.squadname,
      this.timee,
      this.timeestamp,
      this.datee,
      this.ownerID,
      this.duraton,
      this.gamel,
      this.members,
      this.squadID});

  final String ownerID;
  final String squadname;
  final String timee;
  final Timestamp timeestamp;
  final String datee;
  final String duraton;
  final GameSquad gamel;
  var members;
  final String squadID;

  Map toMap() {
    Map<String, dynamic> map = {
      ownerId: ownerID,
      duration: duraton,
      squadName: squadname,
      time: timee,
      timestamp: timeestamp,
      date: datee,
      game: gamel,
      membersId: members,
    };
    return map;
  }

  static SquadModelClass fromMap(Map map) {
    return new SquadModelClass(
        ownerID: map[ownerId],
        squadname: map[squadName],
        datee: map[date],
        timee: map[time],
        timeestamp: map[timestamp],
        gamel: map[game],
        members: map[membersId]);
  }
}

class GameSquad {
  static final String id = "id";
  static final String image = "image";
  static final String name = "name";

  final int gameId;
  final String gameImage;
  final String gameName;

  GameSquad({this.gameImage, this.gameName, this.gameId});

  Map toMap() {
    Map<String, dynamic> map = {id: gameId, image: gameImage, name: gameName};
    return map;
  }

  static GameSquad fromMap(Map map) {
    return new GameSquad(
        gameId: map[id], gameImage: map[image], gameName: map[name]);
  }
}

class Members {
  final String memberId;
  final String memberName;
  final String memberAvatr;
  final bool isOwner;
  Members({this.memberId, this.memberName, this.memberAvatr, this.isOwner});
  Map<String, dynamic> toJson() => {
        'memberId': memberId,
        'memberName': memberName,
        'memberAavatar': memberAvatr,
        'isOwner': isOwner
      };
}
