class InventoryItemAddonSubtitle {
  final String? language;

  InventoryItemAddonSubtitle({
    this.language,
  });

  factory InventoryItemAddonSubtitle.fromJson(Map<String, dynamic> json) {
    return InventoryItemAddonSubtitle(
      language: json['language'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language': language,
    };
  }
}
