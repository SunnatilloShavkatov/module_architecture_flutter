import 'package:components/components.dart';
import 'package:core/core.dart';
import 'package:home/src/domain/entities/home_appointment_entity.dart';
import 'package:home/src/domain/entities/home_business_entity.dart';
import 'package:home/src/domain/entities/home_category_entity.dart';
import 'package:home/src/presentation/main/bloc/home_bloc.dart';
import 'package:material_ui/material_ui.dart';

part 'mixin/home_mixin.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with HomeMixin {
  @override
  Widget build(BuildContext context) => BlocConsumer<HomeBloc, HomeState>(
    listener: _stateListener,
    builder: (context, state) => Scaffold(
      key: const Key('home'),
      appBar: AppBar(title: Text(context.l10n.appName)),
      body: SafeAreaWithMinimum(
        minimum: Dimensions.kPaddingAll16,
        child: switch (state) {
          HomeInitialState() || HomeLoadingState() => const Center(child: CircularProgressIndicator.adaptive()),
          HomeFailureState() => _HomeFailureView(message: state.message, onReload: _reloadHome),
          HomeSuccessState() => _HomeContentView(
            firstName: state.firstName,
            categories: state.categories,
            businesses: state.businesses,
            appointments: state.appointments,
            onReload: _reloadHome,
          ),
        },
      ),
    ),
  );
}

final class _HomeFailureView extends StatelessWidget {
  const _HomeFailureView({required this.message, required this.onReload});

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
        CustomLoadingButton(onPressed: onReload, child: Text(context.l10n.retryButton)),
      ],
    ),
  );
}

final class _HomeContentView extends StatelessWidget {
  const _HomeContentView({
    required this.firstName,
    required this.categories,
    required this.businesses,
    required this.appointments,
    required this.onReload,
  });

  final String firstName;
  final List<HomeCategoryEntity> categories;
  final List<HomeBusinessEntity> businesses;
  final List<HomeAppointmentEntity> appointments;
  final VoidCallback onReload;

  @override
  Widget build(BuildContext context) {
    final String displayName = firstName.trim().isEmpty ? 'User' : firstName.trim();
    final List<HomeCategoryEntity> visibleCategories = categories.take(8).toList();
    final List<HomeBusinessEntity> visibleBusinesses = businesses.take(5).toList();
    final List<HomeAppointmentEntity> visibleAppointments = appointments.take(3).toList();

    return RefreshIndicator(
      onRefresh: () async => onReload(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${context.l10n.welcomeGreeting}, $displayName',
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: context.color.textPrimary,
              ),
            ),
            Dimensions.kGap4,
            Text(
              context.l10n.haveGoodDay,
              style: context.textTheme.bodyMedium?.copyWith(color: context.color.textSecondary),
            ),
            Dimensions.kGap24,
            _HomeSectionTitle(title: context.l10n.categories),
            Dimensions.kGap12,
            if (visibleCategories.isEmpty)
              _HomeEmptySectionText(message: context.l10n.noCategoriesFound)
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: visibleCategories.map((category) => _CategoryBadge(category: category)).toList(),
              ),
            Dimensions.kGap24,
            _HomeSectionTitle(title: context.l10n.barbershops),
            Dimensions.kGap12,
            if (visibleBusinesses.isEmpty)
              _HomeEmptySectionText(message: context.l10n.noActiveBarbershops)
            else
              Column(
                children: [
                  for (var index = 0; index < visibleBusinesses.length; index++) ...[
                    _BusinessTile(business: visibleBusinesses[index]),
                    if (index != visibleBusinesses.length - 1) Dimensions.kGap8,
                  ],
                ],
              ),
            Dimensions.kGap24,
            _HomeSectionTitle(title: context.l10n.upcomingAppointmentsTitle),
            Dimensions.kGap12,
            if (visibleAppointments.isEmpty)
              _HomeEmptySectionText(message: context.l10n.noUpcomingAppointments)
            else
              Column(
                children: [
                  for (var index = 0; index < visibleAppointments.length; index++) ...[
                    _AppointmentTile(appointment: visibleAppointments[index]),
                    if (index != visibleAppointments.length - 1) Dimensions.kGap8,
                  ],
                ],
              ),
            Dimensions.kGap16,
          ],
        ),
      ),
    );
  }
}

