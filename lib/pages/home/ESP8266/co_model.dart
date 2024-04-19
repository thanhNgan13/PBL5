class CO {
  String? key;
  COData? coData;

  CO({this.key, this.coData});
}

class COData {
  String? status;
  int? value;

  COData({this.status, this.value});

  COData.fromJson(Map<dynamic, dynamic> json) {
    status = json['Status_CO'];
    value = json['Val_CO'];
  }
}
