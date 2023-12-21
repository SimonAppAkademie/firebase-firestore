import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firestore_bsp/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    // Create a new user with a first and last name
    final user = <String, dynamic>{
      "preis": "23",
    };

    Future<UserCredential> signInWithGoogle() async {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      // return creds
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }

    Future<void> SignOutFromGoogle() async {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
      print("signed out");
    }

    void addUserToDatabase() {
      // Instanz holen
      var db = FirebaseFirestore.instance;
      //Document hinzufügen
      db.collection("/autoteile/rK0jUAPr1ZctvTxx8suf/elektro").add(user).then((DocumentReference doc) => print('DocumentSnapshot added with ID: ${doc.id}'));
    }

    Future<void> readUserFromDatabase() async {
      // Instanz holen
      var db = FirebaseFirestore.instance;
      // Dokumente herunterladen
      await db.collection("/autoteile/rK0jUAPr1ZctvTxx8suf/elektro").get().then((event) {
        for (var doc in event.docs) {
          print("${doc.id} => ${doc.data()}");
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(onPressed: addUserToDatabase, child: Text("Add User To DB")),
            ElevatedButton(onPressed: readUserFromDatabase, child: Text("read data")),
            ElevatedButton(onPressed: signInWithGoogle, child: Text("Sign in with Google")),
            ElevatedButton(onPressed: SignOutFromGoogle, child: Text("Sign out")),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// das ist ein test