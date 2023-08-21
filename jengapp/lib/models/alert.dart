class Alert {
  final String activityType;
  final String activityTitle;
  final String activityCategory;
  final String activityMessage;
  final String activityTime;

  Alert({
    required this.activityType,
    required this.activityTitle,
    required this.activityCategory,
    required this.activityMessage,
    required this.activityTime,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      activityType: json['type'] ?? '',
      activityCategory: json['category'] ?? '',
      activityMessage: json['description'].toString() ?? '',
      activityTime: json['activityTime'] ?? '',
      activityTitle: json['activityTitle'] ?? '',
    );
  }
}
