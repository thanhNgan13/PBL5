import 'package:fire_warning_app/model/MyNotification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class NotificationModel{
  late DatabaseReference dbRef;
  late FirebaseDatabase firebaseDatabase;

  NotificationModel(){
    FirebaseApp firebaseApp = Firebase.app();
    firebaseDatabase = FirebaseDatabase.instanceFor(
      app: firebaseApp,
      databaseURL: "https://fire-warning-system-2d9c2-default-rtdb.asia-southeast1.firebasedatabase.app",
    );
    dbRef = firebaseDatabase.reference();
  }

  Future<List<MyNotification>> getListNotifications(String userCodeID) async{
    List<MyNotification> listNoti=[];
    try{
      DatabaseReference notificationsRef = dbRef.child("Notifications");
      DatabaseEvent event = await notificationsRef.once();
      if (event.snapshot.exists) {// Collection Notifications exists
         DataSnapshot dataSnapshot = event.snapshot;
          if (dataSnapshot.value != null) {// Collection Notifications have data
            Map<dynamic, dynamic>? existingCodeData = dataSnapshot.value as Map<dynamic, dynamic>?;
            for (var entry in existingCodeData!.entries){
              var value = entry.value;
              if (value["code"] == userCodeID){//the _code exists in the collection
                // foreach the existing alerts array
                for(var alert in value["alerts"]){
                  //get alertAt and alertBy
                  String alertBy = alert["alertBy"];

                  String alertAtString = alert["alertAt"];

                  DateTime alertAt = DateTime.parse(alertAtString);
                  String formattedDate = DateFormat('HH:mm dd/MM/yyyy').format(alertAt);
                  print(formattedDate);

                  //add new noti to listNoti
                  listNoti.add(MyNotification(alertBy, formattedDate));
                }
              }
            }
          }
      }
    }catch(e){
      print(e);
    }
    return listNoti;
  }
}