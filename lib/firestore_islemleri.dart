import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FireStoreIslemleri extends StatelessWidget {
  FireStoreIslemleri({Key? key}) : super(key: key);

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Islemleri'),
      ),
      body: Center(
          child: Column(
        children: [
          ElevatedButton(
            onPressed: () => veriEklemeAdd(),
            child: const Text('Veri Ekle Add'),
          ),
          ElevatedButton(
              onPressed: () => veriEklemeSet(),
              style: ElevatedButton.styleFrom(primary: Colors.green),
              child: const Text('Veri Ekle Set'))
        ],
      )),
    );
  }

  veriEklemeAdd() async {
    Map<String, dynamic> _eklenecekUser = <String, dynamic>{};
    _eklenecekUser['isim'] = 'emre';
    _eklenecekUser['yas'] = 34;
    _eklenecekUser['ogrenciMi'] = false;
    _eklenecekUser['adres'] = {'il': 'ankara', 'ilce': 'yenimahalle'};
    _eklenecekUser['renkler'] = FieldValue.arrayUnion(['mavi', 'yesil']);
    _eklenecekUser['createdAt'] = FieldValue.serverTimestamp();

    await _firestore.collection('users').add(_eklenecekUser);
  }

  veriEklemeSet() async {
    var _yeniDocID = _firestore.collection('users').doc().id;

    await _firestore
        .doc('users/$_yeniDocID')
        .set({'isim': 'emre', 'userID': _yeniDocID});

    await _firestore.doc('users/mWsMJygTPuzr6a4t9xeq').set(
        {'okul': 'Ege Üniversitesi', 'yas': FieldValue.increment(1)},
        SetOptions(merge: true));
  }
}
