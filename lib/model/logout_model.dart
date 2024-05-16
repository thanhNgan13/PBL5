import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class LogoutModel{
  late DatabaseReference dbRef;
  late FirebaseDatabase firebaseDatabase;

  LogoutModel(){ 
    FirebaseApp firebaseApp = Firebase.app();
    firebaseDatabase = FirebaseDatabase.instanceFor(
      app: firebaseApp,
      databaseURL: "https://fire-warning-system-2d9c2-default-rtdb.asia-southeast1.firebasedatabase.app",
    );
    dbRef = firebaseDatabase.reference();
  }
  Future<void> removeTokenInDB(String _phone) async {
    try{
     DatabaseReference accountsRef = dbRef.child("Accounts");
      DatabaseEvent event = await accountsRef.once();
      if (event.snapshot.exists) {// Collection Accounts exists
         DataSnapshot dataSnapshot = event.snapshot;
        if( dataSnapshot.value!=null){//Collection Accounts have data
          Map<dynamic, dynamic>existingAccountsData = dataSnapshot.value as Map<dynamic,dynamic>;
          for (var entry in existingAccountsData!.entries){
             var key = entry.key;
            var value = entry.value;
            if (value["phone"] == _phone) { //the code exists in the collection
               DatabaseReference accountRef = accountsRef.child(key); // Tham chiếu đến Account cụ thể
              accountRef.update({"token": "null"});
            }
          }
        }
      }
    }catch(e){
      print(e);
    }
  }
}