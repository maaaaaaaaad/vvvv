import 'package:equatable/equatable.dart';
import 'package:jellomark_mobile_owner/features/treatment/domain/entities/treatment.dart';

sealed class TreatmentState extends Equatable {
  const TreatmentState();

  @override
  List<Object?> get props => [];
}

class TreatmentInitial extends TreatmentState {
  const TreatmentInitial();
}

class TreatmentLoading extends TreatmentState {
  const TreatmentLoading();
}

class TreatmentListLoaded extends TreatmentState {
  final List<Treatment> treatments;

  const TreatmentListLoaded({required this.treatments});

  @override
  List<Object?> get props => [treatments];
}

class TreatmentEmpty extends TreatmentState {
  const TreatmentEmpty();
}

class TreatmentError extends TreatmentState {
  final String message;

  const TreatmentError(this.message);

  @override
  List<Object?> get props => [message];
}

class TreatmentCreating extends TreatmentState {
  const TreatmentCreating();
}

class TreatmentCreated extends TreatmentState {
  final Treatment treatment;

  const TreatmentCreated({required this.treatment});

  @override
  List<Object?> get props => [treatment];
}

class TreatmentUpdating extends TreatmentState {
  const TreatmentUpdating();
}

class TreatmentUpdated extends TreatmentState {
  final Treatment treatment;

  const TreatmentUpdated({required this.treatment});

  @override
  List<Object?> get props => [treatment];
}

class TreatmentDeleting extends TreatmentState {
  const TreatmentDeleting();
}

class TreatmentDeleted extends TreatmentState {
  const TreatmentDeleted();
}
