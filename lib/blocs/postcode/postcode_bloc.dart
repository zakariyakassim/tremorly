import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/postcode_service.dart';
import 'postcode_event.dart';
import 'postcode_state.dart';

class PostcodeBloc extends Bloc<PostcodeEvent, PostcodeState> {
  final PostcodeService postcodeService;

  PostcodeBloc({required this.postcodeService})
    : super(const PostcodeInitial()) {
    on<ValidatePostcodeEvent>(_onValidatePostcode);
    on<SelectPostcodeEvent>(_onSelectPostcode);
    on<ClearPostcodeEvent>(_onClearPostcode);
  }

  Future<void> _onValidatePostcode(
    ValidatePostcodeEvent event,
    Emitter<PostcodeState> emit,
  ) async {
    final postcode = event.postcode.trim();

    if (postcode.isEmpty) {
      emit(const PostcodeInvalid('Enter a UK postcode to continue.'));
      return;
    }

    emit(const PostcodeLoading());
    try {
      final validatedPostcode = await postcodeService.validatePostcode(
        postcode,
      );
      emit(PostcodeValid(validatedPostcode));
    } catch (e) {
      emit(PostcodeInvalid(e.toString()));
    }
  }

  void _onSelectPostcode(
    SelectPostcodeEvent event,
    Emitter<PostcodeState> emit,
  ) {
    emit(PostcodeValid(event.postcode));
  }

  Future<void> _onClearPostcode(
    ClearPostcodeEvent event,
    Emitter<PostcodeState> emit,
  ) async {
    emit(const PostcodeCleared());
  }
}
