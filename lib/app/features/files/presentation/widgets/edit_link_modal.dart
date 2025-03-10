import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/presentation/custom_text_field.dart';
import 'package:on_stage_app/app/features/files/application/song_files_notifier.dart';
import 'package:on_stage_app/app/features/files/domain/song_file.dart';
import 'package:on_stage_app/app/features/files/domain/update_song_file_request.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/adaptive_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class EditLinkModal extends ConsumerStatefulWidget {
  const EditLinkModal({
    required this.songId,
    this.link,
    this.onLinkCreated,
    super.key,
  });

  final void Function(UpdateSongFileRequest)? onLinkCreated;
  final SongFile? link;
  final String songId;

  static void show({
    required BuildContext context,
    required String songId,
    SongFile? link,
    void Function(UpdateSongFileRequest)? onLinkCreated,
    bool enabled = true,
  }) {
    AdaptiveModal.show<void>(
      context: context,
      isFloatingForLargeScreens: true,
      child: EditLinkModal(
        songId: songId,
        onLinkCreated: onLinkCreated,
        link: link,
      ),
    );
  }

  @override
  EditLinkModalState createState() => EditLinkModalState();
}

class EditLinkModalState extends ConsumerState<EditLinkModal> {
  List<int> selectedReminders = [0];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initControllers();
      FocusScope.of(context).requestFocus(_nameFocus);
    });
  }

  void _initControllers() {
    setState(() {
      _nameController.text = widget.link?.name ?? '';
      _linkController.text = widget.link?.link ?? '';
    });
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NestedScrollModal(
          buildHeader: () => const ModalHeader(title: 'Link'),
          headerHeight: () => 64,
          buildContent: () => SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: defaultScreenPadding.left,
                right: defaultScreenPadding.right,
                top: defaultScreenPadding.top,
                bottom: MediaQuery.of(context).viewInsets.bottom + 80,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      label: 'Name',
                      hint: 'Official Website',
                      icon: null,
                      focusNode: _nameFocus,
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      label: 'Link Content',
                      hint: 'https://getonstage.app',
                      icon: null,
                      controller: _linkController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a link';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 42,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          left: 12,
          right: 12,
          child: ContinueButton(
            isEnabled: true,
            hasShadow: false,
            text: widget.link != null ? 'Update' : 'Create',
            onPressed: _uploadLink,
          ),
        ),
      ],
    );
  }

  void _uploadLink() {
    final name = _nameController.text;
    final link = _linkController.text;
    final notifier = ref.read(songFilesNotifierProvider.notifier);
    if (widget.link != null) {
      notifier.updateSongFile(widget.link!.id, name, newLink: link);
    } else {
      ref.read(songFilesNotifierProvider.notifier).uploadLink(
            widget.songId,
            name,
            link,
          );
    }
    FocusScope.of(context).unfocus();

    context.popDialog();
  }
}