final class _HomeSectionTitle extends StatelessWidget {
  const _HomeSectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Text(
    title,
    style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: context.color.textPrimary),
  );
}

final class _HomeEmptySectionText extends StatelessWidget {
  const _HomeEmptySectionText({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) =>
      Text(message, style: context.textTheme.bodyMedium?.copyWith(color: context.color.textSecondary));
}

final class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.category});

  final HomeCategoryEntity category;

  @override
  Widget build(BuildContext context) => Container(
    padding: Dimensions.kPaddingHor12Ver8,
    decoration: BoxDecoration(
      color: context.color.background,
      borderRadius: Dimensions.kBorderRadius12,
      border: Border.all(color: context.color.primary.withValues(alpha: 0.15)),
    ),
    child: Text(category.name, style: context.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
  );
}

final class _BusinessTile extends StatelessWidget {
  const _BusinessTile({required this.business});

  final HomeBusinessEntity business;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: Dimensions.kPaddingAll12,
    decoration: BoxDecoration(
      color: context.color.background,
      borderRadius: Dimensions.kBorderRadius12,
      border: Border.all(color: context.color.primary.withValues(alpha: 0.12)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          business.name,
          style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: context.color.textPrimary),
        ),
        Dimensions.kGap4,
        Text(business.address, style: context.textTheme.bodySmall?.copyWith(color: context.color.textSecondary)),
        Dimensions.kGap8,
        Row(
          children: [
            Icon(Icons.star_rounded, color: context.color.primary, size: 16),
            Dimensions.kGap4,
            Text(
              '${business.rating.toStringAsFixed(1)} (${business.reviewCount})',
              style: context.textTheme.bodySmall?.copyWith(color: context.color.textSecondary),
            ),
            Dimensions.kGap12,
            Icon(Icons.access_time_rounded, color: context.color.primary, size: 16),
            Dimensions.kGap4,
            Text(business.waitTime, style: context.textTheme.bodySmall?.copyWith(color: context.color.textSecondary)),
          ],
        ),
      ],
    ),
  );
}

final class _AppointmentTile extends StatelessWidget {
  const _AppointmentTile({required this.appointment});

  final HomeAppointmentEntity appointment;

  String _formatDate(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final year = value.year.toString();
    return '$day.$month.$year';
  }

  String _formatTime(DateTime value) {
    final int hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
    final String minute = value.minute.toString().padLeft(2, '0');
    final String period = value.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: Dimensions.kPaddingAll12,
    decoration: BoxDecoration(
      color: context.color.background,
      borderRadius: Dimensions.kBorderRadius12,
      border: Border.all(color: context.color.primary.withValues(alpha: 0.12)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          appointment.services.map((service) => service.name).join(', '),
          style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: context.color.textPrimary),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Dimensions.kGap4,
        Text(
          appointment.business?.name ?? context.l10n.unknownBusiness,
          style: context.textTheme.bodySmall?.copyWith(color: context.color.textSecondary),
        ),
        Dimensions.kGap8,
        Row(
          children: [
            Icon(Icons.calendar_today_rounded, color: context.color.primary, size: 16),
            Dimensions.kGap4,
            Text(
              _formatDate(appointment.startTime),
              style: context.textTheme.bodySmall?.copyWith(color: context.color.textSecondary),
            ),
            Dimensions.kGap12,
            Icon(Icons.access_time_rounded, color: context.color.primary, size: 16),
            Dimensions.kGap4,
            Text(
              '${_formatTime(appointment.startTime)} - ${_formatTime(appointment.endTime)}',
              style: context.textTheme.bodySmall?.copyWith(color: context.color.textSecondary),
            ),
          ],
        ),
      ],
    ),
  );
}
