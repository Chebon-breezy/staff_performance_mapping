import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../../services/location_service.dart';
import '../../models/work_report_model.dart';

class SubmitReportScreen extends StatefulWidget {
  @override
  _SubmitReportScreenState createState() => _SubmitReportScreenState();
}

class _SubmitReportScreenState extends State<SubmitReportScreen> {
  final _formKey = GlobalKey<FormState>();
  String _taskDescription = '';
  final LocationService _locationService = LocationService();
  final DatabaseService _databaseService = DatabaseService();

  void _submitReport() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        final location = await _locationService.getCurrentLocation();
        final authService = Provider.of<AuthService>(context, listen: false);
        final report = WorkReportModel(
          id: '',
          userId: authService.currentUser!.uid,
          taskDescription: _taskDescription,
          timestamp: DateTime.now(),
          location: location,
        );
        await _databaseService.submitWorkReport(report);
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit report: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Submit Work Report')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Task Description'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a task description' : null,
                onSaved: (value) => _taskDescription = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Submit Report'),
                onPressed: _submitReport,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
