import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:on_stage_app/app/features/event_template/event_template/application/current_event_template_notifier.dart';
import 'package:on_stage_app/app/features/event_template/event_template/application/event_templates_notifier.dart';
import 'package:on_stage_app/app/features/event_template/event_template/presentation/widgets/event_template_tile.dart';
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
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(eventTemplatesNotifierProvider.notifier).getEventTemplates();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final eventTemplates =
        ref.watch(eventTemplatesNotifierProvider).eventTemplates;
    return Padding(
      padding: getResponsivePadding(context),
      child: Scaffold(
        appBar: StageAppBar(
          title: 'Event Templates',
          isBackButtonVisible: true,
          trailing: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: AddNewButton(
              onPressed: () async {
                final savedTemplate = await ref
                    .read(currentEventTemplateProvider.notifier)
                    .createEmptyEventTemplate();
                if (context.mounted) {
                  unawaited(
                    context.pushNamed(
                      AppRoute.eventTemplateDetails.name,
                      extra: savedTemplate,
                      queryParameters: {'isNew': 'true'},
                    ),
                  );
                }
              },
            ),
          ),
        ),
        body: eventTemplates.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/folders_v2.svg',
                      colorFilter: ColorFilter.mode(
                        context.colorScheme.outline,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "You don't have any \ntemplates, ",
                        style: context.textTheme.titleMedium!
                            .copyWith(color: context.colorScheme.outline),
                        children: [
                          TextSpan(
                            text: 'add one.',
                            style: context.textTheme.titleMedium!
                                .copyWith(color: context.colorScheme.primary),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                ref
                                    .read(currentEventTemplateProvider.notifier)
                                    .createEmptyEventTemplate()
                                    .then((savedTemplate) {
                                  if (context.mounted) {
                                    context.pushNamed(
                                      AppRoute.eventTemplateDetails.name,
                                      extra: savedTemplate,
                                      queryParameters: {'isNew': 'true'},
                                    );
                                  }
                                });
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : RefreshIndicator.adaptive(
                onRefresh: () async {
                  await ref
                      .read(eventTemplatesNotifierProvider.notifier)
                      .getEventTemplates();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ListView.builder(
                    itemCount: eventTemplates.length,
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
