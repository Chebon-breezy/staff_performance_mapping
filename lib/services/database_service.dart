import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/work_report_model.dart';
import '../models/user_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> submitWorkReport(WorkReportModel report) async {
    try {
      await _firestore.collection('work_reports').add(report.toMap());
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Stream<List<WorkReportModel>> getWorkReports(String userId) {
    return _firestore
        .collection('work_reports')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => WorkReportModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Stream<List<UserModel>> getAllUsers() {
    return _firestore.collection('users').snapshots().map((snapshot) => snapshot
        .docs
        .map((doc) => UserModel.fromMap(doc.data(), doc.id))
        .toList());
  }

  Future<void> updateUserRole(String userId, String newRole) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .update({'role': newRole});
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
