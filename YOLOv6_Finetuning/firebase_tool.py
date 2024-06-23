import pyrebase


class Firebase:
    def __init__(self, 
    config = {
            "apiKey": "AIzaSyAhIPdXEWLCybrcWhX6Jb_KFM0HjKHeD9o",
            "authDomain": "fire-warning-system-2d9c2.firebaseapp.com",
            "databaseURL": "https://fire-warning-system-2d9c2-default-rtdb.asia-southeast1.firebasedatabase.app",
            "projectId": "fire-warning-system-2d9c2",
            "storageBucket": "fire-warning-system-2d9c2.appspot.com",
            "messagingSenderId": "138271755735",
            "appId": "1:138271755735:web:8094abadf7b63ca22e8f92",
            "measurementId": "G-X7V2ZD04KE"
            }):
        self.firebase = pyrebase.initialize_app(config)
        self.db = self.firebase.database()

    def push(self,childName, data):
        self.db.child(childName).set(data)

    def get(self, childName=None):
        return self.db.child(childName).get().val()


