import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../services/profile_image_service.dart';


class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final formkey = GlobalKey<FormState>();

  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  Uint8List? _selectedImageBytes;
  final ImagePicker _picker = ImagePicker();

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final pattern = r'^[^@]+@[^@]+\.[^@]+';
    final regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Erreur lors de la sélection de l'image");
    }
  }

  Future<void> SignUp() async {
  try {
    UserCredential userCredential =
        await _auth.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    // 🔥 Mettre à jour le nom dans Firebase Auth
    await userCredential.user!.updateDisplayName(nameController.text.trim());
    await userCredential.user!.reload();

    // 🔥 Sauvegarder la photo de profil si une a été sélectionnée
    if (_selectedImageBytes != null) {
      await ProfileImageService.saveProfileImageBytes(
        _selectedImageBytes!,
        userCredential.user!.uid,
      );
    }

    // 🔥 Recharge l'utilisateur après mise à jour
    FirebaseAuth.instance.currentUser;

    Navigator.pushReplacementNamed(context, '/login');
  } on FirebaseAuthException catch (e) {
    if (e.code == "weak-password") {
      Fluttertoast.showToast(msg: "The password provided is too weak.");
    }
    if (e.code == "invalid-email") {
      Fluttertoast.showToast(msg: "The email address is not valid.");
    }
    if (e.code == "email-already-in-use") {
      Fluttertoast.showToast(msg: "The account already exists for that email.");
    }
  }
}





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        child: SafeArea(
          child: Stack(
            children: [
              // Decorative circles top right
              Positioned(
                top: -80,
                right: -60,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
              ),
              // Decorative circles bottom left
              Positioned(
                bottom: -100,
                left: -80,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.06),
                  ),
                ),
              ),
              // Wave decoration
              Positioned(
                top: 150,
                right: 0,
                child: CustomPaint(
                  size: Size(100, 100),
                  painter: WavePainter(),
                ),
              ),
              SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
                    child: Form(
                      key: formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Back Button
                          Align(
                            alignment: Alignment.topLeft,
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                                ),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),

                          // Logo with enhanced styling
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withOpacity(0.2),
                                  Colors.white.withOpacity(0.05),
                                ],
                              ),
                              border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Image.asset(
                              "images/logo.jpg",
                              height: 100,
                              width: 100,
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(height: 25),
                          
                          // Title
                          Text(
                            "Rejoignez Fruit Predictor !",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              shadows: [
                                Shadow(
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.3),
                                  offset: Offset(2, 4),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12),
                          
                          // Subtitle with decoration line
                          Column(
                            children: [
                              Container(
                                height: 2,
                                width: 60,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0),
                                      Colors.white.withOpacity(0.8),
                                      Colors.white.withOpacity(0),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              Text(
                                "Créez votre compte maintenant",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 35),

                          // Photo de Profil
                          GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 2,
                                ),
                                color: Colors.white.withOpacity(0.1),
                              ),
                                child: _selectedImageBytes == null
                                  ? Column(
                                      children: [
                                        Icon(
                                          Icons.camera_alt,
                                          size: 50,
                                          color: Colors.white,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          "Ajouter une photo",
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.9),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Stack(
                                      children: [
                                        CircleAvatar(
                                          radius: 50,
                                          backgroundImage:
                                              MemoryImage(_selectedImageBytes!),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            padding: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                            ),
                                            child: Icon(
                                              Icons.edit,
                                              size: 18,
                                              color: Color(0xFF4CAF50),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          SizedBox(height: 24),

                          // Name Field
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                              labelStyle: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors.white.withOpacity(0.3), width: 1.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors.white, width: 2.5),
                              ),
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: Colors.white.withOpacity(0.8),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                            ),
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            keyboardType: TextInputType.name,
                            validator: validateName,
                          ),
                          SizedBox(height: 16),

                          // Email Field
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors.white.withOpacity(0.3), width: 1.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors.white, width: 2.5),
                              ),
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: Colors.white.withOpacity(0.8),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                            ),
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            keyboardType: TextInputType.emailAddress,
                            validator: validateEmail,
                          ),
                          SizedBox(height: 16),

                          // Password Field
                          TextFormField(
                            obscureText: !passwordVisible,
                            controller: passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors.white.withOpacity(0.3), width: 1.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors.white, width: 2.5),
                              ),
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Colors.white.withOpacity(0.8),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                                icon: Icon(
                                  passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                            ),
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            keyboardType: TextInputType.visiblePassword,
                            validator: validatePassword,
                          ),
                          SizedBox(height: 16),

                          // Confirm Password Field
                          TextFormField(
                            obscureText: !confirmPasswordVisible,
                            controller: confirmPasswordController,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              labelStyle: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors.white.withOpacity(0.3), width: 1.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(color: Colors.white, width: 2.5),
                              ),
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Colors.white.withOpacity(0.8),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    confirmPasswordVisible = !confirmPasswordVisible;
                                  });
                                },
                                icon: Icon(
                                  confirmPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                            ),
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            keyboardType: TextInputType.visiblePassword,
                            validator: validateConfirmPassword,
                          ),
                          SizedBox(height: 24),

                          // Register Button with gradient
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white,
                                  Colors.white.withOpacity(0.95),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 15,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                             
                                  
                              onPressed: () async {
                                  if (formkey.currentState!.validate()) {
                                    await SignUp();             // 👈 ENFIN ON APPELLE SIGNUP !
                                  }
                                },
                                        
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                              ),
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  color: Color(0xFF4CAF50),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          
                          // Login Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account? ",
                                style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/login');
                                },
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}

// Custom Wave Painter
class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height / 2);
    path.quadraticBezierTo(
      size.width / 4,
      size.height / 4,
      size.width / 2,
      size.height / 2,
    );
    path.quadraticBezierTo(
      3 * size.width / 4,
      3 * size.height / 4,
      size.width,
      size.height / 2,
    );
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => false;
}