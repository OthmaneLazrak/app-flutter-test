// Cross-platform profile image service.
// Uses a conditional implementation: file storage on mobile/desktop, SharedPreferences (base64) on web.
import 'dart:typed_data';

import 'profile_image_service_io.dart'
    if (dart.library.html) 'profile_image_service_web.dart' as impl;

class ProfileImageService {
  static Future<bool> saveProfileImageBytes(Uint8List bytes, String userId) =>
      impl.saveProfileImageBytes(bytes, userId);

  static Future<Uint8List?> getProfileImageBytes(String userId) =>
      impl.getProfileImageBytes(userId);

  static Future<bool> deleteProfileImage(String userId) =>
      impl.deleteProfileImage(userId);

  static Future<Uint8List?> getCurrentUserProfileImageBytes() =>
      impl.getCurrentUserProfileImageBytes();
}
