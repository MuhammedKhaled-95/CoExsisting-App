class EventsModelClass {
  static final String id = "id";
  static final String name = "name";
  static final String image = "image";
  static final String url = "url";
  static final String description = "description";
  static final DateTime startTime = null;
  static final DateTime endTime = null;
  static final String type = "type";
  static final String months = "month";

  EventsModelClass(
      {this.eventname,
      this.eventid,
      this.eventimage,
      this.eventdescription,
      this.eventurl,
      this.eventendTime,
      this.eventstartTime,
      this.eventtype,
      this.eventmonth});

  final String eventname;
  final String eventid;
  final List eventimage;
  final String eventurl;
  final String eventdescription;
  final DateTime eventstartTime;
  final DateTime eventendTime;
  final String eventtype;
  final String eventmonth;

  Map toMap() {
    Map<dynamic, dynamic> map = {
      eventname: name,
      eventid: id,
      eventdescription: description,
      eventendTime: endTime,
      eventimage: image,
      eventtype: type,
      eventurl: url,
      eventstartTime: startTime,
      eventmonth: months
    };
    return map;
  }

  static EventsModelClass fromMap(Map map) {
    return new EventsModelClass(
        eventname: map[name],
        eventid: map[id],
        eventdescription: map[description],
        eventendTime: map[endTime],
        eventimage: map[image],
        eventstartTime: map[startTime],
        eventtype: map[type],
        eventurl: map[url]);
  }
}
