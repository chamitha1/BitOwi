import 'dart:convert';
import 'package:BitOwi/utils/tencent_sdk_models_wrapper.dart';

class LinkMessage {
  String? link;
  String? text;
  String? businessID;

  LinkMessage.fromJSON(Map json) {
    link = json["link"];
    text = json["text"];
    businessID = json["businessID"];
  }
}

LinkMessage? getLinkMessage(V2TimCustomElem? customElem) {
  try {
    if (customElem?.data != null) {
      final customMessage = jsonDecode(customElem!.data!);
      return LinkMessage.fromJSON(customMessage);
    }
    return null;
  } catch (err) {
    return null;
  }
}