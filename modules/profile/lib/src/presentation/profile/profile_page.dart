import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';
import 'package:profile/src/domain/entities/profile_user_entity.dart';
import 'package:profile/src/presentation/profile/bloc/profile_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.localizations.profile)),
    body: SafeAreaWithMinimum(
      minimum: Dimensions.kPaddingAll16,
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) => switch (state) {
          ProfileInitialState() || ProfileLoadingState() => const Center(child: CircularProgressIndicator.adaptive()),
          ProfileFailureState() => _ProfileFailureView(
            message: state.message,
            onReload: () => context.read<ProfileBloc>().add(const ProfileInitialEvent()),
          ),
          ProfileSuccessState() => _ProfileContentView(user: state.user),
        },
      ),
    ),
    bottomNavigationBar: SafeAreaWithMinimum(
      minimum: Dimensions.kPaddingAll16,
      child: BlocBuilder<ProfileBloc, ProfileState>(
        buildWhen: (prev, curr) => curr is ProfileSuccessState,
        builder: (_, state) {
          if (state is! ProfileSuccessState) {
            return const SizedBox.shrink();
          }
          return Text('${state.version.version} (${state.version.buildNumber})', textAlign: TextAlign.center);
        },
      ),
    ),
  );
}

final class _ProfileFailureView extends StatelessWidget {
  const _ProfileFailureView({required this.message, required this.onReload});

  final String message;
  final VoidCallback onReload;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          message,
          textAlign: TextAlign.center,
          style: context.textTheme.bodyLarge?.copyWith(color: context.colorScheme.error),
        ),
        Dimensions.kGap16,
        CustomLoadingButton(onPressed: onReload, child: const Text("Qayta urinib ko'rish")),
      ],
    ),
  );
}

final class _ProfileContentView extends StatelessWidget {
  const _ProfileContentView({required this.user});

  final ProfileUserEntity user;

  String get displayName {
    final name = user.firstName.trim();
    return name.isEmpty ? 'User' : name;
  }

  String get initials {
    final parts = displayName.split(' ');
    final value = parts.take(2).where((part) => part.isNotEmpty).map((part) => part[0]).join();
    return value.isEmpty ? 'U' : value.toUpperCase();
  }

  String get phone {
    final value = user.phone.trim();
    return value.isEmpty ? '+998 90 123 45 67' : phoneFormat(value);
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.localizations.profile,
          style: context.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: context.color.textPrimary,
          ),
        ),
        Dimensions.kGap24,
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: context.color.background,
                child: Text(
                  initials,
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.color.textSecondary,
                  ),
                ),
              ),
              Dimensions.kGap16,
              Text(
                displayName,
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.color.textPrimary,
                ),
              ),
              Dimensions.kGap4,
              Text(phone, style: context.textTheme.bodyMedium?.copyWith(color: context.color.textSecondary)),
              Dimensions.kGap16,
              ElevatedButton(
                onPressed: () async {
                  await context.pushNamed(Routes.settings);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.color.primary.withValues(alpha: 0.1),
                  foregroundColor: context.color.primary,
                  elevation: 0,
                  shape: const RoundedRectangleBorder(borderRadius: Dimensions.kBorderRadius24),
                  padding: Dimensions.kPaddingHor16Ver12,
                ),
                child: const Text('Edit Profile'),
              ),
            ],
          ),
        ),
        Dimensions.kGap32,
        const _ProfileSectionTitle(title: 'ACCOUNT'),
        _ProfileMenuItem(
          icon: Icons.settings_outlined,
          title: 'Settings',
          onTap: () async {
            await context.pushNamed(Routes.settings);
          },
        ),
        const _ProfileMenuItem(icon: Icons.notifications_outlined, title: 'Notifications'),
        const _ProfileMenuItem(icon: Icons.payment_outlined, title: 'Payment Methods'),
        const _ProfileMenuItem(icon: Icons.location_on_outlined, title: 'Addresses'),
        Dimensions.kGap24,
        const _ProfileSectionTitle(title: 'SUPPORT'),
        const _ProfileMenuItem(icon: Icons.help_outline, title: 'Help Center'),
      ],
    ),
  );
}

final class _ProfileSectionTitle extends StatelessWidget {
  const _ProfileSectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8, left: 4),
    child: Text(
      title,
      style: context.textTheme.labelMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: context.color.textSecondary,
        letterSpacing: 1,
      ),
    ),
  );
}

final class _ProfileMenuItem extends StatelessWidget {
  const _ProfileMenuItem({required this.icon, required this.title, this.onTap});

  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    onTap: onTap,
    contentPadding: EdgeInsets.zero,
    leading: Icon(icon, color: context.color.textPrimary),
    title: Text(
      title,
      style: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500, color: context.color.textPrimary),
    ),
    trailing: Icon(Icons.chevron_right, color: context.color.textSecondary),
  );
}
