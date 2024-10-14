import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/artist/domain/application/artist/artist_notifier.dart';
import 'package:on_stage_app/app/features/event/presentation/custom_text_field.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';

class AddArtistModal extends ConsumerStatefulWidget {
  const AddArtistModal({super.key});

  @override
  AddArtistModalState createState() => AddArtistModalState();

  static Future<Widget?> show({
    required BuildContext context,
  }) async {
    return showModalBottomSheet<Widget>(
      enableDrag: false,
      backgroundColor: context.colorScheme.surface,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
      ),
      context: context,
      builder: (context) => const AddArtistModal(),
    );
  }
}

class AddArtistModalState extends ConsumerState<AddArtistModal> {
  final TextEditingController _artistNameController = TextEditingController();
  final FocusNode _rehearsalNameFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_rehearsalNameFocus);
    });
    super.initState();
  }

  @override
  void dispose() {
    _rehearsalNameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollModal(
      headerHeight: () {
        return 64;
      },
      footerHeight: () {
        return 64;
      },
      buildFooter: () => Padding(
        padding: const EdgeInsets.only(bottom: 16, left: 12, right: 12),
        child: ContinueButton(
          text: 'Add Artist',
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              ref.read(artistNotifierProvider.notifier).addArtist(
                    _artistNameController.text,
                  );
              context.popDialog();
            }
          },
          isEnabled: true,
        ),
      ),
      buildHeader: () => const ModalHeader(
        title: 'Select an Artist',
      ),
      buildContent: () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              CustomTextField(
                controller: _artistNameController,
                focusNode: _rehearsalNameFocus,
                label: 'Artist Name',
                hint: 'Enter artist name',
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
    );
  }
}
