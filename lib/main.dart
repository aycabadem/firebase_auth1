import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FirebaseAuth auth;
  final String _email = 'aycabadem12@gmail.com';
  final String _password = 'password';
  @override
  void initState() {
    auth = FirebaseAuth.instance;
    super.initState();

    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        debugPrint('User is currently signed out!');
      } else {
        debugPrint(
            'User is signed in!${user.email} ---- ${user.emailVerified}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                createUserEmailAndPassword();
              },
              style: ElevatedButton.styleFrom(primary: Colors.red),
              child: Text(
                'Email/Şifre Kayit',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                loginUserEmailAndPassword();
              },
              style: ElevatedButton.styleFrom(primary: Colors.red),
              child: Text(
                'Email/Şifre giriş',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                signOutUser();
              },
              style: ElevatedButton.styleFrom(primary: Colors.yellow),
              child: Text(
                'sign out',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                deleteUser();
              },
              style: ElevatedButton.styleFrom(primary: Colors.purple),
              child: Text(
                'Delete user',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                changePassword();
              },
              style: ElevatedButton.styleFrom(primary: Colors.purple),
              child: Text(
                'Change Password',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                changeEmail();
              },
              style: ElevatedButton.styleFrom(primary: Colors.brown),
              child: Text(
                'Change Email',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void createUserEmailAndPassword() async {
    try {
      var _userCredential = await auth.createUserWithEmailAndPassword(
          email: _email, password: _password);

      var _myUser = _userCredential.user;
      if (!_myUser!.emailVerified) {
        await _myUser.sendEmailVerification();
      } else {
        debugPrint('mail onayli');
      }

      debugPrint(_userCredential.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void loginUserEmailAndPassword() async {
    try {
      var _userCredential = await auth.signInWithEmailAndPassword(
          email: _email, password: _password);

      debugPrint(_userCredential.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void signOutUser() async {
    await auth.signOut();
  }

  void deleteUser() async {
    if (auth.currentUser != null) {
      await auth.currentUser!.delete();
    } else {
      debugPrint('login first');
    }
  }

  void changePassword() async {
    try {
      await auth.currentUser!.updatePassword('password');
      await auth.signOut();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        debugPrint('reauthenticate');
        var credential =
            EmailAuthProvider.credential(email: _email, password: _password);

        await auth.currentUser!.reauthenticateWithCredential(credential);

        await auth.currentUser!.updatePassword('password');
        await auth.signOut();

        debugPrint('password changed');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void changeEmail() async {
    try {
      await auth.currentUser!.updateEmail('aca@acaca.com');
      await auth.signOut();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        debugPrint('reauthenticate');
        var credential =
            EmailAuthProvider.credential(email: _email, password: _password);

        await auth.currentUser!.reauthenticateWithCredential(credential);

        await auth.currentUser!.updateEmail('aca@acaca.com');
        await auth.signOut();

        debugPrint('email changed');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
