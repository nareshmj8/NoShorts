class CategoryItem {
  final String title;
  final String description;
  final String? emoji;

  CategoryItem({required this.title, required this.description, this.emoji});

  factory CategoryItem.fromMap(Map<String, dynamic> map) {
    return CategoryItem(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      emoji: map['emoji'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      if (emoji != null) 'emoji': emoji,
    };
  }
}
