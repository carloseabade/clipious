import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:invidious/extensions.dart';
import 'package:invidious/settings/states/video_filter_channel.dart';
import 'package:invidious/settings/views/components/video_filter_channel.dart';
import 'package:invidious/settings/views/screens/video_filter_setup.dart';
import 'package:uuid/uuid.dart';

import '../../../main.dart';
import '../../../myRouteObserver.dart';
import '../../models/db/video_filter.dart';
import '../../states/video_filter.dart';

class VideoFilterSettings extends StatelessWidget {
  const VideoFilterSettings({Key? key}) : super(key: key);

  createFilter(BuildContext context, {String? channelId}) {
    var cubit = context.read<VideoFilterCubit>();

    navigatorKey.currentState
        ?.push(MaterialPageRoute(
            settings: ROUTE_SETTINGS_VIDEO_FILTERS,
            builder: (context) => VideoFilterSetup(
                  channelId: channelId,
                )))
        .then((value) => cubit.refreshFilters());
  }

  @override
  Widget build(BuildContext context) {
    var locals = AppLocalizations.of(context)!;
    ColorScheme colors = Theme.of(context).colorScheme;
    return BlocProvider(
      create: (context) => VideoFilterCubit(VideoFilterState()),
      child: BlocBuilder<VideoFilterCubit, VideoFilterState>(builder: (context, _) {
        var cubit = context.read<VideoFilterCubit>();

        Map<String, List<VideoFilter>> mappedFilters = _.filters.groupBy(
          (p0) => p0.channelId ?? allChannels,
        );
        List<String> keys = mappedFilters.keys.toList();
        keys.sort(cubit.sortChannels);
        return Scaffold(
            appBar: AppBar(
              backgroundColor: colors.background,
              title: Text(locals.videoFilters),
            ),
            floatingActionButton: FloatingActionButton(onPressed: () => createFilter(context), backgroundColor: colors.primaryContainer, child: const Icon(Icons.add)),
            body: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(locals.videoFiltersExplanation),
                  ),
                  keys.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: keys.length,
                            itemBuilder: (context, index) {
                              return VideoFilterChannel(key: ValueKey(const Uuid().v4()), filters: mappedFilters[keys[index]] ?? []);
                            },
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(locals.videoFilterNoFilters),
                        ),
                ],
              ),
            ));
      }),
    );
  }
}
