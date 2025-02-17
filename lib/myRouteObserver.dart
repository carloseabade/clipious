import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invidious/player/states/player.dart';
import 'package:logging/logging.dart';

const String PATH_CHANNEL = "/channel";
const String PATH_VIDEO = "/video";
const String PATH_MANAGE_SUBS = "/manage-subscription_management";
const String PATH_LAYOUT_EDITOR = '/edit-layout';

const RouteSettings ROUTE_SETTINGS = RouteSettings(name: 'settings');
const RouteSettings ROUTE_DOWNLOAD_MANAGER = RouteSettings(name: 'download-manager');
const RouteSettings ROUTE_SETTINGS_MANAGE_SERVERS = RouteSettings(name: 'settings-manage-servers');
const RouteSettings ROUTE_SETTINGS_MANAGE_ONE_SERVER = RouteSettings(name: 'settings-manage-one-server');
const RouteSettings ROUTE_SETTINGS_SPONSOR_BLOCK = RouteSettings(name: 'settings-sponsor-block');
const RouteSettings ROUTE_SETTINGS_VIDEO_FILTERS = RouteSettings(name: 'settings-video-filters');
const RouteSettings ROUTE_SETTINGS_SEARCH_HISTORY = RouteSettings(name: 'settings-search-history');
const RouteSettings ROUTE_VIDEO = RouteSettings(name: PATH_VIDEO);
const RouteSettings ROUTE_CHANNEL = RouteSettings(name: PATH_CHANNEL);
const RouteSettings ROUTE_PLAYLIST_LIST = RouteSettings(name: 'playlist-list');
const RouteSettings ROUTE_PLAYLIST = RouteSettings(name: 'playlist');
const RouteSettings ROUTE_MANAGE_SUBSCRIPTIONS = RouteSettings(name: PATH_MANAGE_SUBS);

class MyRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  var log = Logger('MyRouteObserver');

  stopPlayingOnPop(PageRoute<dynamic>? newRoute, PageRoute<dynamic>? poppedRoute) {
    newRoute?.navigator?.context.read<PlayerCubit>().showMiniPlayer();
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log.fine("New route context: ${route.navigator?.context}");
    route.navigator?.context.read<PlayerCubit>().showMiniPlayer();
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      if (previousRoute is PageRoute) {
        stopPlayingOnPop(route, previousRoute);
      }
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      // _sendScreenView(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      stopPlayingOnPop(route, previousRoute);
    }
  }
}
