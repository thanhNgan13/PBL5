import 'package:fire_warning_app/pages/home/user_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Home_v2 extends StatefulWidget {
  const Home_v2({super.key});

  @override
  State<Home_v2> createState() => _Home_v2State();
}

class _Home_v2State extends State<Home_v2> {
  final TextEditingController _controllerUserName = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  final DatabaseReference _database = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL:
              "https://fire-warning-system-2d9c2-default-rtdb.asia-southeast1.firebasedatabase.app")
      .reference();

  List<User> users = [];

  bool update = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    retrieveDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'User List',
                  style: TextStyle(fontSize: 20),
                ),
                for (int i = 0; i < users.length; i++) userWidget(users[i])
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _controllerUserName.text = '';
            _controllerPassword.text = '';
            itemDialog();
            setState(() {
              update = false;
            });
          },
          child: const Icon(Icons.add),
        ));
  }

  void itemDialog({String? key}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          // Crete text field
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _controllerUserName,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your username',
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _controllerPassword,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your password',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      Map<String, dynamic> data = {
                        'username': _controllerUserName.text.toString(),
                        'password': _controllerPassword.text.toString(),
                      };

                      if (update) {
                        _database
                            .child("User")
                            .child(key!)
                            .update(data)
                            .then((value) {
                          int index =
                              users.indexWhere((element) => element.key == key);
                          users.removeAt(index);
                          users.insert(
                              index,
                              User(
                                  key: key, userData: UserData.fromJson(data)));
                          setState(() {});
                          Navigator.of(context).pop();
                        }).catchError((error) {
                          print("Failed to update user: $error");
                        });
                        return;
                      }

                      _database.child("User").push().set(data).then((value) {
                        Navigator.of(context).pop();
                      }).catchError((error) {
                        print("Failed to add user: $error");
                      });
                    },
                    child: Text(update ? 'Update' : 'Add')),
              ],
            ),
          ),
        );
      },
    );
  }

  void retrieveDataUser() {
    _database.child("User").onChildAdded.listen((data) {
      UserData userData = UserData.fromJson(data.snapshot.value as Map);
      User user = User(key: data.snapshot.key, userData: userData);
      users.add(user);

      setState(() {});
    });
  }

  Widget userWidget(User user) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              _controllerPassword.text = user.userData!.password!;
              _controllerUserName.text = user.userData!.username!;
              itemDialog(key: user.key);
              setState(() {
                update = true;
              });
            },
            child: Column(
              children: [
                Text('Username: ${user.userData!.username!}'),
                Text('Password: ${user.userData!.password!}'),
              ],
            ),
          ),
          const SizedBox(width: 20),
          InkWell(
            onTap: () {
              _database.child("User").child(user.key!).remove().then((value) {
                int index =
                    users.indexWhere((element) => element.key == user.key);
                users.removeAt(index);
                setState(() {});
              }).catchError((error) {
                print("Failed to delete user: $error");
              });
            },
            child: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
