import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../main.dart';
import '../../../myRouteObserver.dart';
import '../../states/download_manager.dart';
import '../screens/download_manager.dart';

class AppBarDownloadButton extends StatelessWidget {
  const AppBarDownloadButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return BlocBuilder<DownloadManagerCubit, DownloadManagerState>(
      // buildWhen: (previous, current) => previous.videos.length != current.videos.length || previous.totalProgress != current.totalProgress,
      builder: (context, _) => Stack(
        alignment: Alignment.center,
        children: [
          IconButton(
            onPressed: openDownloadManager,
            icon: Icon(
              Icons.download,
              color: _.downloadProgresses.isNotEmpty ? colors.background : null,
            ),
          ),
          _.downloadProgresses.isNotEmpty
              ? InkWell(
                  onTap: openDownloadManager,
                  child: SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator(
                        value: _.totalProgress == 0 ? null : _.totalProgress,
                        strokeWidth: 2,
                      )),
                )
              : const SizedBox.shrink(),
          Positioned(
              top: 1,
              right: 1,
              child: _.videos.isNotEmpty
                  ? GestureDetector(
                      onTap: openDownloadManager,
                      child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(color: colors.secondaryContainer, shape: BoxShape.circle),
                          child: Text(
                            _.videos.length.toString(),
                            style: textTheme.labelSmall,
                          )),
                    )
                  : const SizedBox.shrink())
        ],
      ),
    );
  }

  void openDownloadManager() {
    navigatorKey.currentState?.push(MaterialPageRoute(settings: ROUTE_DOWNLOAD_MANAGER, builder: (context) => const DownloadManager()));
  }
}
