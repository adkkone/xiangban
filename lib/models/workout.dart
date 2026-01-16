class Workout {
  final String id;
  final String title;
  final String description;
  final int duration;
  final String intensity;
  final String imageUrl;
  final String category;

  Workout({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.intensity,
    required this.imageUrl,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'duration': duration,
      'intensity': intensity,
      'imageUrl': imageUrl,
      'category': category,
    };
  }

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      duration: json['duration'] as int,
      intensity: json['intensity'] as String,
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
    );
  }
}
