import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:negocio_listo_pro/core/usecases/usecase.dart';
import 'package:negocio_listo_pro/features/bookings/domain/usecases/add_booking_usecase.dart';
import 'package:negocio_listo_pro/features/bookings/domain/usecases/get_bookings_usecase.dart';
import 'package:negocio_listo_pro/features/bookings/presentation/bloc/booking_event.dart';
import 'package:negocio_listo_pro/features/bookings/presentation/bloc/booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final GetBookingsUseCase getBookingsUseCase;
  final AddBookingUseCase addBookingUseCase;

  BookingBloc({
    required this.getBookingsUseCase,
    required this.addBookingUseCase,
  }) : super(const BookingInitial()) {
    on<LoadBookings>(_onLoadBookings);
    on<AddBookingRequested>(_onAddBooking);
  }

  Future<void> _onLoadBookings(
    LoadBookings event,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingLoading());
    final result = await getBookingsUseCase(const NoParams());
    result.fold(
      (failure) => emit(BookingError(failure.message)),
      (bookings) => emit(BookingLoaded(bookings)),
    );
  }

  Future<void> _onAddBooking(
    AddBookingRequested event,
    Emitter<BookingState> emit,
  ) async {
    final result = await addBookingUseCase(event.booking);
    await result.fold(
      (failure) async => emit(BookingError(failure.message)),
      (_) => _onLoadBookings(const LoadBookings(), emit),
    );
  }
}
