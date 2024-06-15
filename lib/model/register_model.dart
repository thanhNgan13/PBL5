import 'package:fire_warning_app/model/Account.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class RegisterModel {
  late DatabaseReference dbRef;
  late FirebaseDatabase firebaseDatabase;

  RegisterModel() {
    FirebaseApp firebaseApp = Firebase.app();
    firebaseDatabase = FirebaseDatabase.instanceFor(
      app: firebaseApp,
      databaseURL: "https://fire-warning-system-2d9c2-default-rtdb.asia-southeast1.firebasedatabase.app",
    );
    dbRef = firebaseDatabase.reference();
  }

  //DatabaseReference dbRef=FirebaseDatabase.instance.ref("");
  Future<bool> addAccount(Account account) async {
    //add phone number to array of Codes
    if(await addPhoneToCodes(account.code,account.phone)==false){
      return false;
    }

    //add account to db
    Map<dynamic, dynamic> accountData ={
      "name": account.name, 
      "phone": account.phone,
      "code": account.code,
      "isAlerted": false,
    };
    await dbRef.child("Accounts").push().set(accountData);
    return true;

  }
  //check codeID exists in Codes
 //check codeID exists in Codes
  Future<bool> isExistingCode(String code) async {
    try{
      DatabaseReference accountsRef = dbRef.child("Codes");
      DatabaseEvent event = await accountsRef.once();
      if (event.snapshot.exists){// Collection Codes exists
        DataSnapshot dataSnapshot = event.snapshot;
        //get the existing code data
        if( dataSnapshot.value!=null){//Collection Codes have data
          Map<dynamic, dynamic>existingAccountsData = dataSnapshot.value as Map<dynamic,dynamic>;
          bool isCodeExist = false;
          existingAccountsData.forEach((key, value) {
            if (value["code"] == code) {
              isCodeExist= true;
            }
          });
            return isCodeExist;
        }
      }

    }catch(e){
      return false;
    }
    return false;
  }
  //check phone exists in Accounts
  Future<bool> isExistingPhone(String phone) async {
    try{
      DatabaseReference accountsRef = dbRef.child("Accounts");
      DatabaseEvent event = await accountsRef.once();
      if (event.snapshot.exists) { // Collection Accounts exists 
        DataSnapshot dataSnapshot = event.snapshot;

        //get the existing code data
        if( dataSnapshot.value!=null){//Collection Accounts have data
          Map<dynamic, dynamic>existingAccountsData = dataSnapshot.value as Map<dynamic,dynamic>;
          bool isPhoneExist = false;
          existingAccountsData.forEach((key, value) {
            if (value["phone"] == phone) {
              isPhoneExist= true;
            }
          });
            return isPhoneExist;
        }
      }
    }
    catch(e){
      return true;
    }
    return false;
  }

  Future<bool> addPhoneToCodes(String code,String phone) async {
    try {
      DatabaseReference codesRef = dbRef.child("Codes");
      DatabaseEvent event = await codesRef.once();
      if (event.snapshot != null){// Collection Codes exists in DB
        DataSnapshot dataSnapshot = event.snapshot;
        if (dataSnapshot.value != null) {// Collection Codes have data
          // get key
          String? codeKey;

          Map<dynamic, dynamic>? existingCodeData = dataSnapshot.value as Map<dynamic, dynamic>?;
          bool isCodeExist=false;
          for (var entry in existingCodeData!.entries) {
            var key = entry.key;
            var value = entry.value;
            if (value["code"] == code) {//the code exists in the collection
              //get the existing code data
              codeKey = key;
              // get the existing phone numbers array
              List<dynamic> existingPhones =List.from(value["phones"]);
              // Add the new phone number to the existing phone numbers array
              existingPhones.add(phone);
              // Update the phones array in DB
              existingCodeData[codeKey]['phones'] = existingPhones;

              // Update the Codes in DB
              Map<String, Object?> convertedData = Map<String, Object?>.from(existingCodeData[codeKey]! as Map<Object?, Object?>);
              //await codesRef.child(codeKey!).update(existingCodeData[codeKey]! as Map<String, Object?>);
              await codesRef.child(codeKey!).update(convertedData);
              isCodeExist=true;
              return true;
            }
          }
          /*
            existingCodeData?.forEach((key, value) async {
            if (value["code"] == code) {//the code exists in the collection
              //get the existing code data
              codeKey = key;
              // get the existing phone numbers array
              List<dynamic> existingPhones =value["phones"];
              // Add the new phone number to the existing phone numbers array
              existingPhones.add(phone);
              // Update the phones array
              existingCodeData[codeKey]['phones'] = existingPhones;

              // Update the code data
              await codesRef.child(codeKey!).update(existingCodeData[codeKey]);
              isCodeExist= true;
            }
          });*/
          if (isCodeExist) {//the code exists in the collection
              return true;
          }
          else {//code does not exist in the collection
            //create a new code data and add phone to array
            Map<dynamic, dynamic> newCodeData = {
              "code": code,
              "phones": [phone],
            };
            await codesRef.push().set(newCodeData);

            return true;
          }
        }
        else {// Collection does not exist data
          // Create a new code data and add phone to array
          Map<dynamic, dynamic> codeData = {
            "code": code,
            "phones": [phone],
          };
          await dbRef.child("Codes").push().set(codeData);

          return true;
        }
      }
      else{// Collection Codes does not exist
        //create a new code data and add phone to array
        Map<dynamic,dynamic> newCodeData = {
          "code": code,
          "phones": [phone],
        };
        await codesRef.push().set(newCodeData);

        return true;
      }

    }
    catch (e) {
      return false;
    }
  }

}