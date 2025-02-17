import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:invidious/globals.dart';
import 'package:invidious/player/states/player.dart';
import 'package:invidious/utils/models/sharelink.dart';
import 'package:invidious/utils/views/tv/components/tv_button.dart';
import 'package:invidious/utils/views/tv/components/tv_overscan.dart';
import 'package:invidious/videos/models/base_video.dart';
import 'package:logging/logging.dart';
import 'package:share_plus/share_plus.dart';

import 'utils/models/country.dart';

const PHONE_MAX = 600;
const TABLET_PORTRAIT_MAX = 900;

var log = Logger('Utils');

enum DeviceType { phone, tablet, tv }

double tabletMaxVideoWidth = getDeviceType() == DeviceType.phone ? double.infinity : 500;

String prettyDuration(Duration duration) {
  var components = <String>[];

  var hours = duration.inHours % 24;
  if (hours != 0) {
    components.add('${hours}:');
  }
  var minutes = duration.inMinutes % 60;
  components.add('${minutes.toString().padLeft(2, '0')}:');

  var seconds = duration.inSeconds % 60;
  components.add(seconds.toString().padLeft(2, '0'));
  return components.join();
}

NumberFormat compactCurrency = NumberFormat.compactCurrency(
  decimalDigits: 2,
  symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
);

Future<void> showAlertDialog(BuildContext context, String title, List<Widget> body) async {
  var locals = AppLocalizations.of(context)!;
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: body,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(locals.ok),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showSharingSheet(BuildContext context, ShareLinks links, {bool showTimestampOption = false}) {
  var locals = AppLocalizations.of(context)!;

  bool shareWithTimestamp = false;
  Future<Duration?> getTimestamp() async {
    if (shareWithTimestamp) {
      var player = context.read<PlayerCubit>();
      return player.state.position;
    }
    return null;
  }

  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          setShowTimeStamp(bool? value) {
            setState(() {
              shareWithTimestamp = value ?? false;
            });
          }

          return SizedBox(
            height: showTimestampOption ? 200 : 150,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FilledButton.tonal(
                  child: Text(locals.shareInvidiousLink),
                  onPressed: () async {
                    final timestamp = await getTimestamp();

                    Share.share(links.getInvidiousLink(db.getCurrentlySelectedServer(), timestamp?.inSeconds));
                    Navigator.of(context).pop();
                  },
                ),
                FilledButton.tonal(
                  child: Text(locals.redirectInvidiousLink),
                  onPressed: () async {
                    final timestamp = await getTimestamp();

                    Share.share(links.getRedirectLink(timestamp?.inSeconds));
                    Navigator.of(context).pop();
                  },
                ),
                FilledButton.tonal(
                  child: Text(locals.shareYoutubeLink),
                  onPressed: () async {
                    final timestamp = await getTimestamp();

                    Share.share(links.getYoutubeLink(timestamp?.inSeconds));
                    Navigator.of(context).pop();
                  },
                ),
                if (showTimestampOption)
                  InkWell(
                    onTap: () => setShowTimeStamp(!shareWithTimestamp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Checkbox(
                          value: shareWithTimestamp,
                          onChanged: setShowTimeStamp,
                        ),
                        Text(locals.shareLinkWithTimestamp),
                      ],
                    ),
                  )
              ],
            ),
          );
        },
      );
    },
  );
}

double getScreenWidth() {
  final data = MediaQueryData.fromView(WidgetsBinding.instance.window);
  return data.size.width;
}

DeviceType getDeviceType() {
  final data = MediaQueryData.fromView(WidgetsBinding.instance.window);
  return data.size.shortestSide < 600 ? DeviceType.phone : DeviceType.tablet;
}

Future<bool> isDeviceTv() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  return androidInfo.systemFeatures.contains('android.software.leanback');
}

int getGridCount(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  if (width < PHONE_MAX) {
    return 1;
  }

  return (width / 300).floor();
}

double getGridAspectRatio(BuildContext context) {
  return getGridCount(context) > 1 ? 16 / 15 : 16 / 13;
}

okCancelDialog(BuildContext context, String title, String message, Function() onOk) {
  var locals = AppLocalizations.of(context)!;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text(locals.ok),
            onPressed: () {
              onOk();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(locals.cancel),
            onPressed: () {
              //Put your code here which you want to execute on Cancel button click.
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

showTvAlertdialog(BuildContext context, String title, List<Widget> body) {
  var locals = AppLocalizations.of(context)!;
  showTvDialog(context: context, builder: (context) => body, actions: [
    TvButton(
      autofocus: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Text(locals.ok),
      ),
      onPressed: (context) {
        Navigator.of(context).pop();
      },
    )
  ]);
}

showTvDialog({required BuildContext context, String? title, required List<Widget> Function(BuildContext context) builder, required List<Widget> actions}) {
  var textTheme = Theme.of(context).textTheme;

  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) {
      ColorScheme colors = Theme.of(context).colorScheme;
      return Scaffold(
        body: TvOverscan(
          child: Column(children: [
            if (title != null) Text(title, style: textTheme.titleLarge?.copyWith(color: colors.primary)),
            Expanded(
              child: ListView(
                children: builder(context),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions
                  .map((e) => Padding(
                        padding: EdgeInsets.all(16),
                        child: e,
                      ))
                  .toList(),
            )
          ]),
        ),
      );
    },
  ));
}

Country getCountryFromCode(String code) {
  return countryCodes.firstWhere((element) => element.code == code, orElse: () => Country('US', 'United States of America'));
}

KeyEventResult onTvSelect(KeyEvent event, BuildContext context, Function(BuildContext context) func) {
  if (event is KeyUpEvent) {
    log.fine('onTvSelect, ${event.logicalKey}, ${event}');
    if (event.logicalKey == LogicalKeyboardKey.select || event.logicalKey == LogicalKeyboardKey.enter) {
      func(context);
      return KeyEventResult.handled;
    }
  }

  return KeyEventResult.ignored;
}

SystemUiOverlayStyle getUiOverlayStyle(BuildContext context) {
  ColorScheme colorScheme = Theme.of(context).colorScheme;
  return SystemUiOverlayStyle(
      systemNavigationBarColor: colorScheme.background,
      systemNavigationBarIconBrightness: colorScheme.brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      statusBarColor: colorScheme.background,
      statusBarIconBrightness: colorScheme.brightness == Brightness.dark ? Brightness.light : Brightness.dark);
}

List<T> filteredVideos<T extends BaseVideo>(List<T> videos) => videos.where((element) => !element.filterHide).toList();
