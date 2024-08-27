import 'package:cloud_firestore/cloud_firestore.dart';

class WorkReportModel {
  final String id;
  final String userId;
  final String taskDescription;
  final DateTime timestamp;
  final GeoPoint location;

  WorkReportModel({
    required this.id,
    required this.userId,
    required this.taskDescription,
    required this.timestamp,
    required this.location,
  });

  factory WorkReportModel.fromMap(Map<String, dynamic> data, String id) {
    return WorkReportModel(
      id: id,
      userId: data['userId'] ?? '',
      taskDescription: data['taskDescription'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      location: data['location'] ?? GeoPoint(0, 0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'taskDescription': taskDescription,
      'timestamp': Timestamp.fromDate(timestamp),
      'location': location,
    };
  }
}
