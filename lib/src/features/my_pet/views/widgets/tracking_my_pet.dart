import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TrackingMyPet extends StatefulWidget {
  const TrackingMyPet({super.key});

  @override
  State<TrackingMyPet> createState() => _TrackingMyPetState();
}

class _TrackingMyPetState extends State<TrackingMyPet> {
  final globalKey = GlobalKey();
  MapController mapController = MapController();
  LatLng start = LatLng(11.5241805, 104.8744108);
  LatLng end = LatLng(11.5141805, 104.8744108);
  List<LatLng> routePoints = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRoute();
  }

  Future<void> _fetchRoute() async {
    final String url =
        'http://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List coordinates = data['routes'][0]['geometry']['coordinates'];
        setState(() {
          routePoints = coordinates.map<LatLng>((coord) => LatLng(coord[1], coord[0])).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Tracking Pet'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: start,
        minZoom: 1,
        maxZoom: 100,
        initialZoom: 13,
      ),

      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'dev.fleaflet.flutter_map.example',
        ),

        MarkerLayer(
          markers: [
            Marker(
              width: 80.0,
              height: 80.0,
              point: start,
              child: Builder(
                builder: (context) => const HugeIcon(
                  icon: HugeIcons.strokeRoundedLocation01,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              points: routePoints.isNotEmpty ? routePoints : [start, end],
              strokeWidth: 4,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 80.0,
              height: 80.0,
              point: end,
              child: Builder(
                builder: (context) => const HugeIcon(
                  icon: HugeIcons.strokeRoundedLocation01,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
