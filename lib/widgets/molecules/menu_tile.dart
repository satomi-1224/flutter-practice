import 'package:flutter/material.dart';

class MenuTile extends StatelessWidget {
  const MenuTile({
    super.key,
    required this.title,
    this.leadingIcon,
    this.trailingText,
    this.onTap,
    this.titleColor,
    this.showChevron = true,
  });

  final String title;
  final IconData? leadingIcon;
  final String? trailingText;
  final VoidCallback? onTap;
  final Color? titleColor;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: leadingIcon != null ? Icon(leadingIcon, color: titleColor ?? Colors.black54) : null,
          title: Text(
            title,
            style: TextStyle(color: titleColor),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (trailingText != null)
                Text(
                  trailingText!,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
              if (showChevron)
                const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
          onTap: onTap,
        ),
        const Divider(height: 1, indent: 56),
      ],
    );
  }
}
