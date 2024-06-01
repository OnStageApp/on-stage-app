import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/vocal_lead_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class PreferencesVocalLead extends StatelessWidget {
  const PreferencesVocalLead({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vocal Lead',
          style: context.textTheme.labelLarge,
        ),
        const SizedBox(height: Insets.small),
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return _buildVocal(context);
                },
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: InkWell(
                onTap: () {
                  VocalLeadModal.show(context: context);
                },
                child: Container(
                  height: 30,
                  width: 30,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    color: const Color(0xFFF4F4F4),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Color(0xFF828282),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVocal(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: Row(
        children: [
          Image.asset('assets/images/profile1.png', width: 24, height: 24),
          const SizedBox(width: 6),
          Text('Marcelo', style: context.textTheme.bodyLarge),
          const SizedBox(width: 2),
        ],
      ),
    );
  }
}
