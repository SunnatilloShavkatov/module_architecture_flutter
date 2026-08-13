import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:material_ui/material_ui.dart';
import 'package:navigation/navigation.dart';
import 'package:profile/src/presentation/edit_profile/args/edit_profile_args.dart';
import 'package:profile/src/presentation/profile/bloc/profile_bloc.dart';

part 'mixin/edit_profile_mixin.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.args});

  final EditProfileArgs args;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> with EditProfileMixin {
  @override
  Widget build(BuildContext context) => BlocConsumer<ProfileBloc, ProfileState>(
    listenWhen: (prev, curr) => curr is ProfileUpdatedState || curr is ProfileFailureState,
    listener: _handleStates,
    builder: (context, state) => Scaffold(
      appBar: AppBar(title: Text(context.l10n.editProfile)),
      body: SafeAreaWithMinimum(
        minimum: Dimensions.kPaddingAll16,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ProfileTextField(label: context.l10n.usernameLabel, controller: _usernameController),
                Dimensions.kGap12,
                _ProfileTextField(
                  label: context.l10n.mobileNumber,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                ),
                Dimensions.kGap12,
                _ProfileTextField(label: context.l10n.firstNameLabel, controller: _firstNameController),
                Dimensions.kGap12,
                _ProfileTextField(label: context.l10n.lastNameLabel, controller: _lastNameController),
                Dimensions.kGap12,
                _ProfileTextField(label: context.l10n.occupationLabel, controller: _specializationController),
                Dimensions.kGap24,
                CustomLoadingButton(
                  isLoading: state is ProfileUpdatingState,
                  onPressed: _saveProfile,
                  child: Text(context.l10n.saveButton),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

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
    validator: (value) => (value ?? '').trim().isEmpty ? context.l10n.fieldRequired : null,
    decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
  );
}
