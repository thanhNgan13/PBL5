class Fire {
  String? key;
  FireData? fireData;
  Fire({this.key, this.fireData});
}

class FireData {
  String? status;

  FireData({this.status});

  FireData.fromJson(Map<dynamic, dynamic> json) {
    status = json['Status_Fire'];
  }
}
