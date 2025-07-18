import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dream_dwell/features/add_property/domain/entity/property/property_entity.dart';
import 'package:dream_dwell/features/add_property/domain/use_case/property/update_property_usecase.dart';
import 'package:dream_dwell/app/service_locator/service_locator.dart';

class UpdatePropertyPage extends StatefulWidget {
  final String propertyId;
  final String initialTitle;
  final String initialLocation;
  final double initialPrice;
  final String initialDescription;
  final int initialBedrooms;
  final int initialBathrooms;
  // Add more fields as needed

  const UpdatePropertyPage({
    Key? key,
    required this.propertyId,
    required this.initialTitle,
    required this.initialLocation,
    required this.initialPrice,
    required this.initialDescription,
    required this.initialBedrooms,
    required this.initialBathrooms,
  }) : super(key: key);

  @override
  State<UpdatePropertyPage> createState() => _UpdatePropertyPageState();
}

class _UpdatePropertyPageState extends State<UpdatePropertyPage> {
  late TextEditingController _titleController;
  late TextEditingController _locationController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _bedroomsController;
  late TextEditingController _bathroomsController;

  final List<File> _selectedImages = [];
  final List<File> _selectedVideos = [];
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _locationController = TextEditingController(text: widget.initialLocation);
    _priceController = TextEditingController(text: widget.initialPrice.toString());
    _descriptionController = TextEditingController(text: widget.initialDescription);
    _bedroomsController = TextEditingController(text: widget.initialBedrooms.toString());
    _bathroomsController = TextEditingController(text: widget.initialBathrooms.toString());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _bedroomsController.dispose();
    _bathroomsController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _selectedImages.clear();
        _selectedImages.addAll(pickedFiles.map((x) => File(x.path)));
      });
    }
  }

  Future<void> _pickVideos() async {
    final XFile? pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedVideos.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _submitUpdate() async {
    setState(() { _isSubmitting = true; });
    final updateUsecase = serviceLocator<UpdatePropertyUsecase>();
    final property = PropertyEntity(
      id: widget.propertyId,
      title: _titleController.text.trim(),
      location: _locationController.text.trim(),
      price: double.tryParse(_priceController.text) ?? 0.0,
      description: _descriptionController.text.trim(),
      bedrooms: int.tryParse(_bedroomsController.text) ?? 0,
      bathrooms: int.tryParse(_bathroomsController.text) ?? 0,
      // Add categoryId, landlordId, etc. if needed
    );
    final imagePaths = _selectedImages.map((f) => f.path).toList();
    final videoPaths = _selectedVideos.map((f) => f.path).toList();
    final result = await updateUsecase(
      widget.propertyId,
      property,
      imagePaths,
      videoPaths,
    );
    setState(() { _isSubmitting = false; });
    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update property: ${failure.toString()}'), backgroundColor: Colors.red),
        );
      },
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Property updated successfully!'), backgroundColor: Colors.green),
        );
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Property'),
        backgroundColor: const Color(0xFF003366),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bedroomsController,
              decoration: const InputDecoration(labelText: 'Bedrooms'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bathroomsController,
              decoration: const InputDecoration(labelText: 'Bathrooms'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            Text('Images', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImages,
                  icon: Icon(Icons.image),
                  label: Text('Pick Images'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                ),
                const SizedBox(width: 12),
                if (_selectedImages.isNotEmpty)
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: _selectedImages.map((img) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Image.file(img, width: 60, height: 60, fit: BoxFit.cover),
                        )).toList(),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Videos', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickVideos,
                  icon: Icon(Icons.videocam),
                  label: Text('Pick Video'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                ),
                const SizedBox(width: 12),
                if (_selectedVideos.isNotEmpty)
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: _selectedVideos.map((vid) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(Icons.videocam, size: 48, color: Colors.deepPurple),
                        )).toList(),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitUpdate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003366),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Update Property', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 