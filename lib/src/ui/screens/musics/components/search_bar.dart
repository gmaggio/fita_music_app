import 'package:fita_music_app/src/states/musics/musics_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late TextEditingController _searchFieldController;
  late FocusNode _searchFieldFocusNode;

  @override
  void initState() {
    _searchFieldController = TextEditingController();
    _searchFieldFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _searchFieldController.dispose();
    _searchFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenTopPadding = MediaQuery.of(context).padding.top;

    final ThemeData theme = Theme.of(context);
    final Color defaultContentColor = theme.colorScheme.onPrimary;

    return DefaultTextStyle.merge(
      style: TextStyle(color: defaultContentColor),
      child: Container(
        padding: const EdgeInsets.all(28).copyWith(
          top: 20 + screenTopPadding,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Builder(
          builder: (context) {
            final UnderlineInputBorder fieldBorder = UnderlineInputBorder(
              borderSide: BorderSide(
                color: defaultContentColor.withOpacity(.7),
              ),
            );

            return TextField(
              focusNode: _searchFieldFocusNode,
              controller: _searchFieldController,
              style: theme.textTheme.bodyText1?.copyWith(
                color: defaultContentColor,
              ),
              cursorColor: defaultContentColor,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(12),
                border: fieldBorder,
                focusedBorder: fieldBorder,
                hintStyle: TextStyle(
                  color: defaultContentColor.withOpacity(.7),
                ),
                hintText: 'Search artist . . .',
                suffixIconColor: defaultContentColor,
                suffixIcon: MusicsSearchInputChangedSelector(
                  builder: (String searchKeyword) {
                    return IconButton(
                      icon: searchKeyword.isEmpty
                          ? Icon(
                              Icons.search,
                              color: defaultContentColor.withOpacity(.7),
                            )
                          : Icon(
                              Icons.close,
                              key: const Key('search-field-clear'),
                              color: defaultContentColor,
                            ),
                      onPressed: () {
                        _onClearIconPressed(searchKeyword);
                      },
                    );
                  },
                ),
              ),
              textInputAction: TextInputAction.done,
              onChanged: _onInputChanged,
              onEditingComplete: _onEditingComplete,
            );
          },
        ),
      ),
    );
  }

  // ACTIONS

  void _onClearIconPressed(String searchKeyword) {
    if (searchKeyword.isEmpty) return;

    _searchFieldController.clear();
    FocusScope.of(context).requestFocus(_searchFieldFocusNode);

    context.read<MusicsBloc>().add(const MusicsSearchInputChanged(''));
  }

  void _onInputChanged(String text) {
    context.read<MusicsBloc>().add(MusicsSearchInputChanged(text));
  }

  void _onEditingComplete() async {
    if (_searchFieldController.text.isNotEmpty) {
      final searchKeyword = _searchFieldController.text;

      context.read<MusicsBloc>().add(MusicsExecuteSearch(searchKeyword));

      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
