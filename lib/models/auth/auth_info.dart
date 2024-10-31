class AuthInfo {
  String authorizeUrl;
  String deviceCodeUrl;
  String tokenUrl;
  String clientId;

  AuthInfo({
    required this.authorizeUrl,
    required this.deviceCodeUrl,
    required this.tokenUrl,
    required this.clientId,
  });

  factory AuthInfo.fromJson(Map<String, dynamic> json) {
    return AuthInfo(
      authorizeUrl: json['authorizeUrl'] as String,
      deviceCodeUrl: json['deviceCodeUrl'] as String,
      tokenUrl: json['tokenUrl'] as String,
      clientId: json['clientId'] as String,
    );
  }

  // Method for converting an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'authorizeUrl': authorizeUrl,
      'deviceCodeUrl': deviceCodeUrl,
      'tokenUrl': tokenUrl,
      'clientId': clientId,
    };
  }
}