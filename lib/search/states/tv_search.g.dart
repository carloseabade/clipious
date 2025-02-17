// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_search.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TvSearchStateCWProxy {
  TvSearchState resultFocus(FocusNode resultFocus);

  TvSearchState searchFocus(FocusNode searchFocus);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TvSearchState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TvSearchState(...).copyWith(id: 12, name: "My name")
  /// ````
  TvSearchState call({
    FocusNode? resultFocus,
    FocusNode? searchFocus,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTvSearchState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTvSearchState.copyWith.fieldName(...)`
class _$TvSearchStateCWProxyImpl implements _$TvSearchStateCWProxy {
  const _$TvSearchStateCWProxyImpl(this._value);

  final TvSearchState _value;

  @override
  TvSearchState resultFocus(FocusNode resultFocus) =>
      this(resultFocus: resultFocus);

  @override
  TvSearchState searchFocus(FocusNode searchFocus) =>
      this(searchFocus: searchFocus);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TvSearchState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TvSearchState(...).copyWith(id: 12, name: "My name")
  /// ````
  TvSearchState call({
    Object? resultFocus = const $CopyWithPlaceholder(),
    Object? searchFocus = const $CopyWithPlaceholder(),
  }) {
    return TvSearchState._(
      resultFocus == const $CopyWithPlaceholder() || resultFocus == null
          ? _value.resultFocus
          // ignore: cast_nullable_to_non_nullable
          : resultFocus as FocusNode,
      searchFocus == const $CopyWithPlaceholder() || searchFocus == null
          ? _value.searchFocus
          // ignore: cast_nullable_to_non_nullable
          : searchFocus as FocusNode,
    );
  }
}

extension $TvSearchStateCopyWith on TvSearchState {
  /// Returns a callable class that can be used as follows: `instanceOfTvSearchState.copyWith(...)` or like so:`instanceOfTvSearchState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TvSearchStateCWProxy get copyWith => _$TvSearchStateCWProxyImpl(this);
}
