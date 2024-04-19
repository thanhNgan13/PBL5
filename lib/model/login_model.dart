import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class LoginModel{
  late DatabaseReference dbRef;
  late FirebaseDatabase firebaseDatabase;

  LoginModel(){
    FirebaseApp firebaseApp = Firebase.app();
    firebaseDatabase = FirebaseDatabase.instanceFor(
      app: firebaseApp,
      databaseURL: "https://fire-warning-system-2d9c2-default-rtdb.asia-southeast1.firebasedatabase.app",
    );
    dbRef = firebaseDatabase.reference();
  }

  Future<int> login(String phone,String code) async{//0: error, 1: code does not exist, 2: phone does not exist, 3: phone does not in code, 4: success
    var  codeGetting= CodeHolder("");
    int phoneCase=await isExistingPhone(phone,codeGetting);
    int codeCase;
    if(phoneCase==0){
      return 0;
    }
    if(phoneCase==1){
      return 2;
    }
    if(phoneCase==2){
      if(code==codeGetting.code){
        return 4;
      }else{
        codeCase=await isExistingCode(code);
        if(codeCase==2){
          return 3;
        }
        return codeCase;//0 or 1
      }
    }
    return 0;
  }

  Future<int> isExistingPhone(String phone,CodeHolder codeGetting) async {//0: error, 1: phone does not exist, 2:phone exists
    try {
      DatabaseReference accountsRef = dbRef.child("Accounts");
      DatabaseEvent event = await accountsRef.once();
      if (event.snapshot != null) {// Collection Accounts exists
        DataSnapshot dataSnapshot = event.snapshot;
        if( dataSnapshot.value!=null){//Collection Accounts have data
          Map<dynamic, dynamic>existingAccountsData = dataSnapshot.value as Map<dynamic,dynamic>;
          for (var entry in existingAccountsData!.entries){
            var value = entry.value;
            if (value["phone"] == phone) { //the code exists in the collection
              codeGetting.code=value["code"];
              return 2;
            }
          }
          return 1;
        }else{
          return 1;
        }
      }
      else{
        return 1;
      }
    }
    catch(e){
      return 0;
    }
  }
  Future<int> isExistingCode(String code) async {//0: error, 1: code does not exist,2:code exist
    try {
      DatabaseReference codesRef = dbRef.child("Codes");
      DatabaseEvent event = await codesRef.once();
      if (event.snapshot != null) { // Collection Codes exists
        DataSnapshot dataSnapshot = event.snapshot;
        if (dataSnapshot.value != null) { // Collection Codes have data
          Map<dynamic, dynamic>? existingCodeData = dataSnapshot.value as Map<dynamic, dynamic>?;
          for (var entry in existingCodeData!.entries) {
            var value = entry.value;
            if (value["code"] == code) { //the code exists in the collection
              return 2;
            }
          }
          return 1;
        }
        else{
          return 1;
        }
      }
      else{
        return 1;
      }

    }catch(e){
      return 0;
    }
  }
}
class CodeHolder {
  String code;

  CodeHolder(this.code);
}