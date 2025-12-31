import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/controllers/auth_controller.dart';
import '../../widgets/atoms/section_header.dart';
import '../../widgets/molecules/menu_tile.dart';

class MyPagePage extends ConsumerWidget {
  const MyPagePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.value;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('マイページ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User Profile Header
            _UserProfileHeader(
              name: user.name,
              avatarUrl: user.avatarUrl,
            ),
            const SizedBox(height: 8),

            // Sales & Points
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  MenuTile(
                    title: '売上金',
                    trailingText: '¥ 12,345',
                    showChevron: true,
                    onTap: () {},
                  ),
                  MenuTile(
                    title: 'ポイント',
                    trailingText: 'P 500',
                    showChevron: true,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // History
            const SectionHeader(title: '出品・購入'),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  MenuTile(leadingIcon: Icons.storefront, title: '出品した商品', onTap: () {}),
                  MenuTile(leadingIcon: Icons.shopping_bag_outlined, title: '購入した商品', onTap: () {}),
                  MenuTile(leadingIcon: Icons.favorite_border, title: 'いいね！した商品', onTap: () {}),
                  MenuTile(leadingIcon: Icons.history, title: '閲覧履歴', onTap: () {}),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Settings & Support
            const SectionHeader(title: '設定・サポート'),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  MenuTile(leadingIcon: Icons.person_outline, title: 'プロフィール設定', onTap: () {}),
                  MenuTile(leadingIcon: Icons.credit_card, title: '支払い方法', onTap: () {}),
                  MenuTile(leadingIcon: Icons.help_outline, title: 'ヘルプセンター', onTap: () {}),
                  MenuTile(leadingIcon: Icons.mail_outline, title: 'お問い合わせ', onTap: () {}),
                  
                  // Logout Tile
                  MenuTile(
                    leadingIcon: Icons.logout,
                    title: 'ログアウト',
                    titleColor: Colors.red,
                    showChevron: false,
                    onTap: () => _showLogoutDialog(context, ref),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ログアウト'),
        content: const Text('ログアウトしますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authControllerProvider.notifier).logout();
            },
            child: const Text('ログアウト', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// Internal private widget for header to keep build method clean
class _UserProfileHeader extends StatelessWidget {
  const _UserProfileHeader({required this.name, this.avatarUrl});

  final String name;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
            child: avatarUrl == null ? const Icon(Icons.person, size: 40) : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Row(
                  children: [
                    Icon(Icons.star, size: 16, color: Colors.amber),
                    Text(' 4.8 (120)'),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
