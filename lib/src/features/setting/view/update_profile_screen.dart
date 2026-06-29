import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:petcare_store/src/features/profile/controller/profile_controller.dart';
import 'package:petcare_store/src/features/profile/models/profile_model.dart';
import 'package:petcare_store/src/widgets/reusables/custom_button.dart';

// ── Controller ───────────────────────────────────────────────────────────────

class UpdateProfileController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  final isSaving = false.obs;
  final ProfileController _profileController = Get.find<ProfileController>();

  @override
  void onInit() {
    super.onInit();
    final profile = _profileController.profile.value;
    if (profile != null) {
      nameController.text = profile.name ?? '';
      emailController.text = profile.email ?? '';
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }

  Future<void> saveProfile() async {
    if (!formKey.currentState!.validate()) return;

    final profile = _profileController.profile.value;
    if (profile == null) return;

    try {
      isSaving.value = true;
      final updatedProfile = ProfileModel(
        id: profile.id,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        avatar: profile.avatar,
        createdAt: profile.createdAt,
      );

      await _profileController.updateProfile(updatedProfile);
      Get.back();
    } catch (e) {
      debugPrint('Error saving profile: $e');
    } finally {
      isSaving.value = false;
    }
  }

  void pickPhoto() {
    // Hook up image_picker here
  }
}

// ── Screen ───────────────────────────────────────────────────────────────────

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});

  static const _green = Color(0xFF2F7C5B);
  static const _yellow = Color(0xFFFFC857);
  static const _border = Color(0xFFE8E8E8);
  static const _subtle = Color(0xFF9E9E9E);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateProfileController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: Colors.black,
            ),
          ),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: controller.formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 28),

                // ── Avatar ──────────────────────────────────────
                Center(
                  child: Obx(() {
                    final profile = controller._profileController.profile.value;
                    final avatarUrl = profile?.avatar;
                    final name = profile?.name ?? '';
                    final initials = name.isNotEmpty
                        ? name
                            .trim()
                            .split(' ')
                            .map((l) => l.isNotEmpty ? l[0].toUpperCase() : '')
                            .join()
                        : 'U';
                    final displayInitials = initials.length > 2
                        ? initials.substring(0, 2)
                        : initials;

                    return Stack(
                      children: [
                        Container(
                          width: 104,
                          height: 104,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: _green, width: 2.5),
                            boxShadow: [
                              BoxShadow(
                                color: _green.withValues(alpha: 0.15),
                                blurRadius: 20,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: const Color(0xFFE8F3EE),
                            backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                                ? CachedNetworkImageProvider(avatarUrl)
                                : null,
                            child: avatarUrl == null || avatarUrl.isEmpty
                                ? Text(
                                    displayInitials.isEmpty ? 'U' : displayInitials,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 28,
                                      fontWeight: FontWeight.w600,
                                      color: _green,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: GestureDetector(
                            onTap: controller.pickPhoto,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: _yellow,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: _yellow.withValues(alpha: 0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                size: 15,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),

                const SizedBox(height: 8),

                // ── Change photo label ──────────────────────────
                Center(
                  child: TextButton(
                    onPressed: controller.pickPhoto,
                    style: TextButton.styleFrom(
                      foregroundColor: _green,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                    ),
                    child: const Text(
                      'Change photo',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: _green,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ── Section label ───────────────────────────────
                const Text(
                  'PERSONAL INFO',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _subtle,
                    letterSpacing: 1.0,
                  ),
                ),

                const SizedBox(height: 12),

                // ── Name field ──────────────────────────────────
                _buildField(
                  label: 'Full Name',
                  controller: controller.nameController,
                  icon: Icons.person_outline_rounded,
                  keyboardType: TextInputType.name,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return 'Name is required';
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ── Email field ─────────────────────────────────
                _buildField(
                  label: 'Email Address',
                  controller: controller.emailController,
                  icon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return 'Email is required';
                    if (!GetUtils.isEmail(v.trim()))
                      return 'Enter a valid email';
                    return null;
                  },
                ),

                const SizedBox(height: 48),

                // ── Save Button ─────────────────────────────────
                Obx(
                  () => CustomButton(
                    onPressed: controller.saveProfile,
                    label: 'Save Changes',
                    isLoading: controller.isSaving.value,
                    backgroundColor: _green,
                  ),
                ),

                const SizedBox(height: 14),

                // ── Discard Button ──────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      foregroundColor: _subtle,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: const BorderSide(color: _border),
                      ),
                    ),
                    child: const Text(
                      'Discard',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: _subtle,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Reusable Field Builder ────────────────────────────────────────────────

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20, color: _green),
            filled: true,
            fillColor: const Color(0xFFF7F7F7),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _border, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _green, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
            errorStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 12),
          ),
        ),
      ],
    );
  }
}
