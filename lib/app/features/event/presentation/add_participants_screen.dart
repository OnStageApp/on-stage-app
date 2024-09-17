import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/controller/event_controller.dart';
import 'package:on_stage_app/app/features/search/presentation/stage_search_bar.dart';
import 'package:on_stage_app/app/features/team_member/application/team_members_notifier.dart';
import 'package:on_stage_app/app/features/team_member/domain/team_member.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/loading_widget.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class AddParticipantsScreen extends ConsumerStatefulWidget {
  const AddParticipantsScreen({
    required this.eventId,
    this.onPressed,
    super.key,
  });

  final String? eventId;
  final void Function()? onPressed;

  @override
  AddParticipantsModalState createState() => AddParticipantsModalState();

  static void show({
    required BuildContext context,
    String? eventId,
    void Function()? onPressed,
  }) {
    showModalBottomSheet<Widget>(
      isScrollControlled: true,
      backgroundColor: context.colorScheme.surface,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      context: context,
      builder: (context) => Container(
        margin: const EdgeInsets.only(top: 24),
        child: NestedScrollModal(
          buildFooter: () => SizedBox(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                32,
              ),
              child: Consumer(
                builder: (context, ref, _) {
                  return ContinueButton(
                    text: ref
                        .watch(eventControllerProvider)
                        .invitePeopleButtonText,
                    onPressed: () {
                      if (onPressed != null) {
                        onPressed();
                      }
                      context.popDialog();
                    },
                    isEnabled: true,
                  );
                },
              ),
            ),
          ),
          buildHeader: () => const ModalHeader(title: 'Add Participants'),
          headerHeight: () {
            return 64;
          },
          footerHeight: () {
            return 64;
          },
          buildContent: () => AddParticipantsScreen(
            eventId: eventId,
          ),
        ),
      ),
    );
  }
}

class AddParticipantsModalState extends ConsumerState<AddParticipantsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<TeamMember> _searchedParticipants = [];
  bool _areParticipantsLoading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestParticipants();
    });

    super.initState();
  }

  Future<void> _requestParticipants() async {
    setState(() {
      _areParticipantsLoading = true;
    });
    if (widget.eventId != null) {
      await ref
          .read(teamMembersNotifierProvider.notifier)
          .getUninvitedTeamMembers(widget.eventId!);
    } else {
      await ref
          .read(teamMembersNotifierProvider.notifier)
          .getTeamMembers(includeCurrentUser: false);
    }
    setState(() {
      _areParticipantsLoading = false;
    });
  }

  void _setParticipants() {
    if (widget.eventId != null) {
      _searchedParticipants =
          ref.watch(teamMembersNotifierProvider).uninvitedTeamMembers;
    } else {
      _searchedParticipants =
          ref.watch(teamMembersNotifierProvider).teamMembers;
    }
  }

  @override
  Widget build(BuildContext context) {
    _setParticipants();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: _areParticipantsLoading
          ? const OnStageLoadingIndicator()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _buildSearchBar(),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(bottom: 42),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _searchedParticipants.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (_isItemChecked(index)) {
                            ref
                                .read(eventControllerProvider.notifier)
                                .removeParticipant(
                                  _searchedParticipants.elementAt(index),
                                );
                          } else {
                            ref
                                .read(eventControllerProvider.notifier)
                                .addParticipant(
                                  _searchedParticipants.elementAt(index),
                                );
                          }
                        },
                        child: Container(
                          height: 48,
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: context.colorScheme.onSurfaceVariant,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _isItemChecked(index)
                                  ? context.colorScheme.primary
                                  : context.colorScheme.onSurfaceVariant,
                              width: 1.6,
                            ),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 12),
                              Container(
                                width: 30,
                                height: 30,
                                alignment: Alignment.center,
                                key: ValueKey(
                                  _searchedParticipants
                                      .elementAt(index)
                                      .hashCode
                                      .toString(),
                                ),
                                decoration: BoxDecoration(
                                  color: context.colorScheme.onSurfaceVariant,
                                  border: Border.all(
                                    color: Colors.green,
                                    width: 3,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  _searchedParticipants.elementAt(index).name ??
                                      'unknown'.substring(0, 1) ??
                                      '',
                                  textAlign: TextAlign.center,
                                  style: context.textTheme.titleSmall,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(
                                  _searchedParticipants.elementAt(index).name ??
                                      '',
                                  style: context.textTheme.titleSmall,
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Icon(
                                  _isItemChecked(index)
                                      ? Icons.check_circle_rounded
                                      : Icons.circle_outlined,
                                  size: 20,
                                  color: _isItemChecked(index)
                                      ? context.colorScheme.primary
                                      : context.colorScheme.surfaceBright,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSearchBar() {
    return StageSearchBar(
      focusNode: FocusNode(),
      controller: _searchController,
      onClosed: () {},
      onChanged: (value) {
        if (value.isEmpty) {
          _clearSearch();
        }
      },
    );
  }

  void _clearSearch() {}

  bool _isItemChecked(int index) => ref
      .watch(eventControllerProvider)
      .addedTeamMembers
      .contains(_searchedParticipants.elementAt(index));
}
