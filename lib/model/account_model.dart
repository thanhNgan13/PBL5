import 'package:fire_warning_app/model/Account.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class AccountModel{
  late DatabaseReference dbRef;
  late FirebaseDatabase firebaseDatabase;
  
  AccountModel(){
    FirebaseApp firebaseApp = Firebase.app();
    firebaseDatabase = FirebaseDatabase.instanceFor(
      app: firebaseApp,
      databaseURL: "https://fire-warning-system-2d9c2-default-rtdb.asia-southeast1.firebasedatabase.app",
    );
    dbRef = firebaseDatabase.reference();
  }

  Future<String> getCurrentUserAccount(String phone)async{
    try{
      DatabaseReference accountsRef = dbRef.child("Accounts");
      DatabaseEvent event = await accountsRef.once();
      if (event.snapshot.exists) {// Collection Accounts exists
        DataSnapshot dataSnapshot = event.snapshot;
        if( dataSnapshot.value!=null){//Collection Accounts have data
          Map<dynamic, dynamic>existingAccountsData = dataSnapshot.value as Map<dynamic,dynamic>;
          for (var entry in existingAccountsData!.entries){
            var value = entry.value;
            if (value["phone"] == phone) { //the code exists in the collection
              return value["name"];
            }
          }
        }
      }
    }
    catch(e){}
    return "";
  }
}