import 'package:equatable/equatable.dart';

abstract class PostcodeEvent extends Equatable {
  const PostcodeEvent();

  @override
  List<Object> get props => [];
}

class ValidatePostcodeEvent extends PostcodeEvent {
  final String postcode;

  const ValidatePostcodeEvent(this.postcode);

  @override
  List<Object> get props => [postcode];
}

class ClearPostcodeEvent extends PostcodeEvent {
  const ClearPostcodeEvent();
}
