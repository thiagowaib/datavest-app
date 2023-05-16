// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferencias.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Preferencia _$PreferenciaFromJson(Map<String, dynamic> json) => Preferencia(
      id: json['id'] as String,
      descricao: json['descricao'] as String,
      prefere: json['prefere'] as bool,
    );

Map<String, dynamic> _$PreferenciaToJson(Preferencia instance) =>
    <String, dynamic>{
      'id': instance.id,
      'descricao': instance.descricao,
      'prefere': instance.prefere,
    };
