class Partners {
  final String companyname;
  final String companyLogo;
  final String description;
  final String website;

  Partners(
      {this.companyname, this.companyLogo, this.description, this.website});

  Map<String, dynamic> toJson() => {
        'companyname': companyname,
        'companyLogo': companyLogo,
        'description': description,
        'website': website
      };

  static Partners fromMap(Map map) {
    return new Partners(
        companyname: map["companyname"],
        companyLogo: map["companyLogo"],
        description: map["description"],
        website: map["website"]);
  }
}

class Rewards {
  final String rid;
  final String rname;
  final String rimage;
  final int rpoints;
  final String rdescription;
  final String rtype;
  bool isReedem;
  Rewards(
      {this.rid,
      this.rname,
      this.rimage,
      this.rpoints,
      this.rdescription,
      this.rtype,
      this.isReedem});

  Map<String, dynamic> toJson() => {
        'id': rid,
        'name': rname,
        'image': rimage,
        'points': rpoints,
        'description': rdescription,
        "type": rtype
      };
}
