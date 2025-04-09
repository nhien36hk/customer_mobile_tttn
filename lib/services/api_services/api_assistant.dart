import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gotta_go/constants/map_key.dart';
import 'package:http/http.dart' as http;

class ApiAssistant {
  static Future<dynamic> requestApi(String url) async {
    try {
      http.Response httpResponse = await http.get(Uri.parse(url));

      if (httpResponse.statusCode == 200) {
        String responseData = httpResponse.body;
        var decodeResponseData = jsonDecode(responseData);
        return decodeResponseData;
      } else {
        return "Error Occured. Failed. No Response.";
      }
    } catch (exp) {
      return "Error Occured. Failed. No Response.";
    }
  }

  static String createApiDirectionLocation (LatLng origin, LatLng destination) {
    String url = "https://us1.locationiq.com/v1/directions/driving/${origin.longitude},${origin.latitude};${destination.longitude},${destination.latitude}?key=$locationIQ&steps=true&alternatives=true&geometries=polyline&overview=full&";

    return url;
  }
} 