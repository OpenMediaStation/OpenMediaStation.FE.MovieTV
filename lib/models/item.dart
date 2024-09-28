
class Item {
  final String id;
  final String title;
  final String path;
  final String category;

  Item({
    required this.id,
    required this.title,
    required this.path,
    required this.category,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as String,
      title: json['title'] as String,
      path: json['path'] as String,
      category: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'path': path,
      'category': category,
    };
  }
}