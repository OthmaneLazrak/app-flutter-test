import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:typed_data';
import '../services/profile_image_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  User? currentUser;
  Uint8List? userProfileImageBytes;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    _loadProfileImage();

    // Update dynamique si user change
    FirebaseAuth.instance.authStateChanges().listen((u) {
      setState(() {
        currentUser = u;
      });
      if (u != null) {
        _loadProfileImage();
      }
    });
  }

  Future<void> _loadProfileImage() async {
    if (currentUser != null) {
      final bytes = await ProfileImageService.getProfileImageBytes(currentUser!.uid);
      setState(() {
        userProfileImageBytes = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Fruit Predictor",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        backgroundColor: Color(0xFF4CAF50),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),

      // --- Drawer ---
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),

              // 🔥 NOM
              accountName: Text(
                currentUser?.displayName ?? "Utilisateur",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              // 🔥 EMAIL
              accountEmail: Text(
                currentUser?.email ?? "Email non disponible",
              ),

                // 🔥 PHOTO DE PROFIL
                currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: userProfileImageBytes != null
                  ? MemoryImage(userProfileImageBytes!)
                  : null,
                child: userProfileImageBytes == null
                  ? Icon(Icons.person, size: 45, color: Color(0xFF4CAF50))
                  : null,
                ),
            ),

            _buildDrawerItem(Icons.person, "Mon profil", () {
              Navigator.pop(context);
            }),

            _buildDrawerItem(Icons.collections, "Galerie", () {
              Navigator.pop(context);
            }),

            _buildDrawerItem(Icons.logout, "Déconnexion", () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            }, isLogout: true),
          ],
        ),
      ),

      // --- Background principal ---
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4CAF50),
              Color(0xFF8BC34A),
              Color(0xFFFFC107),
            ],
          ),
        ),

        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              "Bienvenue dans l'application Fruit Predictor !\n\n"
              "TFLite est désactivé dans cette version.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isLogout = false,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (isLogout ? Colors.red : Color(0xFF4CAF50)).withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isLogout ? Colors.red : Color(0xFF4CAF50),
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? Colors.red : Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
