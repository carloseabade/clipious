// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_in_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoInList _$VideoInListFromJson(Map<String, dynamic> json) => VideoInList(
      json['title'] as String,
      json['videoId'] as String,
      json['lengthSeconds'] as int,
      json['viewCount'] as int?,
      json['author'] as String?,
      json['authorId'] as String?,
      json['authorUrl'] as String?,
      json['published'] as int?,
      json['publishedText'] as String?,
      (json['videoThumbnails'] as List<dynamic>)
          .map((e) => ImageObject.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..index = json['index'] as int?
      ..indexId = json['indexId'] as String?;

Map<String, dynamic> _$VideoInListToJson(VideoInList instance) =>
    <String, dynamic>{
      'videoId': instance.videoId,
      'title': instance.title,
      'lengthSeconds': instance.lengthSeconds,
      'author': instance.author,
      'authorId': instance.authorId,
      'authorUrl': instance.authorUrl,
      'videoThumbnails': instance.videoThumbnails,
      'viewCount': instance.viewCount,
      'published': instance.published,
      'index': instance.index,
      'indexId': instance.indexId,
      'publishedText': instance.publishedText,
    };
