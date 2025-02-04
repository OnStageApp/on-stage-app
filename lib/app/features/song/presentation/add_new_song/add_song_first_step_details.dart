import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/artist/domain/models/artist_model.dart';
import 'package:on_stage_app/app/features/event/presentation/custom_text_field.dart';
import 'package:on_stage_app/app/features/lyrics/model/chord_enum.dart';
import 'package:on_stage_app/app/features/permission/application/permission_notifier.dart';
import 'package:on_stage_app/app/features/search/domain/enums/theme_filter_enum.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/application/songs/songs_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model_v2.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_request/song_request.dart';
import 'package:on_stage_app/app/features/song/domain/models/tonality/song_key.dart';
import 'package:on_stage_app/app/features/song/presentation/add_new_song/widgets/preference_selector.dart';
import 'package:on_stage_app/app/features/song/presentation/change_key_modal.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/artist_modal.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/preferences/theme_modal.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/adaptive_dialog.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';
import 'package:on_stage_app/logger.dart';

class AddSongFirstStepDetails extends ConsumerStatefulWidget {
  const AddSongFirstStepDetails({required this.songId, super.key});

  final String? songId;

  @override
  ConsumerState<AddSongFirstStepDetails> createState() =>
      _AddSongFirstStepDetailsState();
}

