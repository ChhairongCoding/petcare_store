import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:petcare_store/src/features/shipping/controller/shipping_controller.dart';

enum AddressLabel { home, office, other }

class AddressFormScreen extends StatefulWidget {
  const AddressFormScreen({super.key});

  @override
  State<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final MapController _mapController = MapController();

  final TextEditingController _streetCtrl = TextEditingController();
  final TextEditingController _aptCtrl = TextEditingController();
  final TextEditingController _cityCtrl = TextEditingController();
  final TextEditingController _provinceCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();

  LatLng _selectedLocation = const LatLng(11.54954, 104.87377);

  bool _isMoving = false;

  AddressLabel _selectedLabel = AddressLabel.home;

  late final AnimationController _pinAnim;
  late final Animation<double> _pinOffset;

  @override
  void initState() {
    super.initState();

    _pinAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    _pinOffset = Tween<double>(
      begin: 0,
      end: -8,
    ).animate(CurvedAnimation(parent: _pinAnim, curve: Curves.easeInOut));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ShippingController>().reverseGeocode(_selectedLocation);
    });
  }

  @override
  void dispose() {
    _pinAnim.dispose();
    _mapController.dispose();

    _streetCtrl.dispose();
    _aptCtrl.dispose();
    _cityCtrl.dispose();
    _provinceCtrl.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: _buildAppBar(theme),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildMap(theme),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetectedLocation(theme),

                    const SizedBox(height: 16),

                    _buildLabelSection(theme),

                    const SizedBox(height: 16),

                    _buildDivider(theme),

                    const SizedBox(height: 16),

                    _buildLocationDetails(theme),

                    const SizedBox(height: 16),

                    _buildDivider(theme),

                    const SizedBox(height: 16),

                    _buildContactSection(theme),

                    const SizedBox(height: 24),

                    _buildConfirmButton(theme),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return AppBar(
      scrolledUnderElevation: 0,
      elevation: 0,
      backgroundColor: theme.scaffoldBackgroundColor,
      title: Text('Add Address'),

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.5),
        child: Container(height: 0.5, color: theme.dividerColor),
      ),
    );
  }

  Widget _buildMap(ThemeData theme) {
    final colors = theme.colorScheme;

    return SizedBox(
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selectedLocation,
              initialZoom: 15,
              onMapEvent: (event) {
                if (event is MapEventMoveStart) {
                  setState(() {
                    _isMoving = true;
                  });
                } else if (event is MapEventMoveEnd ||
                    event is MapEventFlingAnimationEnd) {
                  setState(() {
                    _isMoving = false;

                    _selectedLocation = _mapController.camera.center;
                  });

                  Get.find<ShippingController>().reverseGeocode(
                    _selectedLocation,
                  );
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.petcarestore.app',
              ),
            ],
          ),

          AnimatedBuilder(
            animation: _pinOffset,
            builder: (_, __) {
              return Transform.translate(
                offset: Offset(0, _isMoving ? -16 : _pinOffset.value),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: colors.primary,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                          bottomLeft: Radius.circular(24),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.location_on,
                        color: colors.onPrimary,
                        size: 24,
                      ),
                    ),

                    Container(
                      width: 12,
                      height: 4,
                      margin: const EdgeInsets.only(top: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          Positioned(
            bottom: 14,
            right: 14,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(width: 0.5, color: theme.dividerColor),
                ),
                child: Icon(Icons.gps_fixed, size: 16, color: colors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetectedLocation(ThemeData theme) {
    final colors = theme.colorScheme;

    final ctrl = Get.find<ShippingController>();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 0.5, color: theme.dividerColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.location_on_outlined,
              color: colors.primary,
              size: 20,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DETECTED LOCATION',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.08,
                  ),
                ),

                const SizedBox(height: 4),

                Obx(() {
                  if (ctrl.isGeocoding.value) {
                    return SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: colors.primary,
                      ),
                    );
                  }

                  return Text(
                    ctrl.addressText.value.isEmpty
                        ? 'Move map to detect address'
                        : ctrl.addressText.value,
                    style: theme.textTheme.bodyMedium,
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelSection(ThemeData theme) {
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(theme, 'Label this address'),

        const SizedBox(height: 10),

        Row(
          children: AddressLabel.values.map((label) {
            final active = _selectedLabel == label;

            final info = _labelInfo(label);

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedLabel = label;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: active
                        ? colors.primary.withValues(alpha: 0.08)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      width: 0.5,
                      color: active ? colors.primary : theme.dividerColor,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        info.$2,
                        size: 14,
                        color: active ? colors.primary : colors.onSurface,
                      ),

                      const SizedBox(width: 5),

                      Text(
                        info.$1,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 13,
                          fontWeight: active
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: active ? colors.primary : colors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLocationDetails(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(theme, 'Location details'),

        const SizedBox(height: 12),

        _fieldLabel(theme, 'Street address'),

        const SizedBox(height: 4),

        _inputField(
          theme,
          controller: _streetCtrl,
          hint: '123 Modern Ave',
          icon: Icons.map_outlined,
        ),

        const SizedBox(height: 12),

        _fieldLabel(theme, 'Apartment / Suite'),

        const SizedBox(height: 4),

        _inputField(
          theme,
          controller: _aptCtrl,
          hint: 'Apt, floor, unit...',
          icon: Icons.apartment_outlined,
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel(theme, 'City'),

                  const SizedBox(height: 4),

                  _inputField(theme, controller: _cityCtrl, hint: 'City'),
                ],
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel(theme, 'Province'),

                  const SizedBox(height: 4),

                  _inputField(
                    theme,
                    controller: _provinceCtrl,
                    hint: 'Province',
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContactSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(theme, 'Contact'),

        const SizedBox(height: 12),

        _contactRow(
          theme,
          icon: Icons.person_outline,
          controller: _nameCtrl,
          hint: 'User name',
        ),

        const SizedBox(height: 10),

        _contactRow(
          theme,
          icon: Icons.phone_outlined,
          controller: _phoneCtrl,
          hint: 'Phone number',
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  Widget _contactRow(
    ThemeData theme, {
    required IconData icon,
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 0.5, color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),

          const SizedBox(width: 10),

          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Required';
                }
                return null;
              },
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(ThemeData theme) {
    final colors = theme.colorScheme;

    return Obx(() {
      final ctrl = Get.find<ShippingController>();

      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: ctrl.isLoading.value
              ? null
              : () {
                  if (!_formKey.currentState!.validate()) return;
                  ctrl.addAdress(
                    name: _nameCtrl.text,
                    addressDetail: ctrl.addressText.value,
                    lat: _selectedLocation.latitude,
                    lng: _selectedLocation.longitude,
                    isDefault: false,
                    phoneNumber: _phoneCtrl.text,
                    city: _cityCtrl.text,
                    streetAddress: _streetCtrl.text,
                    apartmentSuite: _aptCtrl.text,
                    labelAddress: _selectedLabel.index,
                  );
                },
          icon: ctrl.isLoading.value
              ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colors.onPrimary,
                  ),
                )
              : const Icon(Icons.check, size: 18),
          label: const Text('Confirm address'),
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.primary,
            foregroundColor: colors.onPrimary,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    });
  }

  Widget _sectionLabel(ThemeData theme, String text) {
    return Text(
      text.toUpperCase(),
      style: theme.textTheme.bodySmall?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.08,
      ),
    );
  }

  Widget _fieldLabel(ThemeData theme, String text) {
    return Text(
      text,
      style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
    );
  }

  Widget _inputField(
    ThemeData theme, {
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        prefixIcon: icon != null
            ? Icon(icon, size: 18, color: theme.colorScheme.primary)
            : null,
        hintText: hint,
        hintStyle: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 0.5, color: theme.dividerColor),
        ),
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Divider(height: 1, thickness: 0.5, color: theme.dividerColor);
  }

  (String, IconData) _labelInfo(AddressLabel label) {
    switch (label) {
      case AddressLabel.home:
        return ('Home', Icons.home_outlined);

      case AddressLabel.office:
        return ('Office', Icons.work_outline);

      case AddressLabel.other:
        return ('Other', Icons.more_horiz);
    }
  }
}
