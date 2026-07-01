import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../providers/alarm_provider.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AlarmProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Required Steps"),
            subtitle: Text("${provider.requiredSteps} steps to stop alarm"),
            trailing: SizedBox(
              width: 150,
              child: Slider(
                value: provider.requiredSteps.toDouble(),
                min: 10,
                max: 100,
                divisions: 9,
                label: provider.requiredSteps.toString(),
                onChanged: (value) {
                  provider.setRequiredSteps(value.toInt());
                },
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text("Permissions"),
            subtitle: const Text("Ensure Activity Recognition is allowed"),
            onTap: () async {
              await Permission.activityRecognition.request();
              await Permission.notification.request();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Permissions requested")),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

