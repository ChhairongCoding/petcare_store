import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class PetDetailsView extends StatelessWidget {
  PetDetailsView({super.key});

  final List<Map<String, dynamic>> list = [
    {"Color": Colors.amber.shade100, "title": "Gender", "value": "Male"},
    {"Color": Colors.blue.shade100, "title": "Age", "value": "2 years"},
    {
      "Color": Colors.pinkAccent.shade100,
      "title": "Weight",
      "value": "10 kg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody(context));
  }

  _buildAppBar() => AppBar(title: Text('Details Pet'));

  _buildBody(BuildContext context) => SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 12,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl:
                          "https://t4.ftcdn.net/jpg/02/66/72/41/360_F_266724172_Iy8gdKgMa7XmrhYYxLCxyhx6J7070Pr8.jpg",
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Column(
                    spacing: 12,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pet Name',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        'Pet Breed',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              Row(
                children: [
                  CircleAvatar(
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(HugeIcons.strokeRoundedEdit01),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: list
                .map(
                  (item) => PersonalDetailsCat(
                    color: item["Color"],
                    title: item["title"],
                    value: item["value"],
                  ),
                )
                .toList(),
          ),
        ],
      ),
    ),
  );
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
