import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/controller/event_controller.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/rehearsal/rehearsal_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/create_stager_request.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager.dart';
import 'package:on_stage_app/app/features/event/presentation/add_participants_screen.dart';
import 'package:on_stage_app/app/features/event/presentation/create_rehearsal_modal.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participant_listing_item.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/event_tile_enhanced.dart';
import 'package:on_stage_app/app/shared/loading_widget.dart';
import 'package:on_stage_app/app/shared/rehearsal_tile.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class EventDetailsScreen extends ConsumerStatefulWidget {
  const EventDetailsScreen(this.eventId, {super.key});

  final String eventId;

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final eventState = ref.watch(eventNotifierProvider);
    final event = eventState.event;
    final rehearsals = eventState.rehearsals;
    final stagers = eventState.stagers;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16),
        child: ContinueButton(
          text: 'Publish Event',
          onPressed: () {},
          isEnabled: true,
        ),
      ),
      body: _buildBody(event, context, rehearsals, stagers),
    );
  }

  Widget _buildBody(
    EventModel? event,
    BuildContext context,
    List<RehearsalModel> rehearsals,
    List<Stager> stagers,
  ) {
    return ref.watch(eventNotifierProvider).isLoading
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
                    dateTime: event?.dateTime ?? DateTime.now(),
                    isSingleEvent: true,
                    onTap: () {},
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
                      return RehearsalTile(
                        onDelete: () {
                          ref
                              .read(eventNotifierProvider.notifier)
                              .deleteRehearsal(rehearsal.id!);
                        },
                        title: rehearsal.name ?? '',
                        dateTime: rehearsal.dateTime ?? DateTime.now(),
                        onTap: () {
                          CreateRehearsalModal.show(
                            context: context,
                            rehearsal: rehearsal,
                            onRehearsalCreated: (RehearsalModel rehearsal) {
                              ref
                                  .read(eventNotifierProvider.notifier)
                                  .updateRehearsal(rehearsal);
                            },
                          );
                        },
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
                  const SizedBox(height: Insets.extraSmall),
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
            onDelete: () {
              ref
                  .read(eventNotifierProvider.notifier)
                  .removeStagerFromEvent(stagers[index].id);
            },
          );
        },
      ),
    );
  }

  Widget _buildCreateRehearsalButton() {
    return EventActionButton(
      onTap: () {
        CreateRehearsalModal.show(
          context: context,
          onRehearsalCreated: (RehearsalModel rehearsal) {
            ref.read(eventNotifierProvider.notifier).addRehearsal(rehearsal);
          },
        );
      },
      text: 'Create new Rehearsal',
      icon: Icons.add,
    );
  }

  Widget _buildInvitePeopleButton() {
    return EventActionButton(
      onTap: () {
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
            userIds: ref
                .watch(eventControllerProvider)
                .addedUsers
                .map((e) => e.id)
                .toList(),
          ),
        );
  }
}
