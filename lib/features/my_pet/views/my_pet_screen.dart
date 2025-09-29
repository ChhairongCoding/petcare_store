import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../widgets/pet_details_view.dart';

class MyPet extends StatelessWidget {
  const MyPet({super.key});

  // Mock pet data - in a real app this would come from a controller/database
  static final List<Map<String, dynamic>> petsList = [
    {
      'id': 1,
      'name': 'Buddy',
      'breed': 'Golden Retriever',
      'age': '2 years',
      'weight': '25 kg',
      'gender': 'Male',
      'image': 'https://t4.ftcdn.net/jpg/02/66/72/41/360_F_266724172_Iy8gdKgMa7XmrhYYxLCxyhx6J7070Pr8.jpg',
      'color': Colors.amber.shade100,
    },
    {
      'id': 2,
      'name': 'Luna',
      'breed': 'Persian Cat',
      'age': '1.5 years',
      'weight': '4 kg',
      'gender': 'Female',
      'image': 'https://cdn.pixabay.com/photo/2017/02/20/18/03/cat-2083492_960_720.jpg',
      'color': Colors.pink.shade100,
    },
    {
      'id': 3,
      'name': 'Max',
      'breed': 'German Shepherd',
      'age': '3 years',
      'weight': '30 kg',
      'gender': 'Male',
      'image': 'https://cdn.pixabay.com/photo/2016/12/13/05/15/puppy-1903313_960_720.jpg',
      'color': Colors.blue.shade100,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'My Pets',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
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
          child: petsList.isEmpty
              ? _buildEmptyState(context)
              : _buildPetsList(context),
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
        borderRadius: BorderRadius.circular(20),
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
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${petsList.length}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
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

  Widget _buildPetsList(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: petsList.length,
      itemBuilder: (context, index) {
        final pet = petsList[index];
        return _buildPetCard(context, pet, index);
      },
    );
  }

  Widget _buildPetCard(BuildContext context, Map<String, dynamic> pet, int index) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to pet details
          _navigateToPetDetails(context, pet);
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  // Pet Image
                  Hero(
                    tag: 'pet_image_${pet['id']}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl: pet['image'],
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.pets,
                            color: Colors.grey[400],
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.pets,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
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
                                pet['name'],
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: pet['color'],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                pet['gender'],
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          pet['breed'],
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                              pet['age'],
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(width: 16),
                            Icon(
                              HugeIcons.strokeRoundedWeightScale,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            SizedBox(width: 4),
                            Text(
                              pet['weight'],
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
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
                        onPressed: () {
                          _editPet(context, pet);
                        },
                        icon: Icon(
                          HugeIcons.strokeRoundedEdit01,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _showPetOptions(context, pet);
                        },
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
              child: Icon(
                Icons.pets,
                size: 80,
                color: Colors.grey[400],
              ),
            ),
            SizedBox(height: 24),
            Text(
              'No Pets Yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Add your first furry friend to get started!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                _addNewPet(context);
              },
              icon: Icon(HugeIcons.strokeRoundedAdd01),
              label: Text('Add Pet'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
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
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // Helper methods for navigation and actions
  void _navigateToPetDetails(BuildContext context, Map<String, dynamic> pet) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PetDetailsView(), // You already have this widget
      ),
    );
  }

  void _addNewPet(BuildContext context) {
    // Show bottom sheet or navigate to add pet screen
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAddPetBottomSheet(context),
    );
  }

  void _editPet(BuildContext context, Map<String, dynamic> pet) {
    // Show edit pet dialog or navigate to edit screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${pet['name']}'),
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

  void _showPetOptions(BuildContext context, Map<String, dynamic> pet) {
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

  void _deletePet(BuildContext context, Map<String, dynamic> pet) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${pet['name']}?'),
        content: Text('Are you sure you want to delete this pet? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Remove pet from list (in real app, remove from database)
              petsList.removeWhere((p) => p['id'] == pet['id']);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildAddPetBottomSheet(BuildContext context) {
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
            Text(
              'Add New Pet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Pet photo upload section
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey[300]!, width: 2),
                      ),
                      child: Column(
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
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    // Form fields would go here
                    Text(
                      'Pet registration form will be implemented here with fields for:',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 10),
                    Text(
                      '• Pet Name\n• Breed\n• Age\n• Weight\n• Gender\n• Medical History\n• Emergency Contact',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Implement save pet logic
                    },
                    child: Text('Save Pet'),
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
