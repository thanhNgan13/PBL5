class Account{
  String _name;
  String _phone;
  String _code;
  bool isAlert =false;

  Account(this._name, this._phone, this._code);

  String get name => _name;
  String get phone => _phone;
  String get code => _code;

  set name(String name) {
    _name = name;
  }
  set phone(String phone) {
    _phone = phone;
  }
  set code(String code) {
    _code = code;
  }
}