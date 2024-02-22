import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sound_app/models/user_model.dart';
import 'package:sound_app/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:sound_app/utils/exceptions/firebase_exceptions.dart';
import 'package:sound_app/utils/exceptions/platform_exceptions.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //Function to save user data in FireStore
  Future<void> saveUserRecord(UserModel userModel) async {
    Get.delete<UserRepository>();
    try {
      print('object');
      return await _db
          .collection("Users")
          .doc(userModel.id)
          .set(userModel.toJson());
    } on FirebaseAuthException catch (e) {
      throw AppFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw AppFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const FormatException('Invalid format').message;
    } on PlatformException catch (e) {
      throw AppPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}

// class MyController {
//   final firestore = FirebaseFirestore.instance;
//
//   ///.add Method
//   ///Simply Adds The Data  If Collection or Document is not found, It Creates New ones.
//   ///
//   void addDataByAdd() {
//     firestore
//         .collection('Users')
//         .add({'Name': 'Hassan', 'email': 'Hassan@gmail.com'});
//   }
//
//   ///.set method cannot be directly called through collection, document reference is needed.
//   ///.set method can create new document if not found.
//   ///.set overrides anything in the document.
//   void addDataBySet() {
//     firestore
//         .collection('Users')
//         .doc('XT2a7bIeXnRAZfzyRfhV1ttWf8D2')
//         .set({'Name': 'Rakesh', 'Caste': 'Kumar'});
//   }
//
//   ///.update method cannot be directly called through collection, document reference is needed.
//   ///.update method can NOT create new document if not found.
//   ///.update Cannot overrides anything in the document only adds the given fields.
//   void updateData(){
//     firestore.collection('Users').doc('hassan@gmail.com').update({
//       'Name': 'hassan',
//       'email': 'hassanai@outlook.com',
//     });
//   }
// }
