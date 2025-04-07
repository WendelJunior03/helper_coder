class Chat {
  final int? id;
  final String question;
  final String response;
  final DateTime timestamp;

  Chat({
    this.id,
    required this.question,
    required this.response,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'question': question,
        'response': response,
        'timestamp': timestamp.toIso8601String(),
      };

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json['id'],
        question: json['question'],
        response: json['response'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}