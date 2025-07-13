import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:get/get.dart';
import 'package:dream_dwell/features/add_property/presentation/property/view_model/add_property_view_model.dart';
import 'package:dream_dwell/features/add_property/presentation/property/view_model/add_property_event.dart';
import 'package:dream_dwell/features/add_property/presentation/property/view_model/add_property_state.dart';
import 'package:dream_dwell/features/add_property/domain/entity/category/category_entity.dart';
import 'package:dream_dwell/features/add_property/domain/use_case/category/add_category_usecase.dart';

class AddPropertyPresentation extends StatefulWidget {
  const AddPropertyPresentation({super.key});

  @override
  State<AddPropertyPresentation> createState() => _AddPropertyPresentationState();
}

class _AddPropertyPresentationState extends State<AddPropertyPresentation> {
  final _formKey = GlobalKey<FormState>();
  late final AddPropertyBloc _bloc;
  final ImagePicker _picker = ImagePicker();
  final AddCategoryUsecase _addCategoryUsecase = GetIt.instance<AddCategoryUsecase>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _bedroomsController = TextEditingController();
  final TextEditingController _bathroomsController = TextEditingController();
  final TextEditingController _newCategoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = GetIt.instance<AddPropertyBloc>();
    _bloc.add(const InitializeAddPropertyForm());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _bedroomsController.dispose();
    _bathroomsController.dispose();
    _newCategoryController.dispose();
    _bloc.close();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage(imageQuality: 70);
    if (pickedFiles.isNotEmpty) {
      for (var file in pickedFiles) {
        _bloc.add(AddImageEvent(image: file));
      }
    }
  }

  Future<void> _pickVideos() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      _bloc.add(AddVideoEvent(video: pickedFile));
    }
  }

  Future<void> _showAddCategoryDialog() async {
    _newCategoryController.clear();
    
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _newCategoryController,
                decoration: const InputDecoration(
                  labelText: 'Category Name',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF003366), width: 2),
                  ),
                ),
                autofocus: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_newCategoryController.text.trim().isNotEmpty) {
                  await _addNewCategory(_newCategoryController.text.trim());
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003366),
                foregroundColor: Colors.white,
              ),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addNewCategory(String categoryName) async {
    try {
      final newCategory = CategoryEntity(categoryName: categoryName);
      final result = await _addCategoryUsecase(newCategory);
      
      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to add category: ${failure.message}'),
              backgroundColor: Colors.red,
            ),
          );
        },
        (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Category added successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          // Refresh categories in the form
          _bloc.add(const InitializeAddPropertyForm());
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding category: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Property'),
        backgroundColor: const Color(0xFF003366),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: BlocProvider.value(
        value: _bloc,
        child: BlocConsumer<AddPropertyBloc, AddPropertyState>(
          listener: (context, state) {
            if (state.successMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.successMessage!), backgroundColor: Colors.green),
              );
              _formKey.currentState?.reset();
              _titleController.clear();
              _locationController.clear();
              _priceController.clear();
              _descriptionController.clear();
              _bedroomsController.clear();
              _bathroomsController.clear();
              _bloc.add(const ClearAddPropertyMessageEvent());
              
              // Navigate back after successful submission
              Future.delayed(const Duration(seconds: 2), () {
                Get.back();
              });
            } else if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!), backgroundColor: Colors.red),
              );
              _bloc.add(const ClearAddPropertyMessageEvent());
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextField(_titleController, 'Title'),
                    const SizedBox(height: 16),
                    _buildTextField(_locationController, 'Location'),
                    const SizedBox(height: 16),
                    _buildTextField(_priceController, 'Price', keyboardType: TextInputType.number),
                    const SizedBox(height: 16),
                    _buildTextField(_bedroomsController, 'Bedrooms', keyboardType: TextInputType.number),
                    const SizedBox(height: 16),
                    _buildTextField(_bathroomsController, 'Bathrooms', keyboardType: TextInputType.number),
                    const SizedBox(height: 16),
                    _buildTextField(_descriptionController, 'Description', maxLines: 3),
                    const SizedBox(height: 16),
                    _buildCategoryDropdown(state.categories, state.selectedCategoryId),
                    const SizedBox(height: 16),
                    _buildMediaSection('Images', state.selectedImages, _pickImages, (i) => _bloc.add(RemoveImageEvent(index: i))),
                    const SizedBox(height: 16),
                    _buildMediaSection('Videos', state.selectedVideos, _pickVideos, (i) => _bloc.add(RemoveVideoEvent(index: i))),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: state.isSubmitting
                          ? null
                          : () {
                              if (_formKey.currentState?.validate() ?? false) {
                                _bloc.add(
                                  SubmitPropertyEvent(
                                    title: _titleController.text,
                                    location: _locationController.text,
                                    price: _priceController.text,
                                    description: _descriptionController.text,
                                    bedrooms: _bedroomsController.text,
                                    bathrooms: _bathroomsController.text,
                                    categoryId: state.selectedCategoryId,
                                    context: context,
                                  ),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003366),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: state.isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Add Property', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF003366), width: 2),
        ),
      ),
      validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
    );
  }

  Widget _buildCategoryDropdown(List<CategoryEntity> categories, String? selectedCategoryId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Category',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            IconButton(
              onPressed: _showAddCategoryDialog,
              icon: const Icon(Icons.add_circle, color: Color(0xFF003366)),
              tooltip: 'Add New Category',
            ),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedCategoryId,
          decoration: const InputDecoration(
            labelText: 'Select Category',
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF003366), width: 2),
            ),
          ),
          items: [
            const DropdownMenuItem(value: null, child: Text('Select Category')),
            ...categories.map((cat) => DropdownMenuItem(
              value: cat.id, 
              child: Text(cat.categoryName),
            )),
          ],
          onChanged: (val) => _bloc.add(SelectCategoryEvent(categoryId: val)),
          validator: (val) => val == null ? 'Category required' : null,
        ),
      ],
    );
  }

  Widget _buildMediaSection(String label, List<XFile> files, VoidCallback onAdd, Function(int) onRemove) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            IconButton(
              onPressed: onAdd, 
              icon: const Icon(Icons.add_a_photo),
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFF003366),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        if (files.isNotEmpty)
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: files.length,
              itemBuilder: (context, i) => Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(files[i].path),
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => onRemove(i),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
} 