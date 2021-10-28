// To parse this JSON data, do
//
//     final searchResponse = searchResponseFromJson(jsonString);

import 'dart:convert';

SearchResponse searchResponseFromJson(String str) =>
    SearchResponse.fromJson(json.decode(str));

String searchResponseToJson(SearchResponse data) => json.encode(data.toJson());

class SearchResponse {
  SearchResponse({
    this.type,
    this.query,
    this.features,
    this.attribution,
  });

  String? type;
  List<String>? query;
  List<Feature>? features;
  String? attribution;

  factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
        type: json["type"],
        query: List<String>.from(json["query"].map((x) => x)),
        features: List<Feature>.from(
            json["features"].map((x) => Feature.fromJson(x))),
        attribution: json["attribution"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "query": List<dynamic>.from(query!.map((x) => x)),
        "features": List<dynamic>.from(features!.map((x) => x.toJson())),
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
    required this.languageEs,
    required this.placeNameEs,
    required this.text,
    required this.language,
    required this.placeName,
    this.matchingText,
    this.matchingPlaceName,
    this.bbox,
    required this.center,
    required this.geometry,
    required this.context,
  });

  String id;
  String type;
  List<String> placeType;
  double relevance;
  Properties properties;
  String textEs;
  Language languageEs;
  String placeNameEs;
  String text;
  Language language;
  String placeName;
  String? matchingText;
  String? matchingPlaceName;
  List<double>? bbox;
  List<double> center;
  Geometry geometry;
  List<Context> context;

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        id: json["id"],
        type: json["type"],
        placeType: List<String>.from(json["place_type"].map((x) => x)),
        relevance: json["relevance"].toDouble(),
        properties: Properties.fromJson(json["properties"]),
        textEs: json["text_es"],
        languageEs: Language.ES,
        placeNameEs: json["place_name_es"],
        text: json["text"],
        language: Language.ES,
        placeName: json["place_name"],
        matchingText: json["matching_text"],
        matchingPlaceName: json["matching_place_name"],
        bbox: json["bbox"] == null
            ? null
            : List<double>.from(json["bbox"].map((x) => x.toDouble())),
        center: List<double>.from(json["center"].map((x) => x.toDouble())),
        geometry: Geometry.fromJson(json["geometry"]),
        context:
            List<Context>.from(json["context"].map((x) => Context.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "place_type": List<dynamic>.from(placeType.map((x) => x)),
        "relevance": relevance,
        "properties": properties.toJson(),
        "text_es": textEs,
        "language_es": languageEs,
        "place_name_es": placeNameEs,
        "text": text,
        "language": language,
        "place_name": placeName,
        "matching_text": matchingText,
        "matching_place_name": matchingPlaceName,
        "bbox": bbox == null ? null : List<dynamic>.from(bbox!.map((x) => x)),
        "center": List<dynamic>.from(center.map((x) => x)),
        "geometry": geometry.toJson(),
        "context": List<dynamic>.from(context.map((x) => x.toJson())),
      };
}

class Context {
  Context({
    required this.id,
    required this.wikidata,
    this.shortCode,
    required this.textEs,
    required this.languageEs,
    required this.text,
    required this.language,
  });

  String id;
  String? wikidata;
  String? shortCode;
  String textEs;
  Language languageEs;
  String text;
  Language language;

  factory Context.fromJson(Map<String, dynamic> json) => Context(
        id: json["id"],
        wikidata: json["wikidata"],
        shortCode: json["short_code"],
        textEs: json["text_es"],
        languageEs: Language.ES,
        text: json["text"],
        language: Language.ES,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "wikidata": wikidata,
        "short_code": shortCode,
        "text_es": textEs,
        "language_es": languageValues.reverse[languageEs],
        "text": text,
        "language": languageValues.reverse[language],
      };
}

// ignore: constant_identifier_names
enum Language { ES }

final languageValues = EnumValues({"es": Language.ES});

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
    this.wikidata,
    this.shortCode,
    this.foursquare,
    this.landmark,
    this.category,
    this.address,
  });

  String? wikidata;
  String? shortCode;
  String? foursquare;
  bool? landmark;
  String? category;
  String? address;

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        wikidata: json["wikidata"],
        shortCode: json["short_code"],
        foursquare: json["foursquare"],
        landmark: json["landmark"],
        category: json["category"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "wikidata": wikidata,
        "short_code": shortCode,
        "foursquare": foursquare,
        "landmark": landmark,
        "category": category,
        "address": address,
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
