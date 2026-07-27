import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../blocs/postcode/postcode_bloc.dart';
import '../blocs/postcode/postcode_event.dart';
import '../blocs/postcode/postcode_state.dart';
import '../models/postcode.dart';
import '../theme/app_spacing.dart';
import 'field_prefix_icon.dart';

/// Widget for searching crime data by postcode
class PostcodeSearch extends StatefulWidget {
  const PostcodeSearch({super.key});

  @override
  State<PostcodeSearch> createState() => _PostcodeSearchState();
}

class _PostcodeSearchState extends State<PostcodeSearch> {
  static const _autocompleteDelay = Duration(milliseconds: 250);

  final _postcodeController = FAutocompleteController();
  final _postcodeSuggestions = <String, Postcode>{};
  int _autocompleteGeneration = 0;
  String _lastAutocompleteQuery = '';
  String? _suppressedAutocompleteQuery;
  bool _suggestionsShown = false;

  void _handleSubmit(String value) {
    FocusManager.instance.primaryFocus?.unfocus();
    final bloc = context.read<PostcodeBloc>();
    final postcode = value.trim().toUpperCase();
    final selected = _postcodeSuggestions[postcode];
    bloc.add(
      selected == null
          ? ValidatePostcodeEvent(postcode)
          : SelectPostcodeEvent(selected),
    );
  }

  void _selectPostcode(Postcode postcode) {
    _suppressedAutocompleteQuery = postcode.postcode.toUpperCase();
    _postcodeController.text = postcode.postcode;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _suggestionsShown = false);
    context.read<PostcodeBloc>().add(SelectPostcodeEvent(postcode));
  }

  Future<Iterable<String>> _findPostcodes(
    BuildContext context,
    String query,
  ) async {
    final generation = ++_autocompleteGeneration;
    final normalized = query
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ')
        .toUpperCase();
    _lastAutocompleteQuery = normalized;
    if (_suppressedAutocompleteQuery == normalized) {
      _suppressedAutocompleteQuery = null;
      return const [];
    }
    if (normalized.length < 2) {
      return const [];
    }

    final service = context.read<PostcodeBloc>().postcodeService;
    await Future<void>.delayed(_autocompleteDelay);
    if (generation != _autocompleteGeneration) {
      return const [];
    }

    final matches = await service.searchPostcodes(normalized);
    if (generation != _autocompleteGeneration) {
      return const [];
    }

    _postcodeSuggestions
      ..clear()
      ..addEntries(
        matches.map(
          (postcode) => MapEntry(postcode.postcode.toUpperCase(), postcode),
        ),
      );
    return matches.map((postcode) => postcode.postcode);
  }

  Widget? _suggestionSubtitle(String suggestion) {
    final postcode = _postcodeSuggestions[suggestion.toUpperCase()];
    if (postcode == null) {
      return null;
    }
    final location = [
      postcode.adminDistrict,
      postcode.region,
    ].where((value) => value.isNotEmpty).join(', ');
    return location.isEmpty ? null : Text(location);
  }

  @override
  void dispose() {
    _postcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostcodeBloc, PostcodeState>(
      builder: (context, state) {
        final loading = state is PostcodeLoading;
        final error = state is PostcodeInvalid ? state.error : null;

        return FAutocomplete.builder(
          key: const Key('postcode-field'),
          control: .managed(controller: _postcodeController),
          popoverControl: .lifted(
            shown: _suggestionsShown,
            onChange: (shown) => setState(() => _suggestionsShown = shown),
          ),
          filter: (query) => _findPostcodes(context, query),
          contentBuilder: (context, query, suggestions) => [
            for (final suggestion in suggestions)
              if (_postcodeSuggestions[suggestion.toUpperCase()]
                  case final postcode?)
                _PostcodeSuggestionItem(
                  key: Key('postcode-suggestion-$suggestion'),
                  postcode: postcode,
                  subtitle: _suggestionSubtitle(suggestion),
                  onSelect: () => _selectPostcode(postcode),
                ),
          ],
          label: const Text('UK postcode'),
          description: const Text(
            'Choose a matching postcode to load nearby incidents.',
          ),
          hint: 'Start with a postcode, for example SW1A',
          size: .lg,
          forceErrorText: error,
          enabled: !loading,
          textCapitalization: TextCapitalization.characters,
          textInputAction: TextInputAction.search,
          keyboardType: TextInputType.streetAddress,
          autocorrect: false,
          inputFormatters: [
            LengthLimitingTextInputFormatter(9),
            FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9 ]')),
          ],
          onSubmit: _handleSubmit,
          rightArrowToComplete: false,
          contentDivider: .full,
          contentLoadingBuilder: (context, style) => Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const FCircularProgress(
                  size: FCircularProgressSizeVariant.sm,
                  semanticsLabel: 'Loading postcode suggestions',
                ),
                const SizedBox(width: AppSpacing.sm),
                Text('Finding postcodes…', style: style.emptyTextStyle),
              ],
            ),
          ),
          contentEmptyBuilder: (context, style) => Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text(
              _lastAutocompleteQuery.length < 2
                  ? 'Type at least 2 characters.'
                  : 'No matching postcodes found.',
              style: style.emptyTextStyle,
            ),
          ),
          contentErrorBuilder: (context, error, stackTrace) => Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Icon(Iconsax.danger, color: context.theme.colors.destructive),
                const SizedBox(width: AppSpacing.sm),
                const Expanded(
                  child: Text(
                    'Suggestions could not be loaded. You can still '
                    'enter a full postcode and press Enter.',
                  ),
                ),
              ],
            ),
          ),
          prefixBuilder: (context, style, states) => FieldPrefixIcon(
            Iconsax.location,
            color: context.theme.colors.primary,
          ),
          suffixBuilder: loading
              ? (context, style, states) => const FCircularProgress(
                  size: FCircularProgressSizeVariant.sm,
                  semanticsLabel: 'Validating postcode',
                )
              : null,
        );
      },
    );
  }
}

class _PostcodeSuggestionItem extends StatelessWidget
    with FAutocompleteItemMixin {
  final Postcode postcode;
  final Widget? subtitle;
  final VoidCallback onSelect;

  const _PostcodeSuggestionItem({
    required this.postcode,
    required this.onSelect,
    this.subtitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FItem(
      onPress: onSelect,
      prefix: const Icon(Iconsax.location),
      title: Text(postcode.postcode),
      subtitle: subtitle,
    );
  }
}
