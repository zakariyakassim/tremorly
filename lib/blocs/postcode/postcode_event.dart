import 'package:equatable/equatable.dart';
import '../../models/postcode.dart';

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

class SelectPostcodeEvent extends PostcodeEvent {
  final Postcode postcode;

  const SelectPostcodeEvent(this.postcode);

  @override
  List<Object> get props => [postcode];
}

class ClearPostcodeEvent extends PostcodeEvent {
  const ClearPostcodeEvent();
}
