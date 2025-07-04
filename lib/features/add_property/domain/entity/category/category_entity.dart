import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String categoryId;
  final String categoryName;

  const CategoryEntity({required this.categoryId,required this.categoryName});

  @override
  List<Object?> get props => [categoryId, categoryName];
}