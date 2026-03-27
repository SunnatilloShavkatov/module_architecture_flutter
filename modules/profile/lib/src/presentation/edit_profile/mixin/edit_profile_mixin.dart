part of '../edit_profile_page.dart';

mixin EditProfileMixin on State<EditProfilePage> {
  late final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController = TextEditingController(text: widget.user.username ?? '');
  late final TextEditingController _phoneController = TextEditingController(text: widget.user.phone ?? '');
  late final TextEditingController _firstNameController = TextEditingController(text: widget.user.firstName);
  late final TextEditingController _lastNameController = TextEditingController(text: widget.user.lastName);
  late final TextEditingController _specializationController = TextEditingController(
    text: widget.user.specialization ?? '',
  );

  void _handleStates(BuildContext context, ProfileState state) {
    if (!context.mounted) {
      return;
    } else if (state is ProfileUpdatedState) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.localizations.profileUpdatedSuccess)));
      context.pop(true);
    } else if (state is ProfileFailureState) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
    }
  }

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
