import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../characters/data/models/character.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../characters/presentation/providers/edit_provider.dart';
import '../../../characters/presentation/providers/merged_character_provider.dart';

class CharacterEditScreen extends ConsumerStatefulWidget {
  final Character character;

  const CharacterEditScreen({
    super.key,
    required this.character,
  });

  @override
  ConsumerState<CharacterEditScreen> createState() => _CharacterEditScreenState();
}

class _CharacterEditScreenState extends ConsumerState<CharacterEditScreen> {
  late TextEditingController _nameController;
  late TextEditingController _statusController;
  late TextEditingController _speciesController;
  late TextEditingController _typeController;
  late TextEditingController _genderController;
  late TextEditingController _originController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.character.name);
    _statusController = TextEditingController(text: widget.character.status);
    _speciesController = TextEditingController(text: widget.character.species);
    _typeController = TextEditingController(text: widget.character.type ?? '');
    _genderController = TextEditingController(text: widget.character.gender ?? '');
    _originController = TextEditingController(text: widget.character.origin ?? '');
    _locationController = TextEditingController(text: widget.character.location ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _statusController.dispose();
    _speciesController.dispose();
    _typeController.dispose();
    _genderController.dispose();
    _originController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    ref.read(editProviderFamily(widget.character.id).notifier).updateEdit(
          name: _nameController.text,
          status: _statusController.text,
          species: _speciesController.text,
          type: _typeController.text.isEmpty ? null : _typeController.text,
          gender: _genderController.text.isEmpty ? null : _genderController.text,
          origin: _originController.text.isEmpty ? null : _originController.text,
          location: _locationController.text.isEmpty ? null : _locationController.text,
        );

    // Invalidate merged character provider to refresh display
    ref.invalidate(mergedCharacterProvider);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit ${widget.character.name}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEditField('Name', _nameController),
            SizedBox(height: 16.h),
            _buildEditField('Status', _statusController),
            SizedBox(height: 16.h),
            _buildEditField('Species', _speciesController),
            SizedBox(height: 16.h),
            _buildEditField('Type', _typeController),
            SizedBox(height: 16.h),
            _buildEditField('Gender', _genderController),
            SizedBox(height: 16.h),
            _buildEditField('Origin', _originController),
            SizedBox(height: 16.h),
            _buildEditField('Location', _locationController),
            SizedBox(height: 32.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                onPressed: _saveChanges,
                child: Text(
                  'Save Changes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey[800]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey[800]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          ),
        ),
      ],
    );
  }
}
