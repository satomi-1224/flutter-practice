import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock notifications
    final notifications = List.generate(10, (index) {
      return {
        'title': '事務局からのお知らせ',
        'body': '【重要】バージョンアップのお知らせ $index',
        'time': '${index + 1}時間前',
        'isRead': index > 2,
      };
    });

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('お知らせ'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'お知らせ'),
              Tab(text: 'ニュース'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                return _NotificationTile(
                  title: item['title'] as String,
                  body: item['body'] as String,
                  time: item['time'] as String,
                  isRead: item['isRead'] as bool,
                );
              },
            ),
            const Center(child: Text('ニュースはありません')),
          ],
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.title,
    required this.body,
    required this.time,
    required this.isRead,
  });

  final String title;
  final String body;
  final String time;
  final bool isRead;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.red,
            child: Icon(Icons.notifications, color: Colors.white, size: 20),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(body, maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text(time, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
          tileColor: isRead ? null : Colors.red.withAlpha(13),
          onTap: () {},
        ),
        const Divider(height: 1, indent: 72),
      ],
    );
  }
}
