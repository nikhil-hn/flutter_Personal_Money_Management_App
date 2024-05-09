import 'package:hive_flutter/hive_flutter.dart';
part 'category_model.g.dart';

@HiveType(typeId: 0)
enum CategoryType {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
}

@HiveType(typeId: 1)
class Categorymodel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final CategoryType type;
  @HiveField(3)
  final bool isDeleted;

  Categorymodel(
      {required this.id,
      required this.name,
      required this.type,
      this.isDeleted = false});
}
