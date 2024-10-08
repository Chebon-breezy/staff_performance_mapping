import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../models/work_report_model.dart';
import '../../services/database_service.dart';

class UserDetailsScreen extends StatelessWidget {
  final UserModel user;
  final DatabaseService _databaseService = DatabaseService();

  UserDetailsScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details: ${user.name}'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${user.name}'),
                Text('Email: ${user.email}'),
                Text('Role: ${user.role}'),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: const Text('Change Role'),
                  onPressed: () => _showChangeRoleDialog(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<WorkReportModel>>(
              stream: _databaseService.getWorkReports(user.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No work reports found for this user.'));
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
          ),
        ],
      ),
    );
  }

  void _showChangeRoleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newRole = user.role;
        return AlertDialog(
          title: const Text('Change User Role'),
          content: DropdownButton<String>(
            value: newRole,
            items: ['user', 'admin'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? value) {
              if (value != null) {
                newRole = value;
              }
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                await _databaseService.updateUserRole(user.id, newRole);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
