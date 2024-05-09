import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class AlertStatusModel{
  late DatabaseReference dbRef;
  late FirebaseDatabase firebaseDatabase;


   AlertStatusModel._internal(this.dbRef, this.firebaseDatabase);

  static Future<AlertStatusModel> create() async {
    FirebaseApp firebaseApp;
    try {
      firebaseApp = Firebase.app();
    } catch (e) {
      firebaseApp = await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyCSiBTRnU7u3aQee9-b2MhzCS6_dlHJsfE',
          appId: '1:138271755735:android:bf37f0d5f22c300e2e8f92',
          messagingSenderId: '138271755735',
          projectId: 'fire-warning-system-2d9c2'
        ),
      );
    }

    FirebaseDatabase firebaseDatabase = FirebaseDatabase.instanceFor(
      app: firebaseApp,
      databaseURL: "https://fire-warning-system-2d9c2-default-rtdb.asia-southeast1.firebasedatabase.app",
    );
    DatabaseReference dbRef = firebaseDatabase.reference();

    return AlertStatusModel._internal(dbRef, firebaseDatabase);
  }

/*
  AlertStatusModel(){
    FirebaseApp firebaseApp = Firebase.app(); 
    firebaseDatabase = FirebaseDatabase.instanceFor(
      app: firebaseApp,
      databaseURL: "https://fire-warning-system-2d9c2-default-rtdb.asia-southeast1.firebasedatabase.app",
    );
    dbRef = firebaseDatabase.reference();
  }
*/
  Future<bool> getAlertStatus(String _phone) async {
    try{
      DatabaseReference codesRef = dbRef.child("Accounts");
      DatabaseEvent event = await codesRef.once();
      if (event.snapshot.exists) {// Collection Accounts exists
        DataSnapshot dataSnapshot = event.snapshot;
        if (dataSnapshot.value != null) {// Collection Accounts have data
          Map<dynamic, dynamic>? existingAccountData = dataSnapshot.value as Map<dynamic, dynamic>?;
            for (var entry in existingAccountData!.entries){
              var value = entry.value;
              if (value["phone"] == _phone){
                if(value["isAlerted"]==true)
                {
                  return true;
                }
                 
              }
            }
        }
      }

    }catch(e){
      print(e);
      return false;
    }

    return false;
  }
}