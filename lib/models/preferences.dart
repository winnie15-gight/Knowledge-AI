class TutorPreferences {
  String personality;
  String style;
  String length;
  String interests;
  String instructions;
  String theme;

  TutorPreferences({
    this.personality = 'Friendly',
    this.style = 'Casual',
    this.length = 'Balanced',
    this.interests = '',
    this.instructions = '',
    this.theme = 'dark',
  });

  factory TutorPreferences.fromJson(Map<String, dynamic> json) {
    return TutorPreferences(
      personality: json['personality'] ?? 'Friendly',
      style: json['style'] ?? 'Casual',
      length: json['length'] ?? 'Balanced',
      interests: json['interests'] ?? '',
      instructions: json['instructions'] ?? '',
      theme: json['theme'] ?? 'dark',
    );
  }

  Map<String, dynamic> toJson() => {
    'personality': personality,
    'style': style,
    'length': length,
    'interests': interests,
    'instructions': instructions,
    'theme': theme,
  };
}