class _AddSongFirstStepDetailsState
    extends ConsumerState<AddSongFirstStepDetails> {
  final _songNameController = TextEditingController();
  final _bpmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  SongKey? _selectedKey;
  Artist? _selectedArtist;
  ThemeEnum? _selectedTheme;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initSong();
    });

    _songNameController.addListener(_onFieldChanged);
    _bpmController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _songNameController.removeListener(_onFieldChanged);
    _bpmController.removeListener(_onFieldChanged);
    _songNameController.dispose();
    _bpmController.dispose();
    super.dispose();
  }

  Future<void> _initSong() async {
    if (widget.songId.isNotNullEmptyOrWhitespace) {
      await ref
          .read(songNotifierProvider(widget.songId).notifier)
          .getSongById(widget.songId!);
      _prefillValuesIfEditing();
    } else {
      _selectedKey = const SongKey(chord: ChordsWithoutSharp.C);
    }
  }

  void _prefillValuesIfEditing() {
    final song = ref.watch(songNotifierProvider(widget.songId)).song;
    if (song.id != null) {
      _songNameController.text = song.title ?? '';
      _bpmController.text = song.tempo.toString();
      _selectedKey =
          song.originalKey ?? const SongKey(chord: ChordsWithoutSharp.C);
      _selectedArtist = song.artist;
      _selectedTheme = song.theme;
    } else {
      _selectedKey = const SongKey(chord: ChordsWithoutSharp.C);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasEditorRights =
        ref.watch(permissionServiceProvider).hasAccessToEdit;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(12),
        child: ContinueButton(
          text: 'Save',
          isLoading: _isLoading,
          onPressed: _isFormValid()
              ? _onSave
              : () => _formKey.currentState?.validate(),
          isEnabled: true,
        ),
      ),
      appBar: const StageAppBar(
        isBackButtonVisible: true,
        title: 'Song Info',
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
                icon: Icons.music_note,
                keyboardType: TextInputType.text,
                controller: _songNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a song name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: Insets.medium),
              CustomTextField(
                label: 'Tempo (bpm)',
                hint: 'Enter Tempo',
                keyboardType: TextInputType.number,
                icon: Icons.speed,
                controller: _bpmController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a tempo';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid tempo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: Insets.medium),
              PreferenceSelector<SongKey>(
                label: 'Key',
                placeholder: 'Select Key',
                selectedValue: _selectedKey,
                displayValue: (key) => key?.name ?? '',
                validator: (key) {
                  if (key == null) {
                    return 'Please select a valid key';
                  }
                  return null;
                },
                onTap: () {
                  ChangeKeyModal.show(
                    songId: widget.songId,
                    context: context,
                    title: 'Select Key',
                    songKey: _selectedKey ??
                        const SongKey(chord: ChordsWithoutSharp.C),
                    onKeyChanged: (key) async {
                      setState(() {
                        _selectedKey = key;
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: Insets.medium),
              PreferenceSelector<Artist>(
                label: 'Artist',
                placeholder: 'Choose Artist',
                selectedValue: _selectedArtist,
                displayValue: (artist) => artist?.name ?? '',
                validator: (artist) {
                  if (artist?.id == null) {
                    return 'Please select a valid artist';
                  }
                  return null;
                },
                onTap: () {
                  ArtistModal.show(
                    context: context,
                    onArtistSelected: (artist) {
                      setState(() {
                        _selectedArtist = artist;
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: Insets.medium),
              PreferenceSelector<ThemeEnum>(
                label: 'Theme',
                placeholder: 'Choose one or more themes',
                selectedValue: _selectedTheme,
                displayValue: (theme) => theme?.title ?? '',
                validator: (theme) {
                  if (theme == null) {
                    return 'Please select a valid theme';
                  }
                  return null;
                },
                onTap: () {
                  ThemeModal.show(
                    context: context,
                    onSelected: (theme) {
                      setState(() {
                        _selectedTheme = theme;
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: Insets.medium),
              if (hasEditorRights)
                EventActionButton(
                  onTap: () {
                    AdaptiveDialog.show(
                      context: context,
                      title: 'Delete Song',
                      description: 'Are you sure you want to delete this song?',
                      actionText: 'Delete',
                      onAction: () async {
                        // Delete logic
                        // await ref
                        //     .read(eventNotifierProvider.notifier)
                        //     .deleteEventAndGetAll();

                        await ref
                            .read(songsNotifierProvider.notifier)
                            .deleteSong(widget.songId!);

                        context.pushReplacementNamed(AppRoute.song.name);
                      },
                    );
                  },
                  text: 'Delete Song',
                  textColor: context.colorScheme.error,
                ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onSave() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState?.validate() ?? false) {
      if (ref.watch(songNotifierProvider(widget.songId)).song.id == null) {
        logger.i('Validation passed');
        await _saveSongToDb();
      } else {
        await _updateSongToDb();
      }
    } else {
      logger.i('Validation failed');
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveSongToDb() async {
    _setFieldsOnController();
    final newSongId = await ref
        .read(songNotifierProvider(widget.songId).notifier)
        .saveSongToDB();
    if (!context.mounted || newSongId.isNullEmptyOrWhitespace) return;
    context.goNamed(
      AppRoute.editSongContent.name,
      queryParameters: {
        'songId': newSongId,
        'isNewSong': 'true',
      },
    );
  }

  Future<void> _updateSongToDb() async {
    await ref.read(songNotifierProvider(widget.songId).notifier).updateSongToDB(
          SongRequest(
            title: _songNameController.text,
            tempo: int.tryParse(_bpmController.text) ?? 0,
            originalKey: _selectedKey,
            artistId: _selectedArtist?.id,
            theme: _selectedTheme,
          ),
        );
    if (!context.mounted) return;
    context.pop();
  }

  void _setFieldsOnController() {
    ref.read(songNotifierProvider(widget.songId).notifier).updateSongLocalCache(
          SongModelV2(
            title: _songNameController.text,
            tempo: int.tryParse(_bpmController.text) ?? 0,
            originalKey: _selectedKey,
            key: _selectedKey,
            artist: _selectedArtist,
            theme: _selectedTheme,
          ),
        );
  }

  bool _isFormValid() {
    return _songNameController.text.isNotEmpty &&
        _bpmController.text.isNotEmpty &&
        int.tryParse(_bpmController.text) != null &&
        _selectedKey != null &&
        _selectedArtist?.id != null &&
        _selectedArtist != null &&
        _selectedTheme != null &&
        !_isLoading;
  }
}
