import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event_template/application/event_templates_notifier.dart';
import 'package:on_stage_app/app/features/event_template/domain/event_template.dart';
import 'package:on_stage_app/app/features/event_template/presentation/widgets/event_template_tile.dart';
import 'package:on_stage_app/app/features/groups/group_template/presentation/create_group_modal.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/add_new_button.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class EventTemplatesScreen extends ConsumerStatefulWidget {
  const EventTemplatesScreen({super.key});

  @override
  EventTemplatesScreenState createState() => EventTemplatesScreenState();
}

class EventTemplatesScreenState extends ConsumerState<EventTemplatesScreen> {
  List<EventTemplate> eventTemplates = [
    const EventTemplate(
      id: '1',
      name: 'Duminică dimineata',
      location: 'Biserica Betania Oradea',
      reminderDays: [1, 2, 7],
    ),
    const EventTemplate(
      id: '2',
      name: 'Duminică seara',
      location: 'Biserica Betania Oradea',
      reminderDays: [1, 2, 7],
    ),
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ref.read(eventTemplatesNotifierProvider.notifier).getEventTemplates();
    });
    super.initState();
  }

  // void _setupErrorListener() {
  //   ref.listen<GroupTemplateState>(
  //     groupTemplateNotifierProvider,
  //         (previous, next) {
  //       if (next.error != null && mounted) {
  //         TopFlushBar.show(
  //           context,
  //           next.error.toString(),
  //           isError: true,
  //         );
  //       }
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // _setupErrorListener();

    return Padding(
      padding: getResponsivePadding(context),
      child: Scaffold(
        appBar: StageAppBar(
          title: 'Event Templates',
          isBackButtonVisible: true,
          trailing: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: AddNewButton(
              onPressed: () {
                CreateGroupModal.show(context: context);
              },
            ),
          ),
        ),
        body: RefreshIndicator.adaptive(
          onRefresh: () async {
            await ref
                .read(eventTemplatesNotifierProvider.notifier)
                .getEventTemplates();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ListView.builder(
              itemCount: 2,
              itemBuilder: (context, index) {
                return EventTemplateTile(
                  title: eventTemplates[index].name ?? '',
                  location: eventTemplates[index].location ?? '',
                  onTap: () {
                    context.pushNamed(
                      AppRoute.eventTemplateDetails.name,
                      extra: eventTemplates[index],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
