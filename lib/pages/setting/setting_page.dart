import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_app/features/auth/controllers/auth_controller.dart';
import 'package:flutter_app/widgets/atoms/primary_button.dart';

class SettingPage extends ConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ListTile(
            leading: Icon(Icons.dark_mode),
            title: Text('Dark Mode'),
            trailing: Switch(
              value: false, 
              onChanged: null, // TODO: Implement ThemeController
            ),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
            trailing: Text('English'),
          ),
          const Divider(),
          const Gap(32),
          PrimaryButton(
            text: 'Logout',
            onPressed: () {
              ref.read(authControllerProvider.notifier).logout();
              context.go('/auth/login');
            },
          ),
        ],
      ),
    );
  }
}
