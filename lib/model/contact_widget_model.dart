import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'Contact.dart';

class ContactWidgetModel{
  late DatabaseReference dbRef;
  late FirebaseDatabase firebaseDatabase;
  ContactWidgetModel(){
    FirebaseApp firebaseApp = Firebase.app();
    firebaseDatabase = FirebaseDatabase.instanceFor(
      app: firebaseApp,
      databaseURL: "https://fire-warning-system-2d9c2-default-rtdb.asia-southeast1.firebasedatabase.app",
    );
    dbRef = firebaseDatabase.reference();
  }
  Future<List<Contact>> getListContact(String phone) async {
    List<Contact> listContact=[];
    try{
      DatabaseReference contactsRef = dbRef.child("Contacts");
      DatabaseEvent event = await contactsRef.once();
      if (event.snapshot != null) { // Collection Contacts exists
        DataSnapshot dataSnapshot = event.snapshot;
        if( dataSnapshot.value!=null) { //Collection Contacts have data
          Map<dynamic, dynamic>existingAccountsData = dataSnapshot.value as Map<dynamic,dynamic>;
          for (var entry in existingAccountsData!.entries){
            var value = entry.value;
            if (value["phone"] == phone){
              for(var member in value["members"].entries){
                Contact contact=Contact(member["name"],member["phone"]);
                listContact.add(contact);
              }
              return listContact;
            }
          }
        }
      }

    }catch(e){

    }
    return listContact;
  }

}