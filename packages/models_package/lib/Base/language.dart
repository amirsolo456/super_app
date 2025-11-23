class Language {
  const Language({
    this.id = 0,
    this.smallName,
    this.bigName,
    this.completeName,
    this.countryCode,
    this.languageCode,
  });

  final int id;
  final String? smallName;
  final String? bigName;
  final String? completeName;
  final int? countryCode;
  final int? languageCode;

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: json['id'] ?? 0,
      smallName: json['smallName'] as String?,
      bigName: json['bigName'] as String?,
      completeName: json['completeName'] as String?,
      countryCode: json['countryCode'] as int ?? 0,
      languageCode: json['languageCode'] as int ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'smallName': smallName,
    'bigName': bigName,
    'completeName': completeName,
    'countryCode': countryCode,
    'languageCode': languageCode,
    // 'v': 1, // در صورت نیاز برای ورژن‌دهی
  };

  Language copyWith({
    int? id,
    String? smallName,
    String? bigName,
    String? completeName,
    int? countryCode,
    int? languageCode,
  }) {
    return Language(
      id: id ?? this.id,
      smallName: smallName ?? this.smallName,
      bigName: bigName ?? this.bigName,
      completeName: completeName ?? this.completeName,
      countryCode: countryCode ?? this.countryCode,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Language &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              smallName == other.smallName &&
              bigName == other.bigName &&
              completeName == other.completeName &&
              countryCode == other.countryCode &&
              languageCode == other.languageCode;

  @override
  int get hashCode =>
      id.hashCode ^
      (smallName?.hashCode ?? 0) ^
      (bigName?.hashCode ?? 0) ^
      (completeName?.hashCode ?? 0) ^
      (countryCode?.hashCode ?? 0) ^
      (languageCode?.hashCode ?? 0);
}
