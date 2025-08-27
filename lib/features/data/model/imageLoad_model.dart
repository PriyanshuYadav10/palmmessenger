class ImageLoadModel {
  final bool success;
  final String url;

  ImageLoadModel({required this.success, required this.url});

  factory ImageLoadModel.fromJson(Map<String, dynamic> json) {
    return ImageLoadModel(
      success: json['success'] ?? false,
      url: json['url'] ?? '',
    );
  }
}
