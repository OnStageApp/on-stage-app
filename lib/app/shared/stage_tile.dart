import 'package:flutter/material.dart';

class StageTile extends StatelessWidget {
  const StageTile({
    required this.title,
    required this.description,
    this.icon,
    this.trailing,
    this.backgroundGradient,
    this.backgroundImage,
    super.key,
  });

  final Widget? icon;
  final String title;
  final String description;
  final Widget? trailing;
  final Gradient? backgroundGradient;
  final ImageProvider? backgroundImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        gradient: backgroundGradient,
        image: backgroundImage != null
            ? DecorationImage(
                image: backgroundImage!,
                fit: BoxFit.cover,
                opacity: 0.1,
                colorFilter: const ColorFilter.mode(
                  Colors.blue,
                  BlendMode.overlay,
                ),
              )
            : null,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: icon,
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: backgroundImage != null
                      ? Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.white)
                      : Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                ),
                Text(
                  description,
                  style: backgroundImage != null
                      ? Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.white)
                      : Theme.of(context).textTheme.bodyMedium,
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
