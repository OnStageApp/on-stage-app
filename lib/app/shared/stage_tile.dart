import 'package:flutter/material.dart';

class StageTile extends StatelessWidget {
  const StageTile({
    required this.title,
    required this.description,
    required this.trailing,
    super.key,
  });

  final String title;
  final String description;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
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
                const SizedBox(height: 8),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          trailing,
          const Divider(),
        ],
      ),
    );
  }
}
