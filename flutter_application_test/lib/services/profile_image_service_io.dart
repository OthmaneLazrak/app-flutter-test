import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

const String _profileDir = 'profile_images';

Future<Directory> _getProfileDirectory() async {
  final appDir = await getApplicationDocumentsDirectory();
  final profileDirectory = Directory('${appDir.path}/$_profileDir');

  if (!await profileDirectory.exists()) {
    await profileDirectory.create(recursive: true);
  }

  return profileDirectory;
}

Future<String> _getUserProfilePath(String userId) async {
  final dir = await _getProfileDirectory();
  return '${dir.path}/$userId.jpg';
}

Future<bool> saveProfileImageBytes(Uint8List bytes, String userId) async {
  try {
    final path = await _getUserProfilePath(userId);
    final file = File(path);
    await file.writeAsBytes(bytes, flush: true);
    return true;
  } catch (e) {
    print('Erreur lors de la sauvegarde de l\'image (IO): $e');
    return false;
  }
}

Future<Uint8List?> getProfileImageBytes(String userId) async {
  try {
    final path = await _getUserProfilePath(userId);
    final file = File(path);
    if (await file.exists()) {
      return await file.readAsBytes();
    }
    return null;
  } catch (e) {
    print('Erreur lors de la récupération de l\'image (IO): $e');
    return null;
  }
}

Future<bool> deleteProfileImage(String userId) async {
  try {
    final path = await _getUserProfilePath(userId);
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
      return true;
    }
    return false;
  } catch (e) {
    print('Erreur lors de la suppression de l\'image (IO): $e');
    return false;
  }
}

Future<Uint8List?> getCurrentUserProfileImageBytes() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return null;
  return getProfileImageBytes(user.uid);
}
