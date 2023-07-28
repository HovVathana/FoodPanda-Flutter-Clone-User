import 'dart:convert';
import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

class Suggestion {
  final String placeId;
  final String mainText;
  final String secondaryText;

  Suggestion(this.placeId, this.mainText, this.secondaryText);

  // @override
  // String toString() {
  //   return 'Suggestion(description: $description, placeId: $placeId)';
  // }
}

class NetworkUtils {
  final client = Client();

  static final String androidKey = 'AIzaSyCG2YHIuPJYMOJzS6wSw5eZ0dTYXnhZFLs';
  static final String iosKey = 'AIzaSyCG2YHIuPJYMOJzS6wSw5eZ0dTYXnhZFLs';
  final apiKey = Platform.isAndroid ? androidKey : iosKey;

  Future<List<Suggestion>> fetchSuggestions(String input) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&components=country:kh&key=$apiKey';
    final response = await client.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        return result['predictions']
            .map<Suggestion>(
              (p) => Suggestion(
                p['place_id'],
                p['structured_formatting']['main_text'],
                p['structured_formatting']['secondary_text'],
              ),
            )
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future getPlaceDetailFromId(String placeId) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=geometry&key=$apiKey';
    final response = await client.get(Uri.parse(request));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        print(response.body);
        LatLng latLng = LatLng(
          result['result']['geometry']['location']['lat'],
          result['result']['geometry']['location']['lng'],
        );
        return latLng;
        // final components =
        //     result['result']['address_components'] as List<dynamic>;
        // build result
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }
}
