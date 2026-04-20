import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:petcare_store/src/features/my_pet/controller/my_pet_controller.dart';
import 'package:petcare_store/src/features/my_pet/models/pet_model.dart';
import 'package:petcare_store/src/helper/helper.dart';
import 'package:petcare_store/src/widgets/text_form_field_widgets.dart';

class AddPetBottomSheet extends StatefulWidget {
  const AddPetBottomSheet({super.key, this.pet});

  final PetModel? pet;

  @override
  State<AddPetBottomSheet> createState() => AddPetBottomSheetState();
}

class AddPetBottomSheetState extends State<AddPetBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final MyPetController _petController = Get.find<MyPetController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.pet != null) {
      nameController.text = widget.pet!.name;
      typeController.text = widget.pet!.type ?? '';
      breedController.text = widget.pet!.breed ?? '';
      ageController.text = widget.pet!.age?.toString() ?? '';
      genderController.text = widget.pet!.gender ?? '';
      latitudeController.text = widget.pet!.lat ?? '';
      longitudeController.text = widget.pet!.long ?? '';
      _existingAvatarUrl = widget.pet!.avatar;
    }
  }

  File? _imageFile;
  Uint8List? _imageBytes;
  String? _imageExtension;
  String? _existingAvatarUrl;

  @override
  void dispose() {
    nameController.dispose();
    typeController.dispose();
    ageController.dispose();
    breedController.dispose();
    genderController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: GestureDetector(
                        onTap: () => _pickerDialog(),
                        child: _buildImageSelector(context),
                      ),
                    ),
                    const SizedBox(height: 32),

                    _buildSectionHeader(
                      context,
                      'Basic Information',
                      HugeIcons.strokeRoundedUser,
                    ),
                    const SizedBox(height: 16),
                    TextFormFieldWidget(
                      label: "Pet name",
                      controller: nameController,
                      prefixIcon: HugeIcons.strokeRoundedNote01,
                      hintText: "What's your pet's name?",
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormFieldWidget(
                            label: "Type",
                            controller: typeController,
                            hintText: "e.g. Dog, Cat",
                            prefixIcon: HugeIcons.strokeRoundedNote01,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormFieldWidget(
                            label: "Gender",
                            controller: genderController,
                            hintText: "Male/Female",
                            prefixIcon: HugeIcons.strokeRoundedUser,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormFieldWidget(
                            label: "Breed",
                            controller: breedController,
                            hintText: "e.g. Husky",
                            prefixIcon: HugeIcons.strokeRoundedNote01,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormFieldWidget(
                            label: "Age (Years)",
                            controller: ageController,
                            keyboardType: TextInputType.number,
                            hintText: "e.g. 2",
                            prefixIcon: HugeIcons.strokeRoundedCalendar03,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                    _buildSectionHeader(
                      context,
                      'Location (Optional)',
                      HugeIcons.strokeRoundedLocation01,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormFieldWidget(
                            label: "Latitude",
                            controller: latitudeController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            prefixIcon: HugeIcons.strokeRoundedPinLocation01,
                            isRequired: false,
                            validator: (v) => null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormFieldWidget(
                            label: "Longitude",
                            controller: longitudeController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            prefixIcon: HugeIcons.strokeRoundedPinLocation01,
                            isRequired: false,
                            validator: (v) => null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  padding: const EdgeInsets.all(8),
                ),
              ),
              Text(
                widget.pet != null ? 'Edit Pet Profile' : 'Add New Pet',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(width: 48), // Placeholder for symmetry
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildImageSelector(BuildContext context) {
    final hasNewImage = _imageFile != null || _imageBytes != null;
    final hasExistingImage =
        _existingAvatarUrl != null && _existingAvatarUrl!.isNotEmpty;
    final hasImage = hasNewImage || hasExistingImage;

    return Stack(
      children: [
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(color: Colors.white, width: 4),
          ),
          child: ClipOval(
            child: hasImage
                ? _buildSelectedImage()
                : Container(
                    color: Colors.grey[100],
                    child: Icon(Icons.pets, size: 40, color: Colors.grey[400]),
                  ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 4,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              HugeIcons.strokeRoundedCamera01,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Colors.grey[300]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Obx(() {
              final isSaving = _petController.isSubmitting.value;
              return ElevatedButton(
                onPressed: isSaving ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  shadowColor: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.35),
                ),
                child: isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        widget.pet != null
                            ? 'Update Changes'
                            : 'Create Pet Profile',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedImage() {
    if (_imageFile != null) {
      return Image.file(_imageFile!, fit: BoxFit.cover);
    }
    if (_imageBytes != null) {
      return Image.memory(_imageBytes!, fit: BoxFit.cover);
    }
    if (_existingAvatarUrl != null && _existingAvatarUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: _existingAvatarUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey[200],
          child: const Icon(Icons.pets, color: Colors.grey),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[200],
          child: const Icon(Icons.pets, color: Colors.grey),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (widget.pet == null && _imageFile == null && _imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add a pet photo.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final parsedAge = int.tryParse(ageController.text.trim());
    if (parsedAge == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid age.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (widget.pet != null) {
      String? newAvatarUrl = widget.pet!.avatar;
      if (_imageFile != null || _imageBytes != null) {
        final Uint8List avatarBytes =
            _imageBytes ?? await _imageFile!.readAsBytes();
        newAvatarUrl = await _petController.uploadAvatarFromBytes(
          avatarBytes,
          extensionHint: _imageExtension,
        );
      }

      final updatedPet = widget.pet!.copyWith(
        name: nameController.text.trim(),
        type: typeController.text.trim().isEmpty
            ? null
            : typeController.text.trim(),
        breed: breedController.text.trim().isEmpty
            ? null
            : breedController.text.trim(),
        age: parsedAge,
        gender: genderController.text.trim().isEmpty
            ? null
            : genderController.text.trim(),
        lat: latitudeController.text.trim().isEmpty
            ? null
            : latitudeController.text.trim(),
        long: longitudeController.text.trim().isEmpty
            ? null
            : longitudeController.text.trim(),
        avatar: newAvatarUrl,
      );
      await _petController.updatePet(updatedPet);
    } else {
      final Uint8List avatarBytes =
          _imageBytes ?? await _imageFile!.readAsBytes();
      await _petController.addPet(
        name: nameController.text.trim(),
        type: typeController.text.trim(),
        breed: breedController.text.trim(),
        age: parsedAge,
        gender: genderController.text.trim(),
        lat: latitudeController.text.trim().isEmpty
            ? null
            : latitudeController.text.trim(),
        long: longitudeController.text.trim().isEmpty
            ? null
            : longitudeController.text.trim(),
        avatar: avatarBytes,
      );
    }

    if (!mounted) return;

    if (_petController.errorMessage.value == null) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          content: Text(
            widget.pet != null
                ? '🎉 Pet updated successfully!'
                : '🎉 Pet added successfully!',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            _petController.errorMessage.value ?? 'Unable to complete action.',
          ),
        ),
      );
    }
  }

  void _pickerDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose Source',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPickerOption(
                  context,
                  Icons.photo_library_rounded,
                  "Gallery",
                  () async {
                    Navigator.pop(context);
                    await Future.delayed(const Duration(milliseconds: 200));
                    Helper.imgFromGallery2(
                      (picked) => _setSelectedImage(picked),
                    );
                  },
                ),
                _buildPickerOption(
                  context,
                  Icons.camera_alt_rounded,
                  "Camera",
                  () async {
                    Navigator.pop(context);
                    await Future.delayed(const Duration(milliseconds: 200));
                    Helper.imgFromCamera((picked) => _setSelectedImage(picked));
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPickerOption(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 32,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  void _setSelectedImage(dynamic picked) {
    if (picked is File) {
      setState(() {
        _imageFile = picked;
        _imageBytes = null;
        _imageExtension = _fileExtension(picked.path);
      });
    } else if (picked is Uint8List) {
      setState(() {
        _imageBytes = picked;
        _imageFile = null;
        _imageExtension = '.jpg';
      });
    }
  }

  String _fileExtension(String path) {
    final dotIndex = path.lastIndexOf('.');
    if (dotIndex == -1) return '.jpg';
    return path.substring(dotIndex).toLowerCase();
  }
}
