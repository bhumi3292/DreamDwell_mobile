import 'package:flutter/material.dart';
import './property_detail_page.dart';
import 'package:dream_dwell/features/add_property/domain/entity/property/property_entity.dart';
import 'package:get_it/get_it.dart';
import 'package:dream_dwell/features/add_property/domain/use_case/property/get_all_properties_usecase.dart';

class PropertyListPage extends StatefulWidget {
  const PropertyListPage({Key? key}) : super(key: key);

  @override
  State<PropertyListPage> createState() => _PropertyListPageState();
}

class _PropertyListPageState extends State<PropertyListPage> {
  late Future<List<PropertyEntity>> _futureProperties;

  @override
  void initState() {
    super.initState();
    _futureProperties = _fetchProperties();
  }

  Future<List<PropertyEntity>> _fetchProperties() async {
    final usecase = GetIt.instance<GetAllPropertiesUsecase>();
    final result = await usecase();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (properties) => properties,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Properties')),
      body: FutureBuilder<List<PropertyEntity>>(
        future: _futureProperties,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No properties found.'));
          }
          final properties = snapshot.data!;
          return ListView.builder(
            itemCount: properties.length,
            itemBuilder: (context, index) {
              final property = properties[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  leading: property.images != null && property.images!.isNotEmpty
                      ? Image.network('http://10.0.2.2:3001/' + property.images!.first, width: 60, fit: BoxFit.cover)
                      : const Icon(Icons.home),
                  title: Text(property.title ?? ''),
                  subtitle: Text('Rs. ${property.price ?? ''}'),
                  onTap: () {
                    if (property.id != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PropertyDetailPage(
                            propertyId: property.id!,
                            baseUrl: 'http://10.0.2.2:3001/',
                          ),
                        ),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
} 