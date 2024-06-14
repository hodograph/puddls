import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:puddls/models/user.dart' as puddl_user;

class UserFirestoreService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference users = FirebaseFirestore.instance.collection("Users").withConverter<puddl_user.User>(
    fromFirestore: puddl_user.User.fromFirestore,
    toFirestore: (user, options) => (user).toJson());

  Future<void> addOrUpdateUser(puddl_user.User user) async{
    // Only let user update themselves.
    if(_firebaseAuth.currentUser!.uid == user.id)
    {
      await users.doc(user.id).set(user);
    }
  }

  Future<puddl_user.User?> getUser(String id) async{
    puddl_user.User? user;
    final docRef = await users.doc(id).get();
    
    if(docRef.exists)
    {
      user = docRef.data() as puddl_user.User;
    }

    return user;
  }

  Stream<puddl_user.User> listenToUser(String? id)
  {
    id ??= _firebaseAuth.currentUser!.uid;
    return users.doc(id).snapshots().map(
      (snapshot) => snapshot.data()! as puddl_user.User
    );
  }
}