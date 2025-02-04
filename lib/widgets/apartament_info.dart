import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flat_match/widgets/other_info_item.dart';


class ApartmentInfo extends StatelessWidget {
  final Map<String, dynamic> userData;

  const ApartmentInfo({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  color: Colors.white.withOpacity(0.9),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 50, // Adjust the radius as needed
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: NetworkImage("https://magonsky.scay.net/img/room1.jpg"),
                          ),
                        ),
                        Text(
                          userData["apartamentAddress"],
                          style: const TextStyle(
                            fontSize: 24, 
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 16,
                          runSpacing: 8,
                          children: [
                            OtherInfoItem(
                              icon: Icons.pets,
                              value: userData["petPreference"],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container( 
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            userData["apartmentDescription"],
                            style: const TextStyle(fontSize: 16),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 250,
                          width: 600,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: FlutterMap(
                            options: MapOptions(
                              initialCenter: LatLng(userData["apartamentLocation"].latitude, userData["apartamentLocation"].longitude), // Default coordinates
                              initialZoom: 13.0,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    width: 100,
                                    height: 100,
                                    alignment: Alignment(0, -0.30),
                                    point: LatLng(userData["apartamentLocation"].latitude, userData["apartamentLocation"].longitude),
                                    child: const Icon(
                                      Icons.location_pin,
                                      color: Colors.purple,
                                      size: 40,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black,
                                          blurRadius: 15.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}