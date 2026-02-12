/// 边界框
class BoundingBox {
  final double x;
  final double y;
  final double width;
  final double height;

  BoundingBox({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  factory BoundingBox.fromJson(Map<String, dynamic> json) {
    return BoundingBox(
      x: (json['x'] as num?)?.toDouble() ?? 0.0,
      y: (json['y'] as num?)?.toDouble() ?? 0.0,
      width: (json['width'] as num?)?.toDouble() ?? 0.0,
      height: (json['height'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
      'width': width,
      'height': height,
    };
  }
}

/// 实时检测结果
class DetectionResult {
  final String label;
  final double confidence;
  final BoundingBox bbox;
  final DateTime timestamp;

  DetectionResult({
    required this.label,
    required this.confidence,
    required this.bbox,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory DetectionResult.fromJson(Map<String, dynamic> json) {
    return DetectionResult(
      label: json['label']?.toString() ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      bbox: BoundingBox.fromJson(json['bbox'] ?? {}),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'confidence': confidence,
      'bbox': bbox.toJson(),
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
