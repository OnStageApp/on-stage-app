import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/search/presentation/stage_search_bar.dart';
import 'package:on_stage_app/app/features/team_member/application/team_members_notifier.dart';
import 'package:on_stage_app/app/features/team_member/domain/team_member.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/shared/placeholder_image_widget.dart';
import 'package:on_stage_app/app/utils/adaptive_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:shimmer/shimmer.dart';

class UninvitedPeopleModal extends ConsumerStatefulWidget {
  const UninvitedPeopleModal.fromEventId({
    required String eventId,
    required this.positionName,
    required this.positionId,
    super.key,
  })  : _eventId = eventId,
        _eventTemplateId = null;

  const UninvitedPeopleModal.fromEventTemplateId({
    required String? eventTemplateId,
    required this.positionName,
    required this.positionId,
    super.key,
  })  : _eventTemplateId = eventTemplateId,
        _eventId = null;

  final String? _eventId;
  final String? _eventTemplateId;
  final String positionName;
  final String positionId;

  bool get _isEventMode => _eventId != null;

  @override
  UninvitedPeopleModalState createState() => UninvitedPeopleModalState();

  static Future<List<TeamMember>?> show({
    required BuildContext context,
    required String positionName,
    required String positionId,
    String? eventId,
    String? eventTemplateId,
  }) {
    assert(
      (eventId != null) != (eventTemplateId != null),
      'Either eventId or eventTemplateId must be provided, but not both',
    );

    return AdaptiveModal.show<List<TeamMember>>(
      context: context,
      child: eventId != null
          ? UninvitedPeopleModal.fromEventId(
              eventId: eventId,
              positionName: positionName,
              positionId: positionId,
            )
          : UninvitedPeopleModal.fromEventTemplateId(
              eventTemplateId: eventTemplateId,
              positionName: positionName,
              positionId: positionId,
            ),
    );
  }
}

class UninvitedPeopleModalState extends ConsumerState<UninvitedPeopleModal> {
  final TextEditingController _searchController = TextEditingController();
  List<TeamMember> _searchedParticipants = [];
  List<TeamMember> _allParticipants = [];
  final FocusNode _searchFocusNode = FocusNode();
  List<TeamMember> selectedTeamMembers = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getUninvitedTeamMembers();
    });
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _getUninvitedTeamMembers() async {
    if (widget._isEventMode) {
      await ref
          .read(teamMembersNotifierProvider.notifier)
          .getUninvitedTeamMembers(
            eventId: widget._eventId!,
            positionId: widget.positionId,
          );
    } else {
      await ref
          .read(teamMembersNotifierProvider.notifier)
          .getUninvitedTeamMembersForEventTemplates(
            eventTemplateId: widget._eventTemplateId!,
            positionId: widget.positionId,
          );
    }

    setState(() {
      _allParticipants =
          ref.watch(teamMembersNotifierProvider).uninvitedTeamMembers;
      _searchedParticipants = _allParticipants;
    });
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final searchQuery = _searchController.text.toLowerCase().trim();
    setState(() {
      if (searchQuery.isEmpty) {
        _searchedParticipants = _allParticipants;
      } else {
        _searchedParticipants = _allParticipants.where((member) {
          final name = member.name?.toLowerCase() ?? '';
          return name.contains(searchQuery);
        }).toList();
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchedParticipants = _allParticipants;
    });
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: StageSearchBar(
        focusNode: _searchFocusNode,
        controller: _searchController,
        onClosed: _clearSearch,
        onChanged: (value) {
          if (value.isEmpty) {
            _clearSearch();
          }
        },
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
          : PlaceholderImageWidget(name: participant.name ?? 'Unknown'),
    );
  }

  Widget _buildTile(int index) {
    return Container(
      height: 54,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.colorScheme.onSurfaceVariant,
        borderRadius: BorderRadius.circular(10),
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

  Widget _buildShimmerLoading() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 42),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 6,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: context.colorScheme.onSurfaceVariant.withOpacity(0.3),
            highlightColor: context.colorScheme.onSurfaceVariant,
            child: Container(
              height: 48,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: context.colorScheme.onSurfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final teamMembersState = ref.watch(teamMembersNotifierProvider);
    return NestedScrollModal(
      buildHeader: () => ModalHeader(title: widget.positionName),
      headerHeight: () => 64,
      footerHeight: () => 64,
      buildFooter: () => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 36),
        child: ClipRect(
          child: ContinueButton(
            text: widget._isEventMode
                ? 'Invite People to Event'
                : 'Add People to Template',
            onPressed: () {
              context.popDialog(selectedTeamMembers);
            },
            isEnabled: selectedTeamMembers.isNotEmpty,
          ),
        ),
      ),
      buildContent: () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildSearchBar(),
            const SizedBox(height: 12),
            if (teamMembersState.isLoading)
              _buildShimmerLoading()
            else if (_searchedParticipants.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Text(
                    'No members found',
                    style: context.textTheme.bodyLarge,
                  ),
                ),
              )
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
                        _searchFocusNode.unfocus();
                        _modifyInvitedMembers(index);
                      },
                      child: _buildTile(index),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _modifyInvitedMembers(int index) {
    if (_isItemChecked(index)) {
      setState(() {
        selectedTeamMembers.remove(
          _searchedParticipants.elementAt(index),
        );
      });
    } else {
      setState(() {
        selectedTeamMembers.add(
          _searchedParticipants.elementAt(index),
        );
      });
    }
  }

  bool _isItemChecked(int index) {
    return selectedTeamMembers.contains(_searchedParticipants.elementAt(index));
  }
}
