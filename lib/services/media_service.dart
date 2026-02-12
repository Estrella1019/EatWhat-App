import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:typed_data';
import 'dart:io';

/// 媒体服务 - 处理图片拍照、选择和压缩
class MediaService {
  final ImagePicker _picker = ImagePicker();

  // 压缩目标大小（字节）
  static const int _targetSizeBytes = 500 * 1024; // 500KB

  /// 从相机拍照
  Future<Uint8List?> takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (photo == null) return null;

      return await _compressImage(photo.path);
    } catch (e) {
      print('拍照失败: $e');
      return null;
    }
  }

  /// 从相册选择图片
  Future<Uint8List?> pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image == null) return null;

      return await _compressImage(image.path);
    } catch (e) {
      print('选择图片失败: $e');
      return null;
    }
  }

  /// 压缩图片到指定大小以下
  Future<Uint8List?> _compressImage(String filePath) async {
    try {
      File file = File(filePath);
      int fileSize = await file.length();

      print('原始图片大小: ${(fileSize / 1024).toStringAsFixed(2)} KB');

      // 如果已经小于目标大小，直接返回
      if (fileSize <= _targetSizeBytes) {
        Uint8List bytes = await file.readAsBytes();
        print('无需压缩，直接返回');
        return bytes;
      }

      // 计算压缩质量
      int quality = 85;
      Uint8List? compressedBytes;

      // 多次尝试压缩，直到满足大小要求
      while (quality > 10) {
        compressedBytes = await FlutterImageCompress.compressWithFile(
          filePath,
          quality: quality,
          minWidth: 1920,
          minHeight: 1080,
        );

        if (compressedBytes == null) break;

        int compressedSize = compressedBytes.length;
        print('压缩后大小 (质量$quality): ${(compressedSize / 1024).toStringAsFixed(2)} KB');

        if (compressedSize <= _targetSizeBytes) {
          print('压缩成功！最终大小: ${(compressedSize / 1024).toStringAsFixed(2)} KB');
          return compressedBytes;
        }

        quality -= 10;
      }

      // 如果还是太大，进一步降低分辨率
      if (compressedBytes != null && compressedBytes.length > _targetSizeBytes) {
        compressedBytes = await FlutterImageCompress.compressWithFile(
          filePath,
          quality: 70,
          minWidth: 1280,
          minHeight: 720,
        );
        print('进一步压缩后大小: ${(compressedBytes!.length / 1024).toStringAsFixed(2)} KB');
      }

      return compressedBytes;
    } catch (e) {
      print('压缩图片失败: $e');
      return null;
    }
  }

  /// 获取图片大小（KB）
  double getImageSizeKB(Uint8List bytes) {
    return bytes.length / 1024;
  }
}
