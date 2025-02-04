import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';


/// Returns a bounding box (as a Map with keys 'southWest' and 'northEast')
/// that represents the area within [radiusInMeters] of [center].
Map<String, GeoPoint> geopointRange(GeoPoint center, double radiusInMeters) {
  const double earthRadius = 6378137.0; // in meters 
  
  // Angular distance in radians on a great circle.
  final double radDist = radiusInMeters / earthRadius;
  
  // Convert center point coordinates to radians.
  final double radLat = center.latitude * (pi / 180);
  final double radLng = center.longitude * (pi / 180);
  
  // Calculate the minimum and maximum latitudes.
  final double minLat = radLat - radDist;
  final double maxLat = radLat + radDist;
  
  double minLng, maxLng;
  // Check if our latitude does not exceed the poles.
  if (minLat > -pi / 2 && maxLat < pi / 2) {
    // Delta longitude in radians; note that it varies with latitude.
    final double deltaLng = asin(sin(radDist) / cos(radLat));
    minLng = radLng - deltaLng;
    maxLng = radLng + deltaLng;
  } else {
    // A pole is within the distance, so we return the full longitude range.
    minLng = -pi;
    maxLng = pi;
  }
  
  // Convert the results back to degrees.
  final GeoPoint southWest = GeoPoint(minLat * (180 / pi), minLng * (180 / pi));
  final GeoPoint northEast = GeoPoint(maxLat * (180 / pi), maxLng * (180 / pi));
  
  return {
    'southWest': southWest,
    'northEast': northEast,
  };
}
