import 'package:flutter/material.dart';

class StageTile extends StatelessWidget {
  const StageTile({
    required this.title,
    required this.description,
    this.icon,
    this.trailing,
    super.key,
  });

  final Widget? icon;
  final String title;
  final String description;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          trailing ?? const SizedBox(),
          const Divider(),
        ],
      ),
    );
  }
}
