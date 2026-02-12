import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../config/theme.dart';
import '../models/detection_result.dart';
import '../providers/pantry_provider.dart';
import 'pantry_screen.dart';

/// AR扫描演示页面（简化版，不使用真实摄像头）
class CameraScanDemoScreen extends StatefulWidget {
  const CameraScanDemoScreen({super.key});

  @override
  State<CameraScanDemoScreen> createState() => _CameraScanDemoScreenState();
}

class _CameraScanDemoScreenState extends State<CameraScanDemoScreen> {
  List<DetectionResult> _detections = [];
  bool _isScanning = false;
  Timer? _scanTimer;

  @override
  void initState() {
    super.initState();
    // 延迟1秒后开始模拟扫描
    Future.delayed(const Duration(seconds: 1), () {
      _startScanning();
    });
  }

  @override
  void dispose() {
    _scanTimer?.cancel();
    super.dispose();
  }

  /// 开始模拟扫描
  void _startScanning() {
    setState(() {
      _isScanning = true;
    });

    // 模拟逐个检测食材
    int count = 0;
    _scanTimer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (count >= _mockDetections.length) {
        timer.cancel();
        setState(() {
          _isScanning = false;
        });
        return;
      }

      setState(() {
        _detections.add(_mockDetections[count]);
      });
      count++;
    });
  }

  /// 模拟检测数据
  final List<DetectionResult> _mockDetections = [
    DetectionResult(
      label: '番茄',
      confidence: 0.95,
      bbox: BoundingBox(x: 100, y: 150, width: 120, height: 110),
    ),
    DetectionResult(
      label: '鸡蛋',
      confidence: 0.92,
      bbox: BoundingBox(x: 250, y: 200, width: 100, height: 90),
    ),
    DetectionResult(
      label: '黄瓜',
      confidence: 0.88,
      bbox: BoundingBox(x: 150, y: 350, width: 140, height: 130),
    ),
    DetectionResult(
      label: '五花肉',
      confidence: 0.90,
      bbox: BoundingBox(x: 300, y: 100, width: 110, height: 100),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 模拟摄像头预览
          _buildCameraPreview(),

          // AR叠加层
          if (_detections.isNotEmpty) _buildAROverlay(),

          // 顶部栏
          _buildTopBar(),

          // 底部检测列表
          _buildDetectionList(),

          // 确认按钮
          if (_detections.isNotEmpty && !_isScanning) _buildConfirmButton(),
        ],
      ),
    );
  }

  /// 模拟摄像头预览
  Widget _buildCameraPreview() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.grey[800]!,
            Colors.grey[900]!,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 100,
              color: Colors.white.withOpacity(0.3),
            ),
            const SizedBox(height: 20),
            Text(
              '模拟AR扫描演示',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '（真实版本需要摄像头权限）',
              style: TextStyle(
                color: Colors.white.withOpacity(0.3),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// AR叠加层
  Widget _buildAROverlay() {
    return CustomPaint(
      painter: AROverlayPainter(_detections),
      size: Size.infinite,
    );
  }

  /// 顶部栏
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
            if (_isScanning)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '扫描中...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 底部检测列表
  Widget _buildDetectionList() {
    if (_detections.isEmpty) return const SizedBox.shrink();

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
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
                '已检测到 ${_detections.length} 种食材',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
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
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    label: Text(detection.label),
                    backgroundColor: Colors.white,
                  );
                }).toList(),
              ),
              const SizedBox(height: 80), // 为确认按钮留空间
            ],
          ),
        ),
      ),
    );
  }

  /// 确认按钮
  Widget _buildConfirmButton() {
    return Positioned(
      left: 20,
      right: 20,
      bottom: 40,
      child: SafeArea(
        child: ElevatedButton(
          onPressed: _confirmAndSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.secondaryColor,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline, size: 24),
              SizedBox(width: 12),
              Text(
                '确认并保存到冰箱',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 确认并保存
  Future<void> _confirmAndSave() async {
    final pantryProvider = Provider.of<PantryProvider>(context, listen: false);

    // 保存到虚拟冰箱
    await pantryProvider.addFromDetections(_detections);

    if (mounted) {
      // 显示成功提示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('已添加 ${_detections.length} 种食材到冰箱'),
          backgroundColor: Colors.green,
        ),
      );

      // 跳转到冰箱页面
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PantryScreen()),
      );
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

      // 绘制边界框
      final boxPaint = Paint()
        ..color = AppTheme.detectionBox
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;

      final rect = Rect.fromLTWH(bbox.x, bbox.y, bbox.width, bbox.height);
      canvas.drawRect(rect, boxPaint);

      // 绘制标签背景
      final labelBgPaint = Paint()..color = AppTheme.detectionLabel;

      final labelText = '${detection.label} ${(detection.confidence * 100).toInt()}%';
      final textPainter = TextPainter(
        text: TextSpan(
          text: labelText,
          style: const TextStyle(
            color: AppTheme.primaryColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final labelRect = Rect.fromLTWH(
        bbox.x,
        bbox.y - 28,
        textPainter.width + 16,
        24,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(labelRect, const Radius.circular(4)),
        labelBgPaint,
      );

      // 绘制标签文字
      textPainter.paint(canvas, Offset(bbox.x + 8, bbox.y - 26));
    }
  }

  @override
  bool shouldRepaint(AROverlayPainter oldDelegate) => true;
}
