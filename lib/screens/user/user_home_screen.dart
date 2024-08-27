import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../../models/work_report_model.dart';
import 'submit_report_screen.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final databaseService = DatabaseService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => authService.signOut(),
          ),
        ],
      ),
      body: StreamBuilder<List<WorkReportModel>>(
        stream: databaseService.getWorkReports(authService.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No work reports submitted yet.'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              WorkReportModel report = snapshot.data![index];
              return ListTile(
                title: Text(report.taskDescription),
                subtitle: Text(
                    '${report.timestamp.toString()} - Location: (${report.location.latitude}, ${report.location.longitude})'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SubmitReportScreen()),
          );
        },
      ),
    );
  }
}
