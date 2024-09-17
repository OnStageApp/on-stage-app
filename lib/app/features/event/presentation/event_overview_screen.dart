import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/app_data/app_data_controller.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/presentation/add_event_moments_screen.dart';
import 'package:on_stage_app/app/features/event/presentation/event_details_screen.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/custom_dark_dropdwon.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/settings_trailing_app_bar_button.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';

class EventOverviewScreen extends ConsumerStatefulWidget {
  const EventOverviewScreen(this.eventId, {super.key});

  final String eventId;

  @override
  EventOverviewScreenState createState() => EventOverviewScreenState();
}

class EventOverviewScreenState extends ConsumerState<EventOverviewScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    await ref
        .read(eventNotifierProvider.notifier)
        .initEventById(widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    final event = ref.watch(eventNotifierProvider).event;
    return Scaffold(
      appBar: StageAppBar(
        isBackButtonVisible: true,
        title: 'Event',
        trailing: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 200, maxHeight: 40),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomAnimatedTabSwitch(
                tabController: _tabController,
                tabs: const ['Details', 'Moments'],
                onSwitch: () {
                  if (_tabController.index == 0) {
                    _tabController.animateTo(1);
                  } else {
                    _tabController.animateTo(0);
                  }
                },
              ),
              if (ref.watch(appDataControllerProvider).hasEditorsRight)
                SettingsTrailingAppBarButton(
                  onTap: () {
                    context.pushNamed(AppRoute.eventSettings.name);
                  },
                )
              else
                const SizedBox(),
            ],
          ),
        ),
      ),
      body: event == null
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                EventDetailsScreen(widget.eventId),
                AddEventMomentsScreen(
                  eventId: widget.eventId,
                  isCreatingEvent: false,
                  onSave: () {
                    _tabController.animateTo(0);
                  },
                ),
              ],
            ),
    );
  }
}
