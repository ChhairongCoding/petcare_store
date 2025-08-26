import 'package:get/get.dart';
import 'package:petcare_store/views/category_views/model/category_model.dart';

class CategoryController extends GetxController {
  final List<CategoryModel> cateLists = [
    CategoryModel(
      image: 'https://www.dewsolutions.in/wp-content/uploads/2021/09/Petcare.png',
      name: 'Veterinary',
    ),
    CategoryModel(
      image: 'https://vetic-img.s3.ap-south-1.amazonaws.com/website/Website-Astro/grooming_page/Hero+image+mobile.webp',
      name: 'Grooming',
    ),
    CategoryModel(
      image: 'https://www.pawsitivelynatural.ca/wp-content/uploads/2020/04/Dog-Shopping-cart.jpg',
      name: 'Pet Store',
    ),
    CategoryModel(
      image: 'https://www.carrymypet.com/images/cece0168-69fd-446c-a193-371df819b328.jpg',
      name: 'Training',
    ),
  ];
} 