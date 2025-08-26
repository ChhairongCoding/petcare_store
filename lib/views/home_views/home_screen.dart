import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:petcare_store/views/category_views/controller/category_controller.dart';
import 'package:petcare_store/views/home_views/controller/home_controller.dart';
import 'package:petcare_store/widgets/card_show_widget.dart';
import 'package:petcare_store/widgets/search_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final HomeController homeController = Get.put(HomeController());
  final CategoryController categoryController = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 171, 255, 227), Colors.white],
          begin: Alignment.topCenter,
          stops: [0.6, 0.9],
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: CustomScrollView(
            slivers: <Widget>[_buildAppBar(context), _buildBody(context)],
          ),
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(left: 12),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl:
                    "https://img.freepik.com/freie-psd/3d-darstellung-eines-menschlichen-avatars-oder-profils_23-2150671142.jpg",
                fit: BoxFit.cover,
                height: 50,
                width: 50,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Hello, Chhairong",
                    style: Theme.of(context).textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Good Morning!",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      actions: [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            icon: Icon(
              HugeIcons.strokeRoundedNotification02,
              size: 26,
              color: Colors.grey[700],
            ),
            onPressed: () {},
          ),
        ),
        SizedBox(width: 8),
        CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            icon: Icon(
              HugeIcons.strokeRoundedShoppingCart01,
              size: 26,
              color: Colors.grey[700],
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildBody(context) {
    return SliverToBoxAdapter(
      child: Column(
        spacing: 20,
        children: [
          SizedBox(height: 20),
          SearchWidget(),
          CartShowWidget(),

          Column(
            spacing: 20,
            children: [
              Row(
                children: [
                  Text(
                    "Categories",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Spacer(),
                  Text(
                    "See All",
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(color: Colors.grey[700]),
                  ),
                ],
              ),

              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryController.cateLists.length,
                  itemBuilder: (context, index) {
                    return Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: EdgeInsets.only(right: 12),
                        height: 70,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          color: Colors.white,
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.grey[300]!,
                          //     blurRadius: 5,
                          //     offset: Offset(0, 5),
                          //   ),
                          // ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.grey[300],
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        categoryController.cateLists[index].image,
                                    fit: BoxFit.cover,
                                    height: 40, // match 2 * radius
                                    width: 40,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                categoryController.cateLists[index].name,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              Column(
                spacing: 20,
                children: [
                  Row(
                    children: [
                      Text(
                        "Nearby Pets",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Spacer(),
                      Text(
                        "See All",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),

                  Wrap(
                    runSpacing: 12,
                    spacing: 12,
                    children: List.generate(
                      4,
                      (index) => Container(
                        width: MediaQuery.of( context).size.width / 2 -20,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.white,
                        ),
                        child: Column(
                          spacing: 8,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Stack(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl:
                                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT_JhDqBV_i6Z6JL3EHZ1sBJpE87ZJlR3FCew&s",
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        HugeIcons.strokeRoundedFavourite,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "Chcken& Green",
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(color: Colors.black),
                            ),
                            Row(
                              spacing: 8,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      HugeIcons.strokeRoundedStar,
                                      color: Colors.deepOrange,
                                    ),
                                    Text(
                                      "4.5",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            color: Colors.deepOrange,
                                          ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Text(
                                  "(1.5k)",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "\$28.99",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                Spacer(),
                                IconButton(
                                  style: IconButton.styleFrom(
                                    backgroundColor: Color(0xff378B6F),
                                  ),
                                  onPressed: () {},
                                  icon: Icon(
                                    HugeIcons.strokeRoundedAdd01,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
