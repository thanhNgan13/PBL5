import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class AlertModel{
   late DatabaseReference dbRef;
  late FirebaseDatabase firebaseDatabase;

  late List<dynamic> existingPhones;

  String _userName="";

  AlertModel(){
     FirebaseApp firebaseApp = Firebase.app();
    firebaseDatabase = FirebaseDatabase.instanceFor(
      app: firebaseApp,
      databaseURL: "https://fire-warning-system-2d9c2-default-rtdb.asia-southeast1.firebasedatabase.app",
    );
    dbRef = firebaseDatabase.reference();
  }

  Future<void> sendAlertToFamily(String _code,String _phone) async {
    if(await getPhones(_code)){
      await changeIsAlert(_phone); 
      await saveHistoryAlert(_code,_userName);
    }
  }


  Future<bool> getPhones(String _code) async {
    try{
      DatabaseReference codesRef = dbRef.child("Codes");
      DatabaseEvent event = await codesRef.once();

      if (event.snapshot.exists) {// Collection Codes exists
        DataSnapshot dataSnapshot = event.snapshot;
        if (dataSnapshot.value != null) {// Collection Codes have data
        Map<dynamic, dynamic>? existingCodeData = dataSnapshot.value as Map<dynamic, dynamic>?;
            for (var entry in existingCodeData!.entries){
              var value = entry.value;
              if (value["code"] == _code){//the _code exists in the collection
                // get the existing phone numbers array
                existingPhones =List.from(value["phones"]);
                return true;
              
              }
            }

        } 

      }
      return false;

    }catch(e){
      print(e);
      return false;
    }
  }
  Future<void> changeIsAlert(String userPhone) async {
    if(existingPhones.isNotEmpty){
      for(var _phone in existingPhones){
      try{
        DatabaseReference accountsRef = dbRef.child("Accounts");
        DatabaseEvent event = await accountsRef.once();
        if (event.snapshot.exists){// Collection Accounts exists
          DataSnapshot dataSnapshot = event.snapshot;
          if( dataSnapshot.value!=null){//Collection Accounts have data
            Map<dynamic, dynamic> existingAccountsData = dataSnapshot.value as Map<dynamic,dynamic>;
            for (var entry in existingAccountsData.entries){///////////xoa ! sau
              var key = entry.key;
              var value = entry.value;

              if (value["phone"] == _phone) { //the phone exists in the collection
                // Cập nhật trạng thái "isAlerted" thành true
                DatabaseReference accountRef = accountsRef.child(key); // Tham chiếu đến Account cụ thể
                accountRef.update({"isAlerted": true});
                
                 //get name of user turning on alert
                if(_phone==userPhone){
                   _userName= value["name"];
                }
              }
            }
          }
        }
      }catch(e){
        print(e);
      }
    }
    }  
  }
  Future<bool> saveHistoryAlert(String userCodeID, String userName) async {
    try{
      DatabaseReference notificationsRef = dbRef.child("Notifications");
      DatabaseEvent event = await notificationsRef.once();
      if (event.snapshot.exists){// Collection Notifications exists in DB
        DataSnapshot dataSnapshot = event.snapshot;
        if (dataSnapshot.value != null) {// Collection Notifications have data
          // get key
          String? notiKey;

          Map<dynamic, dynamic>? existingNotiData = dataSnapshot.value as Map<dynamic, dynamic>?;
          bool isNotiExist=false;
          for (var entry in existingNotiData!.entries){
            var key = entry.key;
            var value = entry.value;
            if (value["code"] == userCodeID){////the noti of this CODE exists in the collection
              //get the existing Noti data
              notiKey = key;
              // get the existing Alerts array
              List<dynamic> existingAlerts =List.from(value["alerts"]);

              //create new alert
              Map<String, dynamic> newAlert = {
                'alertBy': userName,
                'alertAt': DateTime.now().toIso8601String(),
              };
              // Add the new alert to the existing Alerts array
              existingAlerts.add(newAlert);
              // Update the alerts array in DB
              existingNotiData[notiKey]['alerts'] = existingAlerts;

              // Update the Notifications in DB
              Map<String, Object?> convertedData = Map<String, Object?>.from(existingNotiData[notiKey]! as Map<Object?, Object?>);
              //await codesRef.child(codeKey!).update(existingCodeData[codeKey]! as Map<String, Object?>);
              await notificationsRef.child(notiKey!).update(convertedData);
              isNotiExist=true;
              return true;
            }
          }
          if(isNotiExist){
            return true;
          }
          else{//Notifications does not exist in the collection
            //create new alert
              Map<String, dynamic> newAlert = {
                'alertBy': userName,
                'alertAt': DateTime.now().toIso8601String(),
              };

            //add new notification
            Map<dynamic, dynamic> newNoti = {
              "code": userCodeID,
              "alerts": [newAlert],
            };
             await notificationsRef.push().set(newNoti);

             return true;
          }
        }
        else{// Collection Notifications does not have data
          //create new alert
              Map<String, dynamic> newAlert = {
                'alertBy': userName,
                'alertAt': DateTime.now().toIso8601String(),
              };

            //add new notification to Notifications collection
            Map<dynamic, dynamic> newNoti = {
              "code": userCodeID,
              "alerts": [newAlert],
            };
             await dbRef.child("Notifications").push().set(newNoti);

             return true;
        }

      }else{// Collection Notifications does not exist in DB
        //create new alert
              Map<String, dynamic> newAlert = {
                'alertBy': userName,
                'alertAt': DateTime.now().toIso8601String(),
              };

        //create a new notification and add to DB
        Map<dynamic, dynamic> newNoti = {
              "code": userCodeID,
              "alerts": [newAlert],
            };
        await notificationsRef.push().set(newNoti);

        return true;

      }
    }catch(e){
      print("Error to add data to Notifications collection");
      return false;
    }
  }

  Future<void> changePersonalAlertStatus(String userPhone) async {
    try{
       DatabaseReference accountsRef = dbRef.child("Accounts");
      DatabaseEvent event = await accountsRef.once();
      if (event.snapshot.exists){// Collection Notifications exists in DB
         DataSnapshot dataSnapshot = event.snapshot;
          if( dataSnapshot.value!=null){//Collection Accounts have data
            Map<dynamic, dynamic> existingAccountsData = dataSnapshot.value as Map<dynamic,dynamic>;
              for (var entry in existingAccountsData.entries){///////////xoa ! sau
                var key = entry.key;
                var value = entry.value;

                if (value["phone"] == userPhone) { //the phone exists in the collection
                  // Cập nhật trạng thái "isAlerted" thành false
                  DatabaseReference accountRef = accountsRef.child(key); // Tham chiếu đến Account cụ thể
                  accountRef.update({"isAlerted":false});
                }
              }
          }
      }

    }catch(e){
       print("Error to change person alert status");
    }
  }

}