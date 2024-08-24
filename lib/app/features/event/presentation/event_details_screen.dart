import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/controller/event_controller.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/create_stager_request.dart';
import 'package:on_stage_app/app/features/event/presentation/add_participants_screen.dart';
import 'package:on_stage_app/app/features/event/presentation/create_rehearsal_modal.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participant_listing_item.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/event_tile.dart';
import 'package:on_stage_app/app/shared/event_tile_enhanced.dart';
import 'package:on_stage_app/app/shared/loading_widget.dart';
import 'package:on_stage_app/app/shared/settings_trailing_app_bar_button.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/time_utils.dart';

class EventDetailsScreen extends ConsumerStatefulWidget {
  final String eventId;

  const EventDetailsScreen(this.eventId, {super.key});

  @override
  EventDetailsScreenState createState() => EventDetailsScreenState();
}

class EventDetailsScreenState extends ConsumerState<EventDetailsScreen> {
  TextEditingController eventNameController = TextEditingController();
  TextEditingController eventLocationController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  final _isAdmin = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });

    super.initState();
  }

  Future<void> _init() async {
    unawaited(
      ref.read(eventNotifierProvider.notifier).getEventById(widget.eventId),
    );
    unawaited(
      ref.read(eventNotifierProvider.notifier).getRehearsals(widget.eventId),
    );
    unawaited(
      ref.read(eventNotifierProvider.notifier).getStagers(widget.eventId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final event = ref.watch(eventNotifierProvider).event;
    final rehearsals = ref.watch(eventNotifierProvider).rehearsals;
    final stagers = ref.watch(eventNotifierProvider).stagers;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16),
        child: ContinueButton(
          text: 'Preview Event',
          onPressed: () {
            ref
                .read(eventControllerProvider.notifier)
                .setEventName(eventNameController.text);
            ref
                .read(eventControllerProvider.notifier)
                .setEventLocation(eventLocationController.text);

            // ref
            //     .read(eventControllerProvider.notifier)
            //     .setDateTime(dateController.text, timeController.text);

            context.pushNamed(AppRoute.addEventSongs.name);
          },
          isEnabled: true,
        ),
      ),
      appBar: StageAppBar(
        isBackButtonVisible: true,
        title: 'Event',
        trailing: _isAdmin
            ? SettingsTrailingAppBarButton(
                onTap: () {
                  context.pushNamed(AppRoute.eventSettings.name);
                },
              )
            : null,
      ),
      body: ref.watch(eventNotifierProvider).isLoading
          ? const OnStageLoadingIndicator()
          : Padding(
              padding: defaultScreenPadding,
              child: ListView(
                children: [
                  SizedBox(
                    height: 174,
                    child: EventTileEnhanced(
                      title: event?.name ?? '',
                      locationName: event?.location ?? '',
                      date: TimeUtils().formatOnlyDate(
                        event?.date ?? DateTime.now(),
                      ),
                      hour: TimeUtils().formatOnlyTime(
                        event?.date ?? DateTime.now(),
                      ),
                      isSingleEvent: true,
                    ),
                  ),
                  const SizedBox(height: Insets.medium),
                  Text(
                    'Rehearsals',
                    style: context.textTheme.titleSmall,
                  ),
                  if (rehearsals.isNotEmpty)
                    ...rehearsals.map(
                      (rehearsal) {
                        return EventTile(
                          title: rehearsal.name ?? '',
                          dateTime: rehearsal.dateTime ?? DateTime.now(),
                          onTap: () {},
                        );
                      },
                    )
                  else if (!_isAdmin)
                    Container(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        'No rehearsals added',
                        style: context.textTheme.titleSmall!.copyWith(
                          color: context.colorScheme.outline,
                        ),
                      ),
                    ),
                  if (_isAdmin) ...[
                    const SizedBox(height: Insets.smallNormal),
                    _buildCreateRehearsalButton(),
                  ],
                  const SizedBox(height: Insets.medium),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Participants',
                        style: context.textTheme.titleSmall,
                      ),
                      Text(
                        ref
                            .watch(eventControllerProvider.notifier)
                            .getAcceptedInviteesLabel(),
                        style: context.textTheme.bodyMedium!.copyWith(
                          color: context.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                  if (stagers.isNotEmpty) ...[
                    const SizedBox(height: Insets.smallNormal),
                    _buildParticipantsList(),
                  ] else if (!_isAdmin)
                    Container(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        'No rehearsals added',
                        style: context.textTheme.titleSmall!.copyWith(
                          color: context.colorScheme.outline,
                        ),
                      ),
                    ),
                  if (_isAdmin) ...[
                    const SizedBox(height: Insets.smallNormal),
                    _buildInvitePeopleButton(),
                  ],
                  const SizedBox(height: 120),
                ],
              ),
            ),
    );
  }

  Widget _buildParticipantsList() {
    final stagers = ref.read(eventNotifierProvider).stagers;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: context.colorScheme.onSurfaceVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: stagers.length,
        itemBuilder: (context, index) {
          return ParticipantListingItem(
            name: stagers[index].name ?? '',
            assetPath: 'assets/images/profile1.png',
            status: stagers[index].participationStatus!,
            // status: addedParticipants.elementAt(index).status,
          );
        },
      ),
    );
  }

  Widget _buildCreateRehearsalButton() {
    return BlueActionButton(
      onTap: () {
        CreateRehearsalModal.show(context: context);
      },
      text: 'Create new Rehearsal',
      icon: Icons.add,
    );
  }

  Widget _buildInvitePeopleButton() {
    return BlueActionButton(
      onTap: () {
        // ref
        //     .read(userNotifierProvider.notifier)
        //     .getUninvitedUsersByEventId(widget.eventId);
        if (mounted) {
          AddParticipantsScreen.show(
            context: context,
            onPressed: _addStagersToEvent,
            eventId: widget.eventId,
          );
        }
      },
      text: 'Invite People',
      icon: Icons.add,
    );
  }

  void _addStagersToEvent() {
    ref.read(eventNotifierProvider.notifier).addStagerToEvent(
          CreateStagerRequest(
            eventId: widget.eventId,
            userId: ref
                .watch(eventControllerProvider)
                .addedUsers
                .map((e) => e.id)
                .toList(),
          ),
        );
  }
}
