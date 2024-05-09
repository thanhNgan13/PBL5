import 'package:fire_warning_app/model/alert_status_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
/*
class AlertStatusPresenter{
  AlertStatusModel alertStatusModel = AlertStatusModel();

  Future<bool> getAlertStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? _phone = prefs.getString('USER_PHONE');
    if( _phone != null  && _phone.isNotEmpty){
      return await alertStatusModel.getAlertStatus(_phone);
    }
    return false;
  }
}
*/
class AlertStatusPresenter {
  AlertStatusModel? alertStatusModel;

  // Constructor where we initialize the AlertStatusModel asynchronously
  AlertStatusPresenter() {
    initializeModel();
  }

  Future<void> initializeModel() async {
    alertStatusModel = await AlertStatusModel.create();
  }

  Future<bool> getAlertStatus() async {
    // Ensure the model is initialized
    if (alertStatusModel == null) {
      await initializeModel();
    }
    await Future.delayed(Duration(seconds: 2));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.reload();
    final String? _phone = prefs.getString('USER_PHONE');
    if (_phone != null && _phone.isNotEmpty) {
      return await alertStatusModel!.getAlertStatus(_phone);
    }
    return false;
  }
}