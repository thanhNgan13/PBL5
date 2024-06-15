import 'package:fire_warning_app/model/StatusCO.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class StatusCOModel{
  late DatabaseReference dbRef;
  late FirebaseDatabase firebaseDatabase;

  StatusCOModel(){
    FirebaseApp firebaseApp = Firebase.app();
    firebaseDatabase = FirebaseDatabase.instanceFor(
      app: firebaseApp,
      databaseURL: "https://fire-warning-system-2d9c2-default-rtdb.asia-southeast1.firebasedatabase.app",
    );
    dbRef = firebaseDatabase.reference();
  }
  Future<StatusCO> getStatusCO(String esp8266) async {
    StatusCO statusCO=StatusCO("", 0);
    try{
      DatabaseReference codesRef = dbRef.child(esp8266);
      DatabaseEvent event = await codesRef.once();

      return statusCO;
    }
    catch(e){
      print(e);
      return statusCO;
    }
    return statusCO;
}
}
