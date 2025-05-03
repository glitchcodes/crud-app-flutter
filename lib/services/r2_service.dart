import 'dart:io';

import 'package:cloudflare_r2/cloudflare_r2.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mime/mime.dart';

class R2Service {
  final String bucketName;

  R2Service({
    required this.bucketName
  });

  Future<void> initialize() async {
    await CloudFlareR2.init(
        accoundId: dotenv.env['R2_ACCOUNT_ID']!,
        accessKeyId: dotenv.env['R2_ACCESS_KEY_ID']!,
        secretAccessKey: dotenv.env['R2_ACCESS_KEY_SECRET']!
    );
  }

  Future<String?> uploadFile(File file, String fileName) async {
    try {
      final fileBytes = await file.readAsBytes();

      await CloudFlareR2.putObject(
        bucket: bucketName,
        objectName: fileName,
        objectBytes: fileBytes,
        contentType: lookupMimeType(file.path) ?? 'image/jpeg'
      );

      return 'https://pub-f21cfccf02354128a38fd774ad4618c1.r2.dev/$fileName';
    } catch (e) {
      debugPrint('Upload error: $e');
      return null;
    }
  }

  Future<bool> deleteFile(String fileName) async {
    try {
      await CloudFlareR2.deleteObject(
        bucket: bucketName,
        objectName: fileName
      );
      return true;
    } catch (e) {
      debugPrint('Delete error: $e');
      return false;
    }
  }
}