import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';
import 'package:profile/src/domain/entities/profile_user_entity.dart';
import 'package:profile/src/presentation/profile/bloc/profile_bloc.dart';

part 'mixin/edit_profile_mixin.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.user});

  final ProfileUserEntity user;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> with EditProfileMixin {
  @override
  Widget build(BuildContext context) => BlocConsumer<ProfileBloc, ProfileState>(
    listenWhen: (prev, curr) => curr is ProfileUpdatedState || curr is ProfileFailureState,
    listener: _handleStates,
    builder: (context, state) => Scaffold(
      appBar: AppBar(title: Text(context.localizations.editProfile)),
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
                _ProfileTextField(
                  label: 'Mobile Number',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                ),
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
    validator: (value) => (value ?? '').trim().isEmpty ? context.localizations.fieldRequired : null,
    decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
  );
}
