import 'package:foodpanda_user/models/category.dart';
import 'package:foodpanda_user/models/food.dart';

class Menu {
  final Category category;
  final List<Food> foods;
  Menu({
    required this.category,
    required this.foods,
  });
}
