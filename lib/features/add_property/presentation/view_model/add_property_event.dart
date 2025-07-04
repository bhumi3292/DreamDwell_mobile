import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'dart:io';

abstract class AddPropertyEvent extends Equatable {
  const AddPropertyEvent();

  @override
  List<Object?> get props => [];
}

class AddNewPropertyEvent extends AddPropertyEvent {
  final String title;
  final String location;
  final String price;
  final String description;
  final String bedrooms;
  final String bathrooms;
  final String categoryId;
  final List<File> images;
  final List<File> videos;
  final BuildContext? context;

  const AddNewPropertyEvent({
    required this.title,
    required this.location,
    required this.price,
    required this.description,
    required this.bedrooms,
    required this.bathrooms,
    required this.categoryId,
    required this.images,
    required this.videos,
    this.context,
  });

  @override
  List<Object?> get props => [
    title,
    location,
    price,
    description,
    bedrooms,
    bathrooms,
    categoryId,
    images,
    videos,
    context,
  ];
}

class ClearAddPropertyMessageEvent extends AddPropertyEvent {
  const ClearAddPropertyMessageEvent();

  @override
  List<Object?> get props => [];
}

class FetchCategoriesEvent extends AddPropertyEvent {
  const FetchCategoriesEvent();

  @override
  List<Object?> get props => [];
}

class AddCategoryEvent extends AddPropertyEvent {
  final String categoryName;
  final BuildContext context;

  const AddCategoryEvent({required this.categoryName, required this.context});

  @override
  List<Object?> get props => [categoryName, context];
}