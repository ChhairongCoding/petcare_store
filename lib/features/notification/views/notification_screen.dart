import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _buildBody()
    );
    
  }

  get _buildBody => Center(child: Text('Notifycation Screen'));
}