import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:petcare_store/features/my_pet/controller/my_pet_controller.dart';
// import 'package:petcare_store/features/my_pet/models/my_pet_entity.dart';
import 'package:petcare_store/features/my_pet/views/widgets/pet_form_page.dart';
import '../models/pet_model.dart';
import 'widgets/pet_details_view.dart';

class MyPet extends StatefulWidget {
  const MyPet({super.key});

  @override
  State<MyPet> createState() => _MyPetState();
}

class _MyPetState extends State<MyPet> {
  final MyPetController _controller = Get.find<MyPetController>();

  final List<Color> _colorPalette = [
    Colors.amber.shade100,
    Colors.pink.shade100,
    Colors.blue.shade100,
    Colors.green.shade100,
    Colors.purple.shade100,
  ];

  @override
  void initState() {
    super.initState();
    _controller.fetchPets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'My Pets',
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      actions: [
        IconButton(
          onPressed: () {
            // Navigate to search pets
          },
          icon: Icon(
            HugeIcons.strokeRoundedSearch01,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        IconButton(
          onPressed: () {
            // Show filter options
          },
          icon: Icon(
            HugeIcons.strokeRoundedFilterHorizontal,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: Obx(() {
            final isBusy =
                _controller.isLoading.value && _controller.pets.isEmpty;

            if (isBusy) {
              return Center(child: CircularProgressIndicator());
            }

            return RefreshIndicator(
              onRefresh: _controller.fetchPets,
              child: _controller.pets.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: 120),
                        _buildEmptyState(context),
                      ],
                    )
                  : _buildPetsList(context, _controller.pets),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Pets',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
                SizedBox(height: 4),
                Obx(
                  () => Text(
                    '${_controller.pets.length}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              HugeIcons.strokeRoundedFavourite,
              size: 32,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetsList(BuildContext context, List<PetModel> pets) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: pets.length,
      itemBuilder: (context, index) {
        return _buildPetCard(context, pets[index], index);
      },
    );
  }

  Widget _buildPetCard(BuildContext context, PetModel pet, int index) {
    final accentColor = _colorPalette[index % _colorPalette.length];
    final subtitleParts = <String>[];
    if ((pet.type ?? '').isNotEmpty) subtitleParts.add(pet.type!);
    if ((pet.breed ?? '').isNotEmpty) subtitleParts.add(pet.breed!);
    final subtitle = subtitleParts.isEmpty
        ? 'Details coming soon'
        : subtitleParts.join(' • ');
    final ageText = pet.age != null ? '${pet.age} yrs' : 'Age N/A';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: () {
          // Navigate to pet details
          _navigateToPetDetails(context, pet);
        },
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  // Pet Image
                  Hero(
                    tag: 'pet_image_${pet.id}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: _buildPetImage(pet.avatar),
                    ),
                  ),
                  SizedBox(width: 16),
                  // Pet Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                pet.name,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: accentColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                pet.gender?.isNotEmpty == true
                                    ? pet.gender!
                                    : 'Unknown',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              HugeIcons.strokeRoundedCalendar03,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            SizedBox(width: 4),
                            Text(
                              ageText,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                            SizedBox(width: 16),
                            Icon(
                              HugeIcons.strokeRoundedLocation01,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            SizedBox(width: 4),
                            Text(
                              _formatLocation(pet),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Action Buttons
                  Column(
                    children: [
                      IconButton(
                        onPressed: () => _editPet(context, pet),
                        icon: Icon(
                          HugeIcons.strokeRoundedEdit01,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      IconButton(
                        onPressed: () => showPetOptions(context, pet),
                        icon: Icon(
                          HugeIcons.strokeRoundedMoreVertical,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPetImage(String? imageUrl, {double size = 80}) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return _buildImagePlaceholder(size);
    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: size,
      width: size,
      fit: BoxFit.cover,
      placeholder: (context, url) => _buildImagePlaceholder(size),
      errorWidget: (context, url, error) => _buildImagePlaceholder(size),
    );
  }

  Widget _buildImagePlaceholder(double size) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(Icons.pets, color: Colors.grey[400]),
    );
  }

  String _formatLocation(PetModel pet) {
    if (pet.lat == null || pet.long == null) {
      return 'Location N/A';
    }
    return '${pet.lat}, ${pet.long}';
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.pets, size: 80, color: Colors.grey[400]),
            ),
            SizedBox(height: 24),
            Text(
              'No Pets Yet',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.grey[700]),
            ),
            SizedBox(height: 8),
            Text(
              'Add your first furry friend to get started!',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 90),
      child: FloatingActionButton.extended(
        onPressed: () {
          _addNewPet(context);
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        icon: Icon(HugeIcons.strokeRoundedAdd01),
        label: Text(
          'Add Pet',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // Helper methods for navigation and actions
  void _navigateToPetDetails(BuildContext context, PetModel pet) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PetDetailsView(pet: pet)),
    );
  }

  void _addNewPet(BuildContext context) {
    // Show bottom sheet or navigate to add pet screen
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddPetBottomSheet(),
    );
  }

  void _editPet(BuildContext context, PetModel pet) {
    // Show edit pet dialog or navigate to edit screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${pet.name}'),
        content: Text('Edit pet functionality will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement edit logic
            },
            child: Text('Edit'),
          ),
        ],
      ),
    );
  }

  void showPetOptions(BuildContext context, PetModel pet) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(HugeIcons.strokeRoundedShare08),
              title: Text('Share Pet'),
              onTap: () {
                Navigator.pop(context);
                // Implement share functionality
              },
            ),
            ListTile(
              leading: Icon(HugeIcons.strokeRoundedFavourite),
              title: Text('Mark as Favorite'),
              onTap: () {
                Navigator.pop(context);
                // Implement favorite functionality
              },
            ),
            ListTile(
              leading: Icon(HugeIcons.strokeRoundedDelete02, color: Colors.red),
              title: Text('Delete Pet', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _deletePet(context, pet);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _deletePet(BuildContext context, PetModel pet) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${pet.name}?'),
        content: Text(
          'Are you sure you want to delete this pet? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              String id = pet.id;
              Navigator.pop(context);
              _controller.deletePet(id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
