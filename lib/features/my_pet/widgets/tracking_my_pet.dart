import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:petcare_store/features/my_pet/models/pet_model.dart';

class TrackingMyPet extends StatefulWidget {
  const TrackingMyPet({super.key});

  @override
  State<TrackingMyPet> createState() => _TrackingMyPetState();
}

class _TrackingMyPetState extends State<TrackingMyPet> {
  PetModel petInform = Get.arguments;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tracking My Pet")),
      body: _buildBody(),
      floatingActionButton: _builldFloatingActionButton(),
    );
  }

  _buildBody() => GoogleMap(
    mapType: MapType.hybrid,
    initialCameraPosition: _kGooglePlex,
    onMapCreated: (GoogleMapController controller) {
      _controller.complete(controller);
    },
  );

  _builldFloatingActionButton() => FloatingActionButton.extended(
    onPressed: _goToTheLake,
    label: Text("Go to the lake"),
    icon: HugeIcon(
      icon: HugeIcons.strokeRoundedLocation01,
      color: Theme.of(context).colorScheme.primary,
    ),
  );
  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
