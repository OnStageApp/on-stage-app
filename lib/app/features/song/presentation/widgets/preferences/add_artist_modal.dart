import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/artist/domain/application/artist/artist_notifier.dart';
import 'package:on_stage_app/app/features/artist/domain/application/artists_state.dart';
import 'package:on_stage_app/app/features/artist/domain/models/artist_model.dart';
import 'package:on_stage_app/app/features/event/presentation/custom_text_field.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/shared/top_flush_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/adaptive_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';

class AddArtistModal extends ConsumerStatefulWidget {
  const AddArtistModal({super.key});

  @override
  AddArtistModalState createState() => AddArtistModalState();

  static Future<Artist?> show({
    required BuildContext context,
  }) {
    return AdaptiveModal.show<Artist>(
      context: context,
      child: const AddArtistModal(),
    );
  }
}

class AddArtistModalState extends ConsumerState<AddArtistModal> {
  final TextEditingController _artistNameController = TextEditingController();
  final FocusNode _artistNameFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_artistNameFocus);
    });
  }

  @override
  void dispose() {
    _artistNameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _setupErrorListener();

    return Stack(
      children: [
        NestedScrollModal(
          buildHeader: () => const ModalHeader(title: 'Add New Artist'),
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextField(
                      controller: _artistNameController,
                      focusNode: _artistNameFocus,
                      label: 'Artist Name',
                      hint: 'Enter name',
                      validator: (value) {
                        if (value.isNullEmptyOrWhitespace) {
                          return 'Please enter artist name';
                        }
                        return null;
                      },
                      icon: null,
                    ),
                    const SizedBox(height: 32),
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
            text: 'Add Artist',
            onPressed: _addArtist,
          ),
        ),
      ],
    );
  }

  Future<void> _addArtist() async {
    if (_formKey.currentState!.validate()) {
      final newArtist = await ref
          .read(artistNotifierProvider.notifier)
          .addArtist(_artistNameController.text);

      if (newArtist != null && mounted) {
        context.popDialog(newArtist);
      }
    }
  }

  void _setupErrorListener() {
    ref.listen<ArtistsState>(
      artistNotifierProvider,
      (previous, next) {
        if (next.error != null && mounted) {
          TopFlushBar.show(
            context,
            next.error.toString(),
            isError: true,
          );
        }
      },
    );
  }
}
