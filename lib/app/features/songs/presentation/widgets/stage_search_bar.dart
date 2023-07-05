import 'package:flutter/material.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class StageSearchBar extends StatelessWidget {
  const StageSearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      shadowColor: MaterialStateColor.resolveWith(
        (states) => Colors.transparent,
      ),
      backgroundColor: MaterialStateColor.resolveWith(
        (states) => context.colorScheme.surfaceVariant,
      ),
      trailing: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Icon(
            Icons.search,
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
      hintText: 'Search',
      onChanged: (value) {},
    );
  }
}
