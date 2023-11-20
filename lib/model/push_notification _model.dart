// To parse this JSON data, do
//
//     final pushNotificationEntity = pushNotificationEntityFromJson(jsonString);

import 'dart:convert';

PushNotificationEntity pushNotificationEntityFromJson(String str) =>
    PushNotificationEntity.fromJson(json.decode(str));

String pushNotificationEntityToJson(PushNotificationEntity data) =>
    json.encode(data.toJson());

class PushNotificationEntity {
  String? badge;
  String? sound;
  String? redirectOn;
  String? body;
  String? type;
  String? title;
  String? senderId;

  PushNotificationEntity({
    this.badge,
    this.sound,
    this.redirectOn,
    this.body,
    this.type,
    this.title,
    this.senderId,
  });

  factory PushNotificationEntity.fromJson(Map<String, dynamic> json) =>
      PushNotificationEntity(
        badge: json["badge"],
        sound: json["sound"],
        redirectOn: json["redirect_on"],
        body: json["body"],
        type: json["type"],
        title: json["title"],
        senderId: json["sender_id"],
      );

  Map<String, dynamic> toJson() => {
        "badge": badge,
        "sound": sound,
        "redirect_on": redirectOn,
        "body": body,
        "type": type,
        "title": title,
        "sender_id": senderId,
      };
}
