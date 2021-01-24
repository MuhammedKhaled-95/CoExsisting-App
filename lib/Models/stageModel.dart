class StageModelClass {
  static final String avatarImg = "stage_image";
  StageModelClass({this.name});
  final String name;
  Map toMap() {
    Map<String, dynamic> map = {
      avatarImg: name,
    };
    return map;
  }

  static StageModelClass fromMap(Map map) {
    return new StageModelClass(name: map[avatarImg]);
  }
}

class ControllerModelClass {
  static final String avatarImg = "image";
  ControllerModelClass({this.name});
  final String name;
  Map toMap() {
    Map<String, dynamic> map = {
      avatarImg: name,
    };
    return map;
  }

  static ControllerModelClass fromMap(Map map) {
    return new ControllerModelClass(name: map[avatarImg]);
  }
}
