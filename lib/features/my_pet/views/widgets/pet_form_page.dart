import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:petcare_store/features/my_pet/controller/my_pet_controller.dart';
import 'package:petcare_store/features/my_pet/models/pet_model.dart';
import 'package:petcare_store/helper/helper.dart';
import 'package:petcare_store/widgets/text_form_field_widgets.dart';

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
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.pet != null ? 'Edit Pet' : 'Add New Pet',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => _pickerDialog(),
                        child: _buildImageSelector(context),
                      ),
                      SizedBox(height: 30),
                      TextFormFieldWidget(
                        label: "Pet name",
                        controller: nameController,
                      ),
                      SizedBox(height: 16),
                      TextFormFieldWidget(
                        label: "Type",
                        controller: typeController,
                      ),
                      SizedBox(height: 16),
                      TextFormFieldWidget(
                        label: "Breed",
                        controller: breedController,
                      ),
                      SizedBox(height: 16),
                      TextFormFieldWidget(
                        label: "Age",
                        controller: ageController,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 16),
                      TextFormFieldWidget(
                        label: "Gender",
                        controller: genderController,
                      ),
                      SizedBox(height: 16),
                      TextFormFieldWidget(
                        label: "Latitude (optional)",
                        controller: latitudeController,
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) => null,
                      ),
                      SizedBox(height: 16),
                      TextFormFieldWidget(
                        label: "Longitude (optional)",
                        controller: longitudeController,
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) => null,
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[400],
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Obx(
                  () {
                    final isSaving = _petController.isSubmitting.value;
                    return Expanded(
                      child: ElevatedButton(
                        onPressed: isSaving ? null : _handleSubmit,
                        child: isSaving
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(widget.pet != null ? 'Update Pet' : 'Save Pet'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSelector(BuildContext context) {
    final hasNewImage = _imageFile != null || _imageBytes != null;
    final hasExistingImage = _existingAvatarUrl != null && _existingAvatarUrl!.isNotEmpty;
    final hasImage = hasNewImage || hasExistingImage;

    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: hasImage
            ? _buildSelectedImage()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    HugeIcons.strokeRoundedCamera01,
                    size: 32,
                    color: Colors.grey[600],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add Photo',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
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
          child: Icon(Icons.pets, color: Colors.grey[400]),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[200],
          child: Icon(Icons.pets, color: Colors.grey[400]),
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
        SnackBar(content: Text('Please add a pet photo.')),
      );
      return;
    }

    final parsedAge = int.tryParse(ageController.text.trim());
    if (parsedAge == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid age.')),
      );
      return;
    }

    if (widget.pet != null) {
      // Update pet
      String? newAvatarUrl = widget.pet!.avatar;

      // Upload new image if selected
      if (_imageFile != null || _imageBytes != null) {
        final Uint8List avatarBytes = _imageBytes ?? await _imageFile!.readAsBytes();
        newAvatarUrl = await _petController.uploadAvatarFromBytes(avatarBytes, extensionHint: _imageExtension);
      }

      final updatedPet = widget.pet!.copyWith(
        name: nameController.text.trim(),
        type: typeController.text.trim().isEmpty ? null : typeController.text.trim(),
        breed: breedController.text.trim().isEmpty ? null : breedController.text.trim(),
        age: parsedAge,
        gender: genderController.text.trim().isEmpty ? null : genderController.text.trim(),
        lat: latitudeController.text.trim().isEmpty ? null : latitudeController.text.trim(),
        long: longitudeController.text.trim().isEmpty ? null : longitudeController.text.trim(),
        avatar: newAvatarUrl,
      );
      await _petController.updatePet(updatedPet);
    } else {
      // Add pet
      final Uint8List avatarBytes = _imageBytes ?? await _imageFile!.readAsBytes();
      await _petController.addPet(
        name: nameController.text.trim(),
        type: typeController.text.trim(),
        breed: breedController.text.trim(),
        age: parsedAge,
        gender: genderController.text.trim(),
        lat: latitudeController.text.trim().isEmpty ? null : latitudeController.text.trim(),
        long: longitudeController.text.trim().isEmpty ? null : longitudeController.text.trim(),
        avatar: avatarBytes,
      );
    }

    if (!mounted) return;

    if (_petController.errorMessage.value == null) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          content: Text(widget.pet != null ? 'Pet updated successfully!' : 'Pet added successfully!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _petController.errorMessage.value ?? (widget.pet != null ? 'Unable to update pet. Please try again.' : 'Unable to add pet. Please try again.'),
          ),
        ),
      );
    }
  }

  _pickerDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.photo),
            title: Text("Gallery"),
            onTap: () async {
              Navigator.pop(
                context,
              ); // close the picker options, not the main sheet
              await Future.delayed(
                const Duration(milliseconds: 200),
              ); // wait a moment

              Helper.imgFromGallery2((picked) {
                _setSelectedImage(picked);
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text("Camera"),
            onTap: () async {
              Navigator.pop(context);
              await Future.delayed(const Duration(milliseconds: 200));
              Helper.imgFromCamera((picked) {
                _setSelectedImage(picked);
              });
            },
          ),
        ],
      ),
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
