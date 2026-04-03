import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:petcare_store/src/config/core/routes/app_routes.dart';
import '../../models/pet_model.dart';

class PetDetailsView extends StatelessWidget {
  final PetModel? pet;

  const PetDetailsView({super.key, this.pet});

  // Mock pet data for demonstration - in real app this would come from navigation arguments
  PetModel get _mockPet => PetModel.fromMap({
    'id': '1',
    'owner': 'mock_owner',
    'name': 'Buddy',
    'breed': 'Golden Retriever',
    'age': 2,
    'gender': 'Male',
    'avatar':
        'https://t4.ftcdn.net/jpg/02/66/72/41/360_F_266724172_Iy8gdKgMa7XmrhYYxLCxyhx6J7070Pr8.jpg',
  });

  PetModel get currentPet => pet ?? _mockPet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(context), body: _buildBody(context));
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        '${currentPet.name} Details',
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Get.toNamed(AppRoutes.trackingPet, arguments: currentPet);
          },
          icon: Icon(HugeIcons.strokeRoundedLocation01),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pet Header Section
            _buildPetHeader(context),
            const SizedBox(height: 24),

            // Basic Information Cards
            _buildBasicInfoSection(context),
            const SizedBox(height: 24),

            // Health Details Section
            // _buildHealthSection(context),
            // const SizedBox(height: 24),

            // // Feeding Information Section
            // _buildFeedingSection(context),
            // const SizedBox(height: 24),

            // Location Section
            _buildLocationSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPetHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Hero(
          tag: 'pet_image_${currentPet.id}',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: _buildPetImageWidget(),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentPet.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                currentPet.breed.toString(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  // color: ,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  currentPet.gender.toString(),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection(BuildContext context) {
    final basicInfo = [
      {
        "Color": Colors.amber.shade100,
        "title": "Age",
        "value": currentPet.age != null ? '${currentPet.age} years' : 'N/A',
        "icon": HugeIcons.strokeRoundedCalendar03,
      },
      {
        "Color": Colors.green.shade100,
        "title": "Gender",
        "value": currentPet.gender ?? 'N/A',
        "icon": HugeIcons.strokeRoundedUser,
      },
      {
        "Color": Colors.blue.shade100,
        "title": "Type",
        "value": currentPet.type ?? 'N/A',
        "icon": HugeIcons.strokeRoundedFavourite,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Basic Information',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: basicInfo
              .map(
                (item) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: item["Color"] as Color,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          item["icon"] as IconData,
                          size: 24,
                          color: Colors.black87,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item["title"] as String,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item["value"] as String,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  // Widget _buildHealthSection(BuildContext context) {
  //   return _buildSectionCard(
  //     context,
  //     title: 'Health Details',
  //     icon: HugeIcons.strokeRoundedFavourite,
  //     color: Colors.red.shade50,
  //     children: [
  //       _buildInfoRow(
  //         context,
  //         'Vaccination Status',
  //         currentPet.vaccinationStatus,
  //         HugeIcons.strokeRoundedShield01,
  //       ),
  //       _buildInfoRow(
  //         context,
  //         'Last Checkup',
  //         currentPet.lastCheckup,
  //         HugeIcons.strokeRoundedCalendar03,
  //       ),
  //       _buildInfoRow(
  //         context,
  //         'Next Checkup',
  //         currentPet.nextCheckup,
  //         HugeIcons.strokeRoundedCalendarAdd01,
  //       ),
  //       if (currentPet.allergies.isNotEmpty)
  //         _buildInfoRow(
  //           context,
  //           'Allergies',
  //           currentPet.allergies.join(', '),
  //           HugeIcons.strokeRoundedNotification02,
  //         ),
  //       _buildInfoRow(
  //         context,
  //         'Medical Conditions',
  //         currentPet.medicalConditions,
  //         HugeIcons.strokeRoundedNotification02,
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildFeedingSection(BuildContext context) {
  //   return _buildSectionCard(
  //     context,
  //     title: 'Feeding Information',
  //     icon: HugeIcons.strokeRoundedShoppingBag01,
  //     color: Colors.orange.shade50,
  //     children: [
  //       _buildInfoRow(
  //         context,
  //         'Food Type',
  //         currentPet.foodType,
  //         HugeIcons.strokeRoundedShoppingBag01,
  //       ),
  //       _buildInfoRow(
  //         context,
  //         'Feeding Schedule',
  //         currentPet.feedingSchedule,
  //         HugeIcons.strokeRoundedTime02,
  //       ),
  //       _buildInfoRow(
  //         context,
  //         'Daily Portion',
  //         currentPet.dailyPortion,
  //         HugeIcons.strokeRoundedWeightScale,
  //       ),
  //       _buildInfoRow(
  //         context,
  //         'Special Diet',
  //         currentPet.specialDiet,
  //         HugeIcons.strokeRoundedLeaf01,
  //       ),
  //     ],
  //   );
  // }

  Widget _buildLocationSection(BuildContext context) {
    if (currentPet.lat == null || currentPet.long == null) {
      return const SizedBox.shrink();
    }

    return _buildSectionCard(
      context,
      title: 'Location',
      icon: HugeIcons.strokeRoundedLocation01,
      color: Colors.blue.shade50,
      children: [
        _buildInfoRow(
          context,
          'Latitude',
          currentPet.lat!,
          HugeIcons.strokeRoundedLocation01,
        ),
        _buildInfoRow(
          context,
          'Longitude',
          currentPet.long!,
          HugeIcons.strokeRoundedLocation01,
        ),
      ],
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 24, color: Colors.black87),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.black54),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetImageWidget({double size = 120}) {
    final placeholder = _buildPetImagePlaceholder(size);

    if (currentPet.avatar == null || currentPet.avatar!.isEmpty) {
      return placeholder;
    }

    return CachedNetworkImage(
      imageUrl: currentPet.avatar!,
      height: size,
      width: size,
      fit: BoxFit.cover,
      placeholder: (context, url) => placeholder,
      errorWidget: (context, url, error) => placeholder,
    );
  }

  Widget _buildPetImagePlaceholder(double size) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(Icons.pets, color: Colors.grey[400], size: size * 0.35),
    );
  }
}

class PersonalDetailsCat extends StatelessWidget {
  final Color color;
  final String? title;
  final String? value;

  const PersonalDetailsCat({
    super.key,
    required this.color,
    this.title,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      width: MediaQuery.of(context).size.width / 3.5,
      height: 80,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("$title", style: Theme.of(context).textTheme.titleSmall),
          Text("$value", style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
