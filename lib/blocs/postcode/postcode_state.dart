import 'package:equatable/equatable.dart';
import '../../models/postcode.dart';

abstract class PostcodeState extends Equatable {
  const PostcodeState();

  @override
  List<Object> get props => [];
}

class PostcodeInitial extends PostcodeState {
  const PostcodeInitial();
}

class PostcodeLoading extends PostcodeState {
  const PostcodeLoading();
}

class PostcodeValid extends PostcodeState {
  final Postcode postcode;

  const PostcodeValid(this.postcode);

  @override
  List<Object> get props => [postcode];
}

class PostcodeInvalid extends PostcodeState {
  final String error;

  const PostcodeInvalid(this.error);

  @override
  List<Object> get props => [error];
}

class PostcodeCleared extends PostcodeState {
  const PostcodeCleared();
}
