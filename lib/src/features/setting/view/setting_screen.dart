import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get/route_manager.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:petcare_store/src/features/auth/controller/auth_controller.dart';
import 'package:petcare_store/src/features/profile/models/profile_model.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    final profile = Get.arguments as ProfileModel;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(context, profile)),
          SliverToBoxAdapter(child: _buildContent(context)),
        ],
      ),
    );
  }

  // _buildBody(BuildContext context, ProfileModel profile) {
  //   return Stack(
  //     children: [_buildHeader(context, profile), _buildContent(context)],
  //   );
  // }

  _buildHeader(BuildContext context, ProfileModel profile) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
      width: double.infinity,
      height: 280,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(35)),
      ),
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2),
          GestureDetector(
            onTap: () => Get.back(),
            child: Row(
              spacing: 12,
              children: [
                Icon(Icons.arrow_back, color: Colors.white),
                Text(
                  "Settings",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          Row(
            spacing: 12,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[200],
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: CachedNetworkImage(
                    imageUrl:
                        profile.avatar ??
                        "https://images.icon-icons.com/3446/PNG/512/account_profile_user_avatar_icon_219236.png",
                    fit: BoxFit.cover,
                    width: 200,
                    height: 200,
                    placeholder: (context, url) =>
                        Icon(Icons.person, color: Colors.grey[400]),
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error, color: Colors.redAccent),
                  ),
                ),
              ),
              Column(
                spacing: 2,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.name ?? "No Name",
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: Colors.white),
                  ),
                  Text(
                    profile.email ?? "No Email",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(18),

              border: Border.all(color: Colors.white54, width: 0.7),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 12,
              children: [
                Icon(HugeIcons.strokeRoundedEdit01, color: Colors.white),
                Text(
                  "Edit Profile",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildContent(BuildContext context) {
    AuthController authController = Get.find<AuthController>();
    return Positioned(
      top: 250, // directly below header
      left: 0,
      right: 0,
      bottom: 0, // optional
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
        ),
        child: Column(
          spacing: 20,
          children: [
            _listTile(
              context,
              title: "Address",
              icon: HugeIcons.strokeRoundedLocation01,
            ),
            Divider(height: 0.5, color: Colors.grey[300]),

            _listTile(
              context,
              title: "Password & Security",
              icon: HugeIcons.strokeRoundedSecurityCheck,
            ),
            _listTile(
              context,
              title: "Languages",
              icon: HugeIcons.strokeRoundedLanguageSquare,
            ),
            _listTile(
              context,
              title: "Theme",
              icon: HugeIcons.strokeRoundedMoon,
            ),
            _listTile(
              context,
              title: "Help Center",
              icon: HugeIcons.strokeRoundedHelpCircle,
            ),
            _listTile(
              context,
              title: "Contact Support",
              icon: HugeIcons.strokeRoundedContact,
            ),
            Divider(height: 0.5, color: Colors.grey[300]),
            _listTile(
              context,
              title: "Logout",
              icon: HugeIcons.strokeRoundedLogout01,
              color: Colors.red,
              onTap: () => authController.logout(),
            ),
          ],
        ),
      ),
    );
  }

  _listTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    VoidCallback? onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        horizontalTitleGap: 12,
        leading: CircleAvatar(backgroundColor: color, child: Icon(icon)),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: color),
        ),
        trailing: Icon(HugeIcons.strokeRoundedArrowRight01, color: color),
      ),
    );
  }
}
