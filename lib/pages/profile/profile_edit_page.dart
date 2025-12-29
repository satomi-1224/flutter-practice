import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_app/features/profile/controllers/profile_controller.dart';
import 'package:flutter_app/widgets/atoms/primary_button.dart';
import 'package:flutter_app/widgets/atoms/input_field.dart';
import 'package:gap/gap.dart';

class ProfileEditPage extends HookConsumerWidget {
  const ProfileEditPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileControllerProvider);
    final nameController = useTextEditingController();
    final emailController = useTextEditingController();

    // 初期値の設定
    useEffect(() {
      if (profileAsync.hasValue) {
        nameController.text = profileAsync.value!.name;
        emailController.text = profileAsync.value!.email;
      }
      return null;
    }, [profileAsync.hasValue]);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: profileAsync.when(
        data: (_) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              InputField(label: 'Name', controller: nameController),
              const Gap(16),
              InputField(label: 'Email', controller: emailController),
              const Gap(32),
              PrimaryButton(
                text: 'Save Changes',
                onPressed: () async {
                  await ref.read(profileControllerProvider.notifier).updateProfile(
                    name: nameController.text,
                    email: emailController.text,
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile Updated')));
                  }
                },
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
