import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../models/pet_model.dart';

class PetDetailsView extends StatelessWidget {
  final Pet? pet;

  const PetDetailsView({super.key, this.pet});

  // Mock pet data for demonstration - in real app this would come from navigation arguments
  Pet get _mockPet => Pet.fromMap({
    'id': 1,
    'name': 'Buddy',
    'breed': 'Golden Retriever',
    'age': '2 years',
    'weight': '25 kg',
    'gender': 'Male',
    'image': 'https://t4.ftcdn.net/jpg/02/66/72/41/360_F_266724172_Iy8gdKgMa7XmrhYYxLCxyhx6J7070Pr8.jpg',
    'color': Colors.amber.shade100,
    'vaccinationStatus': 'Up to date',
    'lastCheckup': '2024-09-15',
    'nextCheckup': '2025-03-15',
    'allergies': ['Chicken', 'Beef'],
    'medicalConditions': 'None',
    'foodType': 'Premium dry kibble',
    'feedingSchedule': '2 times per day (8 AM, 6 PM)',
    'dailyPortion': '250g',
    'specialDiet': 'Grain-free formula',
    'distanceToVet': 2.3,
    'nearestVetName': 'City Pet Clinic',
    'vetAddress': '123 Main St, Downtown',
  });

  Pet get currentPet => pet ?? _mockPet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        '${currentPet.name} Details',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            // Edit pet functionality
          },
          icon: Icon(HugeIcons.strokeRoundedEdit01),
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
            _buildHealthSection(context),
            const SizedBox(height: 24),

            // Feeding Information Section
            _buildFeedingSection(context),
            const SizedBox(height: 24),

            // Distance/Location Section
            _buildDistanceSection(context),
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
            child: CachedNetworkImage(
              imageUrl: currentPet.image,
              height: 120,
              width: 120,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.pets,
                  color: Colors.grey[400],
                  size: 40,
                ),
              ),
              errorWidget: (context, url, error) => Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.pets,
                  color: Colors.grey[400],
                  size: 40,
                ),
              ),
            ),
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
                currentPet.breed,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: currentPet.color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  currentPet.gender,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
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
        "value": currentPet.age,
        "icon": HugeIcons.strokeRoundedCalendar03,
      },
      {
        "Color": Colors.blue.shade100,
        "title": "Weight",
        "value": currentPet.weight,
        "icon": HugeIcons.strokeRoundedWeightScale,
      },
      {
        "Color": Colors.green.shade100,
        "title": "Gender",
        "value": currentPet.gender,
        "icon": HugeIcons.strokeRoundedUser,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Basic Information',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
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
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item["value"] as String,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
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

  Widget _buildHealthSection(BuildContext context) {
    return _buildSectionCard(
      context,
      title: 'Health Details',
      icon: HugeIcons.strokeRoundedFavourite,
      color: Colors.red.shade50,
      children: [
        _buildInfoRow(context, 'Vaccination Status', currentPet.vaccinationStatus, HugeIcons.strokeRoundedShield01),
        _buildInfoRow(context, 'Last Checkup', currentPet.lastCheckup, HugeIcons.strokeRoundedCalendar03),
        _buildInfoRow(context, 'Next Checkup', currentPet.nextCheckup, HugeIcons.strokeRoundedCalendarAdd01),
        if (currentPet.allergies.isNotEmpty)
          _buildInfoRow(context, 'Allergies', currentPet.allergies.join(', '), HugeIcons.strokeRoundedNotification02),
        _buildInfoRow(context, 'Medical Conditions', currentPet.medicalConditions, HugeIcons.strokeRoundedNotification02),
      ],
    );
  }

  Widget _buildFeedingSection(BuildContext context) {
    return _buildSectionCard(
      context,
      title: 'Feeding Information',
      icon: HugeIcons.strokeRoundedShoppingBag01,
      color: Colors.orange.shade50,
      children: [
        _buildInfoRow(context, 'Food Type', currentPet.foodType, HugeIcons.strokeRoundedShoppingBag01),
        _buildInfoRow(context, 'Feeding Schedule', currentPet.feedingSchedule, HugeIcons.strokeRoundedTime02),
        _buildInfoRow(context, 'Daily Portion', currentPet.dailyPortion, HugeIcons.strokeRoundedWeightScale),
        _buildInfoRow(context, 'Special Diet', currentPet.specialDiet, HugeIcons.strokeRoundedLeaf01),
      ],
    );
  }

  Widget _buildDistanceSection(BuildContext context) {
    return _buildSectionCard(
      context,
      title: 'Nearest Veterinary',
      icon: HugeIcons.strokeRoundedLocation01,
      color: Colors.blue.shade50,
      children: [
        _buildInfoRow(context, 'Clinic Name', currentPet.nearestVetName, HugeIcons.strokeRoundedHospital01),
        _buildInfoRow(context, 'Address', currentPet.vetAddress, HugeIcons.strokeRoundedLocation01),
        _buildInfoRow(context, 'Distance', '${currentPet.distanceToVet} km away', HugeIcons.strokeRoundedRoute01),
      ],
    );
  }

  Widget _buildSectionCard(BuildContext context, {
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
            color: Colors.black.withOpacity(0.05),
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
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, IconData icon) {
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
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
