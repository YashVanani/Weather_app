/// A model class to represent error information from API responses.
class ErrorModel {
  String? cod;
  String? message;

  ErrorModel({this.cod, this.message});

  /// JSON deserialization method to create an ErrorModel from a map.
  ErrorModel.fromJson(Map<String, dynamic> json) {
    cod = json['cod'];
    message = json['message'];
  }

  /// JSON serialization method to convert an ErrorModel instance to a map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cod'] = cod;
    data['message'] = message;
    return data;
  }
}
