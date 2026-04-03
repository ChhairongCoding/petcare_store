import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:petcare_store/src/features/shipping/controller/shipping_controller.dart';
import 'package:petcare_store/src/widgets/text_form_field_widgets.dart';

class AddressFormScreen extends StatefulWidget {
  const AddressFormScreen({super.key});

  @override
  State<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  final TextEditingController addressName = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final MapController mapController = MapController();

  LatLng _selectedLocation = LatLng(11.54954, 104.87377);
  bool _isMoving = false;

  @override
  void initState() {
    super.initState();
    final ShippingController shippingController = Get.find();

    /// Detect address on screen open
    shippingController.reverseGeocode(_selectedLocation);
  }

  @override
  void dispose() {
    addressName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ShippingController shippingController = Get.find();
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Address Form")),
      body: _buildBody(theme, shippingController),
    );
  }

  Padding _buildBody(TextTheme theme, ShippingController shippingController) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Obx(
        () => Column(
          children: [
            /// FORM AREA
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    spacing: 10,
                    children: [
                      /// Address Name
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Name", style: theme.bodyLarge),
                          TextFormFieldWidget(
                            hintText: "Home / Office...",
                            controller: addressName,
                          ),
                        ],
                      ),

                      /// Address Detail
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Address Detail", style: theme.bodyLarge),
                          TextFormFieldWidget(
                            hintText: "Input detail address...",
                            controller: shippingController.addressDetail,
                            sizeHeight: 120,
                          ),
                        ],
                      ),

                      /// Detected Address
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Obx(() {
                          if (shippingController.isGeocoding.value) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 15,
                                    height: 15,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text("Detecting address..."),
                                ],
                              ),
                            );
                          }

                          if (shippingController.addressText.value.isEmpty) {
                            return const Text("Move map to detect address");
                          }
                          return SizedBox();
                        }),
                      ),

                      /// MAP
                      SizedBox(
                        height: 350,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              /// MAP
                              FlutterMap(
                                mapController: mapController,
                                options: MapOptions(
                                  initialCenter: _selectedLocation,
                                  initialZoom: 14,
                                  onMapEvent: (event) {
                                    if (event is MapEventMoveStart) {
                                      setState(() => _isMoving = true);
                                    } else if (event is MapEventMoveEnd ||
                                        event is MapEventFlingAnimationEnd) {
                                      setState(() {
                                        _isMoving = false;
                                        _selectedLocation =
                                            mapController.camera.center;
                                      });

                                      shippingController.reverseGeocode(
                                        _selectedLocation,
                                      );
                                    }
                                  },
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    userAgentPackageName:
                                        "com.petcarestore.app",
                                  ),
                                ],
                              ),

                              /// PIN
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: EdgeInsets.only(
                                  bottom: _isMoving ? 20 : 0,
                                ),
                                child: Icon(
                                  Icons.location_pin,
                                  color: Colors.redAccent,
                                  size: 50,
                                  shadows: _isMoving
                                      ? [
                                          const Shadow(
                                            blurRadius: 8,
                                            color: Colors.black38,
                                            offset: Offset(0, 4),
                                          ),
                                        ]
                                      : [],
                                ),
                              ),

                              /// COORDINATES
                              Positioned(
                                bottom: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    '${_selectedLocation.latitude.toStringAsFixed(5)}, '
                                    '${_selectedLocation.longitude.toStringAsFixed(5)}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// CONFIRM BUTTON
            Row(
              children: [
                Expanded(
                  child:
                      /// CONFIRM BUTTON
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            shippingController.addAdress(
                              name: addressName.text,
                              addressDetail: shippingController
                                  .addressDetail
                                  .text, // .text to get String
                              lat: _selectedLocation.latitude, // lat
                              lng: _selectedLocation.longitude, // lng
                              isDefault: false,
                            );
                          }
                        },
                        child: shippingController.isLoading == true
                            ? CircularProgressIndicator.adaptive()
                            : const Text("Confirm"),
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
