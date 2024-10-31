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
import 'package:on_stage_app/app/shared/placeholder_image_widget.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:shimmer/shimmer.dart';

class InvitePeopleToEventModal extends ConsumerStatefulWidget {
  const InvitePeopleToEventModal({
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
                    text: 'Invite People to Event',
                    onPressed: () {
                      _onPressed(ref, onPressed ?? () {});
                      context.popDialog();
                    },
                    isEnabled: ref
                        .watch(eventControllerProvider)
                        .selectedTeamMembers
                        .isNotEmpty,
                  );
                },
              ),
            ),
          ),
          buildHeader: () => const ModalHeader(title: 'Add People'),
          headerHeight: () {
            return 64;
          },
          footerHeight: () {
            return 64;
          },
          buildContent: () => InvitePeopleToEventModal(
            eventId: eventId,
          ),
        ),
      ),
    );
  }

  static void _onPressed(WidgetRef ref, void Function() onPressed) {
    ref.read(eventControllerProvider.notifier).addMembers();
    ref.read(eventControllerProvider.notifier).resetSelectedMembers();
    onPressed.call();
  }
}

class AddParticipantsModalState
    extends ConsumerState<InvitePeopleToEventModal> {
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
      _searchedParticipants = ref
          .watch(teamMembersNotifierProvider)
          .teamMembers
          .where(
            (member) => !ref
                .watch(eventControllerProvider)
                .addedMembers
                .any((added) => added.id == member.id),
          )
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    _setParticipants();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildSearchBar(),
          const SizedBox(height: 12),
          if (_areParticipantsLoading)
            _buildShimmerLoading()
          else
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
                            .unSelectTeamMember(
                              _searchedParticipants.elementAt(index),
                            );
                      } else {
                        ref
                            .read(eventControllerProvider.notifier)
                            .selectTeamMember(
                              _searchedParticipants.elementAt(index),
                            );
                      }
                    },
                    child: _buildTile(index),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTile(int index) {
    return Container(
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
          _buildPlaceholder(
            context,
            _searchedParticipants.elementAt(index),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              _searchedParticipants.elementAt(index).name ?? '',
              style: context.textTheme.titleSmall,
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
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
    );
  }

  Widget _buildPlaceholder(BuildContext context, TeamMember participant) {
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.colorScheme.onSurfaceVariant,
        border: Border.all(
          color: context.colorScheme.primaryContainer,
          width: participant.profilePicture != null ? 0 : 1,
        ),
        shape: BoxShape.circle,
        image: participant.profilePicture != null
            ? DecorationImage(
                image: MemoryImage(
                  participant.profilePicture!,
                ),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: participant.profilePicture != null
          ? null
          : PlaceholderImageWidget(title: participant.name ?? 'Unknown'),
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

  bool _isItemChecked(int index) {
    final currentParticipant = _searchedParticipants.elementAt(index);
    final addedMemberIds = ref
        .watch(eventControllerProvider)
        .selectedTeamMembers
        .map((member) => member.id)
        .toSet();

    return addedMemberIds.contains(currentParticipant.id);
  }

  Widget _buildShimmerLoading() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 42),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 10,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade200,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 48,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        },
      ),
    );
  }

}
