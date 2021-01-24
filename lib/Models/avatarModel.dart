class AvatarModelClass {
  static final String avatarImg = "Avatar_Image";
  AvatarModelClass({this.name});
  final String name;
  Map toMap() {
    Map<String, dynamic> map = {
      avatarImg: name,
    };
    return map;
  }

  static AvatarModelClass fromMap(Map map) {
    return new AvatarModelClass(name: map[avatarImg]);
  }
}
