import '../model/Contact.dart';
import '../model/contact_widget_model.dart';

abstract class ContactWidgetInterface{

}
class ContactWidgetPresenter{
  ContactWidgetInterface? interface;
  final ContactWidgetModel _model=ContactWidgetModel();

  ContactWidgetPresenter(ContactWidgetInterface interface){
    this.interface=interface;
  }
  Future<List<Contact>> getListContact(String phone) async {
    return await _model.getListContact(phone);
  }
}