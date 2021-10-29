// To parse this JSON data, do
//
//     final reversQueryResponse = reversQueryResponseFromJson(jsonString);

// ignore_for_file: constant_identifier_names, duplicate_ignore

import 'dart:convert';

ReversQueryResponse reversQueryResponseFromJson(String str) =>
    ReversQueryResponse.fromJson(json.decode(str));

String reversQueryResponseToJson(ReversQueryResponse data) =>
    json.encode(data.toJson());

class ReversQueryResponse {
  ReversQueryResponse({
    required this.type,
    required this.query,
    required this.features,
    required this.attribution,
  });

  String type;
  List<double> query;
  List<Feature> features;
  String attribution;

  factory ReversQueryResponse.fromJson(Map<String, dynamic> json) =>
      ReversQueryResponse(
        type: json["type"],
        query: List<double>.from(json["query"].map((x) => x.toDouble())),
        features: List<Feature>.from(
            json["features"].map((x) => Feature.fromJson(x))),
        attribution: json["attribution"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "query": List<dynamic>.from(query.map((x) => x)),
        "features": List<dynamic>.from(features.map((x) => x.toJson())),
        "attribution": attribution,
      };
}

class Feature {
  Feature({
    required this.id,
    required this.type,
    required this.placeType,
    required this.relevance,
    required this.properties,
    required this.textEs,
    required this.placeNameEs,
    required this.text,
    required this.placeName,
    required this.center,
    required this.geometry,
    this.address,
    this.context,
    this.bbox,
    this.languageEs,
    this.language,
  });

  String id;
  String type;
  List<String> placeType;
  int relevance;
  Properties properties;
  String textEs;
  String placeNameEs;
  String text;
  String placeName;
  List<double> center;
  Geometry geometry;
  String? address;
  List<Context>? context;
  List<double>? bbox;
  Language? languageEs;
  Language? language;

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        id: json["id"],
        type: json["type"],
        placeType: List<String>.from(json["place_type"].map((x) => x)),
        relevance: json["relevance"],
        properties: Properties.fromJson(json["properties"]),
        textEs: json["text_es"],
        placeNameEs: json["place_name_es"],
        text: json["text"],
        placeName: json["place_name"],
        center: List<double>.from(json["center"].map((x) => x.toDouble())),
        geometry: Geometry.fromJson(json["geometry"]),
        address: json["address"],
        context: json["context"] == null
            ? null
            : List<Context>.from(
                json["context"].map((x) => Context.fromJson(x))),
        bbox: json["bbox"] == null
            ? null
            : List<double>.from(json["bbox"].map((x) => x.toDouble())),
        languageEs: Language.ES,
        language: Language.ES,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "place_type": List<dynamic>.from(placeType.map((x) => x)),
        "relevance": relevance,
        "properties": properties.toJson(),
        "text_es": textEs,
        "place_name_es": placeNameEs,
        "text": text,
        "place_name": placeName,
        "center": List<dynamic>.from(center.map((x) => x)),
        "geometry": geometry.toJson(),
        "address": address,
        "context": context == null
            ? null
            : List<dynamic>.from(context!.map((x) => x.toJson())),
        "bbox": bbox == null ? null : List<dynamic>.from(bbox!.map((x) => x)),
        "language_es": Language.ES,
        "language": Language.ES,
      };
}

class Context {
  Context({
    required this.id,
    required this.textEs,
    required this.text,
    this.wikidata,
    this.languageEs,
    this.language,
    this.shortCode,
  });

  String id;
  String textEs;
  String text;
  String? wikidata;
  Language? languageEs;
  Language? language;
  ShortCode? shortCode;

  factory Context.fromJson(Map<String, dynamic> json) => Context(
        id: json["id"],
        textEs: json["text_es"],
        text: json["text"],
        wikidata: json["wikidata"],
        languageEs: Language.ES,
        language: Language.ES,
        shortCode: json["short_code"] == null
            ? null
            : shortCodeValues.map[json["short_code"]],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "text_es": textEs,
        "text": text,
        "wikidata": wikidata,
        "language_es":
            languageEs == null ? null : languageValues.reverse[languageEs],
        "language": language == null ? null : languageValues.reverse[language],
        "short_code":
            shortCode == null ? null : shortCodeValues.reverse[shortCode],
      };
}

// ignore: constant_identifier_names
enum Language { ES, FR }

final languageValues = EnumValues({"es": Language.ES, "fr": Language.FR});

enum ShortCode { US_NY, US }

final shortCodeValues =
    EnumValues({"us": ShortCode.US, "US-NY": ShortCode.US_NY});

class Geometry {
  Geometry({
    required this.type,
    required this.coordinates,
  });

  String type;
  List<double> coordinates;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        type: json["type"],
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
      };
}

class Properties {
  Properties({
    this.accuracy,
    this.wikidata,
    this.shortCode,
  });

  String? accuracy;
  String? wikidata;
  ShortCode? shortCode;

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        accuracy: json["accuracy"],
        wikidata: json["wikidata"],
        shortCode: json["short_code"] == null
            ? null
            : shortCodeValues.map[json["short_code"]],
      );

  Map<String, dynamic> toJson() => {
        "accuracy": accuracy,
        "wikidata": wikidata,
        "short_code":
            shortCode == null ? null : shortCodeValues.reverse[shortCode],
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap;
    return reverseMap;
  }
}
