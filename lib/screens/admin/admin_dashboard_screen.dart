import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../../models/user_model.dart';
import 'user_details_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  final DatabaseService _databaseService = DatabaseService();

  AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => authService.signOut(),
          ),
        ],
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: _databaseService.getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found.'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              UserModel user = snapshot.data![index];
              return ListTile(
                title: Text(user.name),
                subtitle: Text('${user.email} - Role: ${user.role}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserDetailsScreen(user: user),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
