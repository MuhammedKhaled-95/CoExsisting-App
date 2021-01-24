class UserModelClass {
  static final String userid = "Userid";
  static final String avatarimage = "AvatarImage";
  static final String username = "Username";
  static final String stageimage = "StageImage";
  static final String weaponimage = "WeaponImage";
  static final String instaid = "instaID";
  static final String nintendoid = "nintendoID";
  static final String psnid = "psnID";
  static final String twitchid = "twitchID";
  static final String twitterid = "twitterID";
  static final String xboxid = "xboxID";
  static final String facebookid = "facebookID";
  static final String token = "token";
  static final bool isSelected = false;
  static final List<Game> favArray = [];
  static final String isPushNotificationEnabled = "isPushNotificationEnabled";
  static final String shareSocialEnabled = "isPushNotificationEnabled";
  static final String isTextNotificationEnabled = "isPushNotificationEnabled";
  static final String allowSquadInvite = "allowSquadInvites";
  static final String isEmailNotificationEnabled = "isEmailNotificationEnabled";

  UserModelClass(
      {this.userName,
      this.userId,
      this.avatarImage,
      this.stageImage,
      this.weaponImage,
      this.instaId,
      this.nintendoId,
      this.psnId,
      this.twitchId,
      this.twitterId,
      this.xboxId,
      this.favArry,
      this.facebookId,
      this.fcmToken,
      this.isUserSelected = false,
      this.isEmailEnable,
      this.isPushEnable,
      this.isTextEnable,
      this.shareSocial,
      this.squadInviteEnable});

  final String userName;
  final String userId;
  final String avatarImage;
  final String stageImage;
  final String weaponImage;
  final String instaId;
  final String nintendoId;
  final String psnId;
  final String twitchId;
  final String twitterId;
  final String xboxId;
  var favArry;
  bool isUserSelected;
  final String facebookId;
  final String fcmToken;
  final bool isPushEnable;
  final bool squadInviteEnable;
  final bool isTextEnable;
  final bool isEmailEnable;
  final bool shareSocial;

  Map toMap() {
    Map<dynamic, dynamic> map = {
      userName: username,
      userId: userId,
      avatarImage: avatarimage,
      stageImage: stageimage,
      weaponImage: weaponimage,
      instaId: instaid,
      nintendoId: nintendoid,
      psnId: psnid,
      twitchId: twitchid,
      twitterId: twitterid,
      xboxId: xboxid,
      favArry: favArray,
      facebookId: facebookid,
      fcmToken: token
    };
    return map;
  }

  static UserModelClass fromMap(Map map) {
    return new UserModelClass(
        userName: map[username],
        userId: map[userid],
        avatarImage: map[avatarimage],
        stageImage: map[stageimage],
        weaponImage: map[weaponimage],
        instaId: map[instaid],
        psnId: map[psnid],
        twitchId: map[twitchid],
        twitterId: map[twitterid],
        xboxId: map[xboxid],
        nintendoId: map[nintendoid],
        favArry: map[favArray],
        facebookId: map[facebookid],
        fcmToken: map[token],
        isEmailEnable: map[isEmailNotificationEnabled],
        isPushEnable: map[isPushNotificationEnabled],
        isTextEnable: map[isTextNotificationEnabled],
        shareSocial: map[shareSocialEnabled],
        squadInviteEnable: map[allowSquadInvite],
        isUserSelected: false);
  }
}

class Category {
  static final String categoryid = "category_id";
  static final String categoryname = "category_name";

  final String categoryID;
  final String categoryName;

  Category({this.categoryID, this.categoryName});

  Map toMap() {
    Map<dynamic, dynamic> map = {
      categoryID: categoryid,
      categoryName: categoryname
    };
    return map;
  }

  static Category fromMap(Map map) {
    return new Category(
      categoryName: map[categoryname],
      categoryID: map[categoryid],
    );
  }
}

class Game {
  static final String id = "id";
  static final String image = "image";
  static final String name = "name";
  static final String categories = "categories";

  final String gameid;
  final String gameimage;
  final String gamename;
  List<Category> gamecategories;

  Game({this.gameid, this.gameimage, this.gamename, this.gamecategories});

  Map toMap() {
    Map<dynamic, dynamic> map = {
      this.gameid: id,
      this.gameimage: image,
      this.gamename: name,
      this.gamecategories: categories
    };
    return map;
  }

  static Game fromMap(Map map) {
    return new Game(
        gameid: map[id],
        gameimage: map[image],
        gamename: map[name],
        gamecategories: map[categories]);
  }
}
