import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:invidious/database.dart';
import 'package:invidious/globals.dart';
import 'package:invidious/main.dart';
import 'package:invidious/search/models/search_results.dart';
import 'package:invidious/search/models/search_sort_by.dart';

import '../../channels/models/channel.dart';
import '../../playlists/models/playlist.dart';
import '../../settings/states/settings.dart';
import '../../videos/models/video_in_list.dart';
import '../models/search_type.dart';

part 'search.g.dart';

class SearchCubit<T extends SearchState> extends Cubit<SearchState> {
  final SettingsCubit settings;
  SearchCubit(super.initialState, this.settings) {
    onInit();
  }

  void onInit() {
    state.queryController.addListener(getSuggestions);
    if (state.searchNow) {
      search(state.queryController.value.text);
    }
  }

  @override
  Future<void> close() async {
    state.queryController.dispose();
    super.close();
  }

  void sortChanged(SearchSortBy? value) {
    var state = this.state.copyWith();
    state.sortBy = value ?? state.sortBy;
    emit(state);
    search(state.queryController.value.text);
  }

  void searchCleared() {
    if (state.queryController.value.text.isEmpty) {
      navigatorKey.currentState?.pop();
    } else {
      var state = this.state.copyWith();
      state.queryController.clear();
      state.showResults = false;
      emit(state);
    }
  }

  void getSuggestions({bool hideResult = true}) {
    var state = this.state.copyWith();
    state.showResults = !hideResult;
    emit(state);
    EasyDebounce.debounce('search-suggestions', const Duration(milliseconds: 500), () async {
      var state = this.state.copyWith();
      state.suggestions = (await service.getSearchSuggestion(state.queryController.value.text)).suggestions;
      emit(state);
    });
  }

  List<String> getHistory() {
    return settings.state.useSearchHistory ? db.getSearchHistory() : [];
  }

  search(String value) async {
    var state = this.state.copyWith();
    state.showResults = true;
    state.loading = true;
    state.videos = [];
    state.channels = [];
    state.playlists = [];
    emit(state);

    state = state.copyWith();
    List<SearchResults> results = await Future.wait([
      service.search(state.queryController.value.text, type: SearchType.video, sortBy: state.sortBy),
      service.search(state.queryController.value.text, type: SearchType.channel, sortBy: state.sortBy),
      service.search(state.queryController.value.text, type: SearchType.playlist, sortBy: state.sortBy)
    ]);

    state.videos = results[0].videos;
    state.channels = results[1].channels;
    state.playlists = results[2].playlists;
    state.loading = false;
    emit(state);
  }

  setSearchQuery(String e) {
    state.queryController.text = e;
    search(e);
  }

  void selectIndex(int value) {
    var state = this.state.copyWith();
    state.selectedIndex = value;
    emit(state);
  }
}

abstract class Clonable<T> {
  T clone();
}

@CopyWith(constructor: "inLine")
class SearchState extends Clonable<SearchState> {
  TextEditingController queryController;

  int selectedIndex;

  List<VideoInList> videos;

  List<Channel> channels;

  List<Playlist> playlists;


  bool searchNow;

  List<String> suggestions;

  SearchSortBy sortBy;

  bool showResults;

  bool loading;

  int videoPage, channelPage, playlistPage;

  SearchState(
      {TextEditingController? queryController,
      int? selectedIndex,
      List<VideoInList>? videos,
      List<Channel>? channels,
      List<Playlist>? playlists,
      bool? useHistory,
      bool? searchNow,
      List<String>? suggestions,
      SearchSortBy? sortBy,
      bool? showResults,
      bool? loading,
      int? videoPage,
      channelPage,
      playlistPage,
      String? query})
      : queryController = queryController ?? TextEditingController(text: query ?? ''),
        selectedIndex = selectedIndex ?? 0,
        channels = channels ?? [],
        videos = videos ?? [],
        playlists = playlists ?? [],
        searchNow = searchNow ?? false,
        suggestions = suggestions ?? [],
        sortBy = sortBy ?? SearchSortBy.relevance,
        showResults = showResults ?? false,
        loading = loading ?? false,
        videoPage = videoPage ?? 1,
        channelPage = channelPage ?? 1,
        playlistPage = playlistPage ?? 1;

  SearchState.inLine(this.queryController, this.selectedIndex, this.videos, this.channels, this.playlists,  this.searchNow, this.suggestions, this.sortBy, this.showResults,
      this.loading, this.videoPage, this.channelPage, this.playlistPage);

  @override
  SearchState clone() {
    return copyWith();
  }
}
