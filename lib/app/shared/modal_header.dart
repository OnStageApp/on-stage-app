import 'package:flutter/material.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ModalHeader extends StatelessWidget {
  const ModalHeader({
    required this.title,
    this.leadingButton = const SizedBox(
      width: 80 - 12,
    ),
    super.key,
  });

  final String title;
  final Widget leadingButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(24),
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 82,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(height: Insets.normal),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                leadingButton,
                Expanded(
                  child: Text(
                    title,
                    style: context.textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: InkWell(
                    onTap: () {
                      context.popDialog();
                    },
                    child: Center(
                      child: Container(
                        width: 30,
                        height: 30,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFE4E4E4),
                          ),
                        ),
                        child: const Icon(Icons.close, size: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Insets.smallNormal),
          const Divider(
            color: Color(0xFFE4E4E4),
            height: 0,
          ),
        ],
      ),
    );
  }
}
