import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:home/src/data/datasource/home_local_data_source.dart';
import 'package:home/src/domain/entities/home_appointment_entity.dart';
import 'package:home/src/domain/entities/home_business_entity.dart';
import 'package:home/src/domain/entities/home_category_entity.dart';
import 'package:home/src/domain/usecases/get_home_appointments.dart';
import 'package:home/src/domain/usecases/get_home_businesses.dart';
import 'package:home/src/domain/usecases/get_home_categories.dart';

part 'home_event.dart';
part 'home_state.dart';

final class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._getHomeCategories, this._getHomeBusinesses, this._getHomeAppointments, this._localDataSource)
    : super(const HomeInitialState()) {
    on<HomeLoadEvent>(_homeLoadHandler);
    on<HomeRefreshEvent>(_homeRefreshHandler);
  }

  final GetHomeCategories _getHomeCategories;
  final GetHomeBusinesses _getHomeBusinesses;
  final GetHomeAppointments _getHomeAppointments;
  final HomeLocalDataSource _localDataSource;

  Future<void> _homeLoadHandler(HomeLoadEvent event, Emitter<HomeState> emit) async {
    if (state is HomeLoadingState) {
      return;
    }
    emit(const HomeLoadingState());

    final categoriesResult = await _getHomeCategories();
    final businessesResult = await _getHomeBusinesses();
    final appointmentsResult = await _getHomeAppointments();

    Failure? failure;
    List<HomeCategoryEntity> categories = [];
    List<HomeBusinessEntity> businesses = [];
    List<HomeAppointmentEntity> appointments = [];

    categoriesResult.fold((left) => failure = left, (right) => categories = right);
    businessesResult.fold((left) => failure ??= left, (right) => businesses = right);
    appointmentsResult.fold((left) => failure ??= left, (right) => appointments = right);

    if (failure != null) {
      emit(HomeFailureState(message: failure?.message ?? 'Home data load failed'));
      return;
    }

    appointments.sort((a, b) => a.startTime.compareTo(b.startTime));
    final now = DateTime.now();
    final upcomingAppointments = appointments
        .where((appointment) => appointment.startTime.isAfter(now) || DateUtils.isSameDay(appointment.startTime, now))
        .toList();

    emit(
      HomeSuccessState(
        firstName: _localDataSource.firstName,
        categories: categories,
        businesses: businesses,
        appointments: upcomingAppointments,
      ),
    );
  }

  Future<void> _homeRefreshHandler(HomeRefreshEvent event, Emitter<HomeState> emit) =>
      _homeLoadHandler(const HomeLoadEvent(), emit);
}
