import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          showSearch(context: context, delegate: CustomSearchDelagate()),
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      HugeIcons.strokeRoundedSearch01,
                      color: Colors.grey[700],
                    ),
                    onPressed: () {},
                  ),
                  Text(
                    "Search",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
              // CircleAvatar(
              //   backgroundColor: Colors.grey[200],
              //   child: Icon(
              //     HugeIcons.strokeRoundedFilterHorizontal,
              //     color: Colors.grey[700],
              //     size: 30,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomSearchDelagate extends SearchDelegate<String> {
  List<String> searchTerms = [
    'Flutter',
    'Dart',
    'Android',
    'iOS',
    'Web',
    'UI/UX',
    'Animation',
  ];
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var pet in searchTerms) {
      if (pet.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(pet);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(title: Text(result));
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var pet in searchTerms) {
      if (pet.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(pet);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(title: Text(result));
      },
    );
  }
}
