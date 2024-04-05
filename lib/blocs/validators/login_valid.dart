class LoginValidation{
  static String validatePhone(String phone){
    if(phone=="")
      return "Vui lòng nhập số điện thoại";

    var isValid=RegExp(r'^[0-9]{10}$').hasMatch(phone);
    if(!isValid)
      return "Vui lòng nhập đúng số điện thoại";
    return "";
  }
  static String validateCode(String code){
    if(code=="")
      return "Vui lòng nhập mã đăng ký";

    var isValid=RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8}$').hasMatch(code);
    if(!isValid)
      return "Vui lòng nhập đúng mã đăng ký";
    return "";
  }
}