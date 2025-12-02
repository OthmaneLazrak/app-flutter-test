import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

const String _prefsKeyPrefix = 'profile_image_';

Future<bool> saveProfileImageBytes(Uint8List bytes, String userId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final b64 = base64Encode(bytes);
    await prefs.setString('$_prefsKeyPrefix$userId', b64);
    return true;
  } catch (e) {
    print('Erreur lors de la sauvegarde de l\'image (Web): $e');
    return false;
  }
}

Future<Uint8List?> getProfileImageBytes(String userId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final b64 = prefs.getString('$_prefsKeyPrefix$userId');
    if (b64 == null) return null;
    return base64Decode(b64);
  } catch (e) {
    print('Erreur lors de la récupération de l\'image (Web): $e');
    return null;
  }
}

Future<bool> deleteProfileImage(String userId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove('$_prefsKeyPrefix$userId');
  } catch (e) {
    print('Erreur lors de la suppression de l\'image (Web): $e');
    return false;
  }
}

Future<Uint8List?> getCurrentUserProfileImageBytes() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return null;
  return getProfileImageBytes(user.uid);
}
