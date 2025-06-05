class ReactionEvent {
  final int? id; // antes: int id;
  final int sessionId;
  final int timestamp;
  final int reactionTime;
  final String type;

  ReactionEvent({
    this.id, // ahora es opcional
    required this.sessionId,
    required this.timestamp,
    required this.reactionTime,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'timestamp': timestamp,
      'reactionTime': reactionTime,
      'type': type,
    };
  }

  factory ReactionEvent.fromMap(Map<String, dynamic> map) {
    return ReactionEvent(
      id: map['id'],
      sessionId: map['sessionId'],
      timestamp: map['timestamp'],
      reactionTime: map['reactionTime'],
      type: map['type'],
    );
  }
}
