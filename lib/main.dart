import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_app_flutter_1/screen/menu/pesanan/cart_provider.dart';
import 'package:my_app_flutter_1/services/authGate.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:my_app_flutter_1/screen/menu/home/details/details.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Warung Cak Andik App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Roboto', // Add a default font family
        primaryColor: Colors.teal,
      ),
      routes: {
        'details': (context) => Details(),
      },
      home: LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Add additional initialization tasks if needed
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const AuthGate(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Text(
                      'Selamat Datang di',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 4
                          ..color = Colors.teal,
                      ),
                    ),
                    const Text(
                      'Selamat Datang di',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const Text(
                  "Warung Cak Andik App",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Sajian Khas Warung Penyetan dan Sari Laut Lamongan! Rasakan Kenikmatan yang Menggoyang Lidah, Kelezatan yang Memanjakan Selera. Hanya di Sini, Setiap Gigitan Menyajikan Pengalaman Kuliner Tak Terlupakan",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("lib/assets/logo.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Sajikan kelezatan dalam genggaman Anda. Cara baru menikmati pengalaman kuliner di Warung Cak Andik. Mulai sekarang, pesan, ambil, dan nikmati!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
