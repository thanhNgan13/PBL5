class ESP8266 {
  String? key;
  ESP8266Data? coData;
  ESP8266({this.key, this.coData});
}

class ESP8266Data {
  String? status;
  int? value;

  ESP8266Data({this.status, this.value});

  ESP8266Data.fromJson(Map<dynamic, dynamic> json) {
    status = json['Status_CO'];
    value = json['Val_CO'];
  }
}
