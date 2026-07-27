import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/postcode_bloc.dart';
import '../bloc/postcode_event.dart';
import '../bloc/postcode_state.dart';

/// Widget for searching crime data by postcode
class PostcodeSearch extends StatefulWidget {
  const PostcodeSearch({super.key});

  @override
  State<PostcodeSearch> createState() => _PostcodeSearchState();
}

class _PostcodeSearchState extends State<PostcodeSearch> {
  final _postcodeController = TextEditingController();

  void _handleSearch() {
    final postcode = _postcodeController.text;
    context.read<PostcodeBloc>().add(ValidatePostcodeEvent(postcode));
  }

  @override
  void dispose() {
    _postcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _postcodeController,
          decoration: InputDecoration(
            labelText: 'Postcode',
            hintText: 'Enter UK postcode (e.g., SW1A 1AA)',
            border: const OutlineInputBorder(),
          ),
          onSubmitted: (_) => _handleSearch(),
        ),
        BlocBuilder<PostcodeBloc, PostcodeState>(
          builder: (context, state) {
            if (state is PostcodeInvalid) {
              return Column(
                children: [
                  const SizedBox(height: 8),
                  Text(
                    state.error,
                    style: TextStyle(color: Colors.red.shade600, fontSize: 12),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
        const SizedBox(height: 16),
        FButton(
          onPress: _handleSearch,
          mainAxisSize: MainAxisSize.max,
          child: const Text('Search'),
        ),
      ],
    );
  }
}
