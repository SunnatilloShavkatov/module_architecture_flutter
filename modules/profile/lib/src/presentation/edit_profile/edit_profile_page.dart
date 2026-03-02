import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';
import 'package:profile/src/domain/entities/profile_user_entity.dart';
import 'package:profile/src/presentation/profile/bloc/profile_bloc.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.user});

  final ProfileUserEntity user;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController = TextEditingController(text: widget.user.username ?? '');
  late final TextEditingController _phoneController = TextEditingController(text: widget.user.phone ?? '');
  late final TextEditingController _firstNameController = TextEditingController(text: widget.user.firstName);
  late final TextEditingController _lastNameController = TextEditingController(text: widget.user.lastName);
  late final TextEditingController _specializationController = TextEditingController(
    text: widget.user.specialization ?? '',
  );

  @override
  Widget build(BuildContext context) => BlocConsumer<ProfileBloc, ProfileState>(
    listenWhen: (prev, curr) => prev.runtimeType != curr.runtimeType,
    listener: (context, state) {
      if (state is ProfileUpdatedState) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Profile updated successfully')));
        context.pop(true);
      } else if (state is ProfileFailureState) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
      }
    },
    builder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SafeAreaWithMinimum(
        minimum: Dimensions.kPaddingAll16,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ProfileTextField(label: 'Username', controller: _usernameController),
                Dimensions.kGap12,
                _ProfileTextField(label: 'Mobile Number', controller: _phoneController, keyboardType: TextInputType.phone),
                Dimensions.kGap12,
                _ProfileTextField(label: 'First Name', controller: _firstNameController),
                Dimensions.kGap12,
                _ProfileTextField(label: 'Last Name', controller: _lastNameController),
                Dimensions.kGap12,
                _ProfileTextField(label: 'Occupation', controller: _specializationController),
                Dimensions.kGap24,
                CustomLoadingButton(
                  isLoading: state is ProfileUpdatingState,
                  onPressed: _saveProfile,
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  void _saveProfile() {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    context.read<ProfileBloc>().add(
      UpdateProfilePressedEvent(
        username: _usernameController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phone: _phoneController.text.trim(),
        specialization: _specializationController.text.trim(),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _specializationController.dispose();
    super.dispose();
  }
}

final class _ProfileTextField extends StatelessWidget {
  const _ProfileTextField({required this.label, required this.controller, this.keyboardType});

  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    validator: (value) => (value ?? '').trim().isEmpty ? 'Required' : null,
    decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
  );
}
