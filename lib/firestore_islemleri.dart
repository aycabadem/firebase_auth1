import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FireStoreIslemleri extends StatelessWidget {
  FireStoreIslemleri({Key? key}) : super(key: key);

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription? _userSubscribe;
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
            child: const Text('Veri Ekle Set'),
          ),
          ElevatedButton(
            onPressed: () => veriGuncelleme(),
            style: ElevatedButton.styleFrom(primary: Colors.yellow),
            child: const Text('Veri Güncelle'),
          ),
          ElevatedButton(
            onPressed: () => veriSil(),
            style: ElevatedButton.styleFrom(primary: Colors.red),
            child: const Text('Veri Sil'),
          ),
          ElevatedButton(
            onPressed: () => veriOkuOneTime(),
            style: ElevatedButton.styleFrom(primary: Colors.pink),
            child: const Text('Veri Oku One Time'),
          ),
          ElevatedButton(
            onPressed: () => veriOkuRealTime(),
            style: ElevatedButton.styleFrom(primary: Colors.purple),
            child: const Text('Veri Oku Real Time'),
          ),
          ElevatedButton(
            onPressed: () => streamDurdur(),
            style: ElevatedButton.styleFrom(primary: Colors.teal),
            child: const Text('Stream Durdur'),
          ),
          ElevatedButton(
            onPressed: () => batchKavrami(),
            style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 1, 30, 44)),
            child: const Text('Batch Kavrami'),
          ),
          ElevatedButton(
            onPressed: () => transactionKavrami(),
            style: ElevatedButton.styleFrom(primary: Colors.brown),
            child: const Text('Transaction Kavrami'),
          ),
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

  veriGuncelleme() async {
    await _firestore
        .doc('users/mWsMJygTPuzr6a4t9xeq')
        .update({'adres.ilce': 'yeni ilce'});
  }

  veriSil() async {
    // await _firestore.doc('users/mWsMJygTPuzr6a4t9xeq').delete();

    await _firestore
        .doc('users/mWsMJygTPuzr6a4t9xeq')
        .update({'okul': FieldValue.delete()});
  }

  veriOkuOneTime() async {
    var _userDocuments = await _firestore.collection('users').get();
    for (var eleman in _userDocuments.docs) {
      // debugPrint('Dokuman id : ${eleman.id}');
      Map userMap = eleman.data();
      //debugPrint(userMap['isim']);
    }
    var aycaDoc = await _firestore.doc('users/0UC3vfYHAMZqM7bnzKXq').get();

    // debugPrint(aycaDoc.data()!['adres']['il'].toString());
  }

  veriOkuRealTime() async {
    var _userStream = await _firestore.collection('users').snapshots();
    _userSubscribe = _userStream.listen((event) {
      event.docChanges.forEach((element) {
        debugPrint(element.doc.data().toString());

        // event.docs.forEach((element) {
        //   debugPrint(element.data().toString());
        //bu değişiklik olunca tüm dökümanı veriyor
      });
    });
    //döküman dinleme
    // var _userDocStream =
    //     await _firestore.doc('users/0UC3vfYHAMZqM7bnzKXq').snapshots();

    // _userSubscribe = _userDocStream.listen((event) {
    //   debugPrint(event.data().toString());
    // });
  }

  streamDurdur() async {
    await _userSubscribe?.cancel();
  }

  batchKavrami() async {
    WriteBatch _batch = _firestore.batch();
    CollectionReference _counterColRef = _firestore.collection('counter');
    //SET
    // for (int i = 0; i < 10; i++) {
    //   var _yeniDoc = _counterColRef.doc();
    //   _batch.set(_yeniDoc, {'saayc': i++, 'id': _yeniDoc.id});
    // }
    //UPDATE
    // var _counterDocs = await _counterColRef.get();
    // _counterDocs.docs.forEach((element) {
    //   _batch.update(
    //       element.reference, {'createdAt': FieldValue.serverTimestamp()});
    // });

    //DELETE
    var _counterDocs = await _counterColRef.get();
    _counterDocs.docs.forEach((element) {
      _batch.delete(element.reference);
    });

    await _batch.commit();
  }

  transactionKavrami() {}
}
