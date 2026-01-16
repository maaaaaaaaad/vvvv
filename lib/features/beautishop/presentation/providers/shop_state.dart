import 'package:equatable/equatable.dart';
import 'package:jellomark_mobile_owner/features/beautishop/domain/entities/beautishop.dart';

sealed class ShopState extends Equatable {
  const ShopState();

  @override
  List<Object?> get props => [];
}

class ShopInitial extends ShopState {
  const ShopInitial();
}

class ShopLoading extends ShopState {
  const ShopLoading();
}

class ShopLoaded extends ShopState {
  final Beautishop shop;

  const ShopLoaded({required this.shop});

  @override
  List<Object?> get props => [shop];
}

class ShopEmpty extends ShopState {
  const ShopEmpty();
}

class ShopError extends ShopState {
  final String message;

  const ShopError(this.message);

  @override
  List<Object?> get props => [message];
}

class ShopCreating extends ShopState {
  const ShopCreating();
}

class ShopUpdating extends ShopState {
  const ShopUpdating();
}

class ShopDeleting extends ShopState {
  const ShopDeleting();
}
