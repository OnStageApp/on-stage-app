import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/artist/domain/models/artist_model.dart';
import 'package:on_stage_app/app/features/event/presentation/custom_text_field.dart';
import 'package:on_stage_app/app/features/lyrics/model/chord_enum.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model_v2.dart';
import 'package:on_stage_app/app/features/song/domain/models/tonality/song_key.dart';
import 'package:on_stage_app/app/features/song/presentation/change_key_modal.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/artist_modal.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/logger.dart';
import 'package:on_stage_app/resources/generated/assets.gen.dart';

class AddSongFirstStepDetails extends ConsumerStatefulWidget {
  const AddSongFirstStepDetails({super.key});

  @override
  AddSongFirstStepDetailsState createState() => AddSongFirstStepDetailsState();
}

class AddSongFirstStepDetailsState
    extends ConsumerState<AddSongFirstStepDetails> {
  final _songNameController = TextEditingController();
  final _bpmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  SongKey _selectedKey = const SongKey(chord: ChordsWithoutSharp.C);
  Artist? _selectedArtist;
  String? _keyError;
  String? _artistError;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(12),
        child: ContinueButton(
          text: 'Continue',
          onPressed: () async {
            ref.read(songNotifierProvider.notifier).resetState();
            _addSongDetails(context);
          },
          isEnabled: true,
        ),
      ),
      appBar: const StageAppBar(
        isBackButtonVisible: true,
        title: 'Add Song',
      ),
      body: Padding(
        padding: defaultScreenPadding,
        child: Form(
          key: _formKey,
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              CustomTextField(
                label: 'Song Name',
                hint: 'Enter Song Name',
                icon: Icons.church,
                keyboardType: TextInputType.text,
                controller: _songNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a song name';
                  }
                  return null;
                },
                onChanged: (value) {},
              ),
              const SizedBox(height: Insets.medium),
              CustomTextField(
                label: 'Tempo (bpm)',
                hint: 'Enter Tempo',
                keyboardType: TextInputType.number,
                icon: Icons.church,
                controller: _bpmController,
                onChanged: (value) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter tempo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: Insets.medium),
              ..._buildKeyTile(context),
              if (_keyError != null)
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 4),
                  child: Text(
                    _keyError!,
                    style: context.textTheme.bodySmall!.copyWith(
                      color: context.colorScheme.error,
                    ),
                  ),
                ),
              const SizedBox(height: Insets.medium),
              ..._buildArtistTile(context),
              if (_artistError != null)
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 4),
                  child: Text(
                    _artistError!,
                    style: context.textTheme.bodySmall!.copyWith(
                      color: context.colorScheme.error,
                    ),
                  ),
                ),
              const SizedBox(height: Insets.medium),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildKeyTile(BuildContext context) {
    return [
      Text(
        'Key',
        style: context.textTheme.titleSmall!.copyWith(
          color: context.colorScheme.onSurface,
        ),
      ),
      const SizedBox(height: Insets.small),
      Container(
        decoration: BoxDecoration(
          color: context.colorScheme.onSurfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          dense: true,
          title: Text(
            _selectedKey.name,
            style: context.textTheme.titleMedium!
                .copyWith(color: context.colorScheme.onSurface),
          ),
          trailing: _buildArrowWidget(context),
          onTap: () {
            ChangeKeyModal.show(
              context: context,
              title: 'Select Key',
              songKey: const SongKey(chord: ChordsWithoutSharp.C),
              onKeyChanged: (key) {
                setState(() {
                  _selectedKey = key;
                  _keyError = null;
                });
              },
            );
          },
        ),
      ),
    ];
  }

  List<Widget> _buildArtistTile(BuildContext context) {
    return [
      Text(
        'Artist',
        style: context.textTheme.titleSmall!.copyWith(
          color: context.colorScheme.onSurface,
        ),
      ),
      const SizedBox(height: Insets.small),
      Container(
        decoration: BoxDecoration(
          color: context.colorScheme.onSurfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          dense: true,
          title: Text(
            _selectedArtist?.name ?? 'Choose Artist',
            style: context.textTheme.titleMedium!.copyWith(
              color: _selectedArtist != null
                  ? context.colorScheme.onSurface
                  : context.colorScheme.outline,
            ),
          ),
          trailing: _buildArrowWidget(context),
          onTap: () {
            ArtistModal.show(
              context: context,
              onArtistSelected: (artist) {
                setState(() {
                  _selectedArtist = artist;
                  _artistError = null;
                });
              },
            );
          },
        ),
      ),
    ];
  }

  Widget _buildArrowWidget(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Center(
        child: Assets.icons.arrowDown.svg(),
      ),
    );
  }

  void _addSongDetails(BuildContext context) {
    setState(() {
      _artistError = _selectedArtist == null ? 'Please select an artist' : null;
    });

    if (_formKey.currentState!.validate() && _selectedArtist != null) {
      _setFieldsOnController();
      context.pushNamed(AppRoute.editSongContent.name);
    } else {
      logger.e('Validation failed');
    }
  }

  void _setFieldsOnController() {
    ref.read(songNotifierProvider.notifier).updateSong(
          SongModelV2(
            title: _songNameController.text,
            tempo: int.tryParse(_bpmController.text) ?? 0,
            originalKey: _selectedKey,
            key: _selectedKey,
            artist: _selectedArtist,
          ),
        );
  }
}
