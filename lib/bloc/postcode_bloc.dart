import 'package:bloc/bloc.dart';
import '../services/postcode_service.dart';
import 'postcode_event.dart';
import 'postcode_state.dart';

class PostcodeBloc extends Bloc<PostcodeEvent, PostcodeState> {
  final PostcodeService postcodeService;

  PostcodeBloc({required this.postcodeService})
    : super(const PostcodeInitial()) {
    on<ValidatePostcodeEvent>(_onValidatePostcode);
    on<ClearPostcodeEvent>(_onClearPostcode);
  }

  Future<void> _onValidatePostcode(
    ValidatePostcodeEvent event,
    Emitter<PostcodeState> emit,
  ) async {
    final postcode = event.postcode.trim();

    if (postcode.isEmpty) {
      emit(const PostcodeInvalid('Please enter a postcode'));
      return;
    }

    try {
      final validatedPostcode = await postcodeService.validatePostcode(
        postcode,
      );
      emit(PostcodeValid(validatedPostcode));
    } catch (e) {
      emit(PostcodeInvalid(e.toString()));
    }
  }

  Future<void> _onClearPostcode(
    ClearPostcodeEvent event,
    Emitter<PostcodeState> emit,
  ) async {
    emit(const PostcodeCleared());
  }
}
