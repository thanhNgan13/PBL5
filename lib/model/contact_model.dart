import 'package:fire_warning_app/model/Contact.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class ContactModel{
  late DatabaseReference dbRef;
  late FirebaseDatabase firebaseDatabase;

  ContactModel(){
    FirebaseApp firebaseApp = Firebase.app();
    firebaseDatabase = FirebaseDatabase.instanceFor(
      app: firebaseApp,
      databaseURL: "https://fire-warning-system-2d9c2-default-rtdb.asia-southeast1.firebasedatabase.app",
    );
    dbRef = firebaseDatabase.reference();
  }
  Future<List<String>> getListPhones(String userCodeID) async {
    List<String> listPhones=[];
    try{
      DatabaseReference codesRef = dbRef.child("Codes");
      DatabaseEvent event = await codesRef.once();

      if (event.snapshot.exists) {// Collection Codes exists
        DataSnapshot dataSnapshot = event.snapshot;
        if (dataSnapshot.value != null) {// Collection Codes have data
        Map<dynamic, dynamic>? existingCodeData = dataSnapshot.value as Map<dynamic, dynamic>?;
            for (var entry in existingCodeData!.entries){
              var value = entry.value;
              if (value["code"] == userCodeID){//the _code exists in the collection
                // foreach the existing phone numbers array
                for(var phone in value["phones"]){
                  listPhones.add(phone.toString());
                }
              
              }
            }
        }
      }
    }catch(e){
      print(e);
    }
    return listPhones;
  }

  Future<List<Contact>> getListContacts(String userCodeID,String userPhone) async {
    List<String> listPhones=await getListPhones(userCodeID);
    List<Contact> listContact=[];
    
    
    if(listPhones.isNotEmpty){
      for(var memberPhone in listPhones){
        try{
        DatabaseReference accountsRef = dbRef.child("Accounts");
        DatabaseEvent event = await accountsRef.once();
        if (event.snapshot.exists) { // Collection Accounts exists
          DataSnapshot dataSnapshot = event.snapshot;

          //get the existing code data
          if( dataSnapshot.value!=null){//Collection Accounts have data
            Map<dynamic, dynamic>existingAccountsData = dataSnapshot.value as Map<dynamic,dynamic>;

            existingAccountsData.forEach((key, value) {
              if (value["phone"] == memberPhone  && value["phone"]!=userPhone) {//other members phone
                Contact newContact=Contact(value["name"].toString(), value["phone"].toString());
                listContact.add(newContact);
              }
            });
          }
        }
      
      }catch(e){
        print(e);
      }
      }
    }   
    return listContact;
  }
}