abstract class JsonSerializable {
  dynamic fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}
