import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class GetFireStatus{
  late DatabaseReference dbRef;
  late FirebaseDatabase firebaseDatabase;
  
  GetFireStatus(){
     FirebaseApp firebaseApp = Firebase.app();
    firebaseDatabase = FirebaseDatabase.instanceFor(
      app: firebaseApp,
      databaseURL: "https://fire-warning-system-2d9c2-default-rtdb.asia-southeast1.firebasedatabase.app",
    );
    dbRef = firebaseDatabase.reference();
  }

  Future<bool> getAlertStatusFromDB() async {
    try{
      DatabaseReference codesRef = dbRef.child("Fire");
      DatabaseEvent event = await codesRef.once();
        if (event.snapshot.exists) {
        DataSnapshot dataSnapshot = event.snapshot;
        if (dataSnapshot.value != null) {
        Map<dynamic, dynamic>? existingCodeData = dataSnapshot.value as Map<dynamic, dynamic>?;
            for (var entry in existingCodeData!.entries){
              var value = entry.value;
              if (value["Status"] == true){
                return true;
              }
            }

        } 

      }

    }catch(e){
      return false;

    }
     return false;
  }
}