import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../models/detection_result.dart';
import '../providers/pantry_provider.dart';
import '../providers/global_provider.dart';
import '../providers/user_provider.dart';
import '../services/media_service.dart';
import 'pantry_screen.dart';
import 'result_screen.dart';

/// AR扫描页面 - 调用后端YOLO识别真实食材
class CameraScanDemoScreen extends StatefulWidget {
  const CameraScanDemoScreen({super.key});

  @override
  State<CameraScanDemoScreen> createState() => _CameraScanDemoScreenState();
}

class _CameraScanDemoScreenState extends State<CameraScanDemoScreen> {
  List<DetectionResult> _detections = [];
  bool _isScanning = false;
  bool _hasImage = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      _pickAndRecognize();
    });
  }

  /// 选择图片并调用后端YOLO识别
  Future<void> _pickAndRecognize() async {
    final mediaService = MediaService();
    final imageBytes = await mediaService.pickFromGallery();

    if (imageBytes == null) {
      if (mounted) Navigator.pop(context);
      return;
    }

    setState(() {
      _isScanning = true;
      _hasImage = true;
      _errorMessage = null;
      _detections = [];
    });

    try {
      final globalProvider = Provider.of<GlobalProvider>(context, listen: false);
      final ingredients = await globalProvider.identifyIngredientsOnly(
        imageBytes: imageBytes,
      );

      final detections = ingredients.map((ingredient) {
        return DetectionResult(
          label: ingredient.name,
          confidence: ingredient.confidence,
          bbox: ingredient.bbox != null && ingredient.bbox!.length >= 4
              ? BoundingBox(
                  x: ingredient.bbox![0],
                  y: ingredient.bbox![1],
                  width: ingredient.bbox![2] - ingredient.bbox![0],
                  height: ingredient.bbox![3] - ingredient.bbox![1],
                )
              : BoundingBox(x: 50, y: 50, width: 100, height: 100),
        );
      }).toList();

      setState(() {
        _detections = detections;
        _isScanning = false;
      });
    } catch (e) {
      setState(() {
        _isScanning = false;
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildCameraPreview(),
          if (_detections.isNotEmpty) _buildAROverlay(),
          _buildTopBar(),
          if (_isScanning) _buildScanningIndicator(),
          if (_errorMessage != null) _buildErrorView(),
          if (_detections.isNotEmpty && !_isScanning) _buildDetectionList(),
          if (_detections.isNotEmpty && !_isScanning) _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.grey[800]!, Colors.grey[900]!],
        ),
      ),
      child: _hasImage
          ? null
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt_outlined,
                      size: 100,
                      color: Colors.white.withValues(alpha: 0.3)),
                  const SizedBox(height: 20),
                  Text('请选择图片进行识别',
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 18)),
                ],
              ),
            ),
    );
  }

  Widget _buildAROverlay() {
    return CustomPaint(
      painter: AROverlayPainter(_detections),
      size: Size.infinite,
    );
  }

  Widget _buildTopBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 32),
              onPressed: () => Navigator.pop(context),
            ),
            if (!_isScanning && _hasImage)
              TextButton.icon(
                onPressed: _pickAndRecognize,
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text('重新选图',
                    style: TextStyle(color: Colors.white)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanningIndicator() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
            SizedBox(height: 16),
            Text('YOLO识别中...',
                style: TextStyle(color: Colors.white, fontSize: 16)),
            SizedBox(height: 4),
            Text('正在调用后端识别食材',
                style: TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(_errorMessage!,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: _pickAndRecognize, child: const Text('重试')),
          ],
        ),
      ),
    );
  }

  Widget _buildDetectionList() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '已识别到 ${_detections.length} 种食材',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _detections.map((detection) {
                  return Chip(
                    avatar: CircleAvatar(
                      backgroundColor: AppTheme.accentColor,
                      child: Text(
                        '${(detection.confidence * 100).toInt()}%',
                        style: const TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                    label: Text(detection.label),
                    backgroundColor: Colors.white,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Positioned(
      left: 20,
      right: 20,
      bottom: 30,
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _saveToFridge,
                icon: const Icon(Icons.kitchen, size: 20),
                label: const Text('存入冰箱'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _generateRecipes,
                icon: const Icon(Icons.restaurant_menu, size: 20),
                label: const Text('生成菜谱'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveToFridge() async {
    final pantryProvider = Provider.of<PantryProvider>(context, listen: false);
    await pantryProvider.addFromDetections(_detections);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('已添加 ${_detections.length} 种食材到冰箱'),
        backgroundColor: Colors.green,
      ));
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const PantryScreen()));
    }
  }

  Future<void> _generateRecipes() async {
    final globalProvider = Provider.of<GlobalProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('生成菜谱中...'),
            ]),
          ),
        ),
      ),
    );

    try {
      final ingredientNames = _detections.map((d) => d.label).toList();
      await globalProvider.generateRecipesFromIngredients(
        ingredients: ingredientNames,
        allergens: userProvider.user.allergens,
        servings: userProvider.user.defaultServings,
        preferences: userProvider.user.preferences,
      );
      if (mounted) {
        Navigator.pop(context);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const ResultScreen()));
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('生成失败: $e')));
      }
    }
  }
}

/// AR叠加层绘制器
class AROverlayPainter extends CustomPainter {
  final List<DetectionResult> detections;
  AROverlayPainter(this.detections);

  @override
  void paint(Canvas canvas, Size size) {
    for (var detection in detections) {
      final bbox = detection.bbox;
      final boxPaint = Paint()
        ..color = AppTheme.detectionBox
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;
      canvas.drawRect(
          Rect.fromLTWH(bbox.x, bbox.y, bbox.width, bbox.height), boxPaint);

      final labelBgPaint = Paint()..color = AppTheme.detectionLabel;
      final labelText =
          '${detection.label} ${(detection.confidence * 100).toInt()}%';
      final textPainter = TextPainter(
        text: TextSpan(
          text: labelText,
          style: const TextStyle(
              color: AppTheme.primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH(bbox.x, bbox.y - 28, textPainter.width + 16, 24),
              const Radius.circular(4)),
          labelBgPaint);
      textPainter.paint(canvas, Offset(bbox.x + 8, bbox.y - 26));
    }
  }

  @override
  bool shouldRepaint(AROverlayPainter oldDelegate) => true;
}
