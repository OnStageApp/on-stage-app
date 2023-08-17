import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/stage_search_bar.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/event_tile_enhanced.dart';
import 'package:on_stage_app/app/shared/profile_icon_widget.dart';
import 'package:on_stage_app/app/shared/song_square_card.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: Insets.medium),
            Padding(
              padding: defaultScreenHorizontalPadding,
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome',
                        style: context.textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '@johnmayer145',
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: context.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  const ProfileIconWidget(),
                ],
              ),
            ),
            const SizedBox(height: Insets.large),
            Padding(
              padding: defaultScreenHorizontalPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'searchBar',
                    child: StageSearchBar(
                      focusNode: _focusNode,
                      onTap: () {
                        //use ShellRoutes
                        ///https://codewithandrea.com/articles/flutter-bottom-navigation-bar-nested-routes-gorouter/
                        context.goNamed(AppRoute.songs.name);
                      },
                    ),
                  ),
                  const SizedBox(height: Insets.large),
                  Text('Upcoming Event', style: context.textTheme.titleMedium),
                  const SizedBox(height: Insets.medium),
                  const EventTileEnhanced(
                    title: 'Program seara',
                    description: 'Monday, 14 Feb',
                  ),
                  const SizedBox(height: Insets.medium),
                  Text('Top Rated', style: context.textTheme.titleMedium),
                  const SizedBox(height: Insets.medium),
                ],
              ),
            ),
            _buildTopRatedSongs(),
            const SizedBox(height: Insets.medium),
            Padding(
              padding: defaultScreenHorizontalPadding,
              child:
                  Text('Recently Added', style: context.textTheme.titleMedium),
            ),
            const SizedBox(height: Insets.medium),
            _buildTopRatedSongs(),
            const SizedBox(height: Insets.medium),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRatedSongs() {
    return SizedBox(
      height: 182,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return const Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SongSquareCard(),
              ),
            ],
          );
        },
        itemCount: 5,
        shrinkWrap: true,
      ),
    );
  }
}
