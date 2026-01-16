import 'package:equatable/equatable.dart';
import 'package:jellomark_mobile_owner/features/auth/domain/entities/owner.dart';

sealed class OwnerState extends Equatable {
  const OwnerState();

  @override
  List<Object?> get props => [];
}

class OwnerInitial extends OwnerState {
  const OwnerInitial();
}

class OwnerLoading extends OwnerState {
  const OwnerLoading();
}

class OwnerLoaded extends OwnerState {
  final Owner owner;

  const OwnerLoaded({required this.owner});

  @override
  List<Object?> get props => [owner];
}

class OwnerError extends OwnerState {
  final String message;

  const OwnerError(this.message);

  @override
  List<Object?> get props => [message];
}
