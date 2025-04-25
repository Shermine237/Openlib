// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:openlib/ui/components/page_title_widget.dart';
import 'package:openlib/ui/results_page.dart';
import 'components/snack_bar_widget.dart';

import 'package:openlib/state/state.dart'
    show
        searchQueryProvider,
        selectedTypeState,
        selectedSortState,
        selectedFileTypeState,
        typeValues,
        fileType,
        sortValues,
        enableFiltersState;

import 'package:openlib/l10n/app_localizations.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  void onSubmit(BuildContext context, WidgetRef ref) {
    if (ref.read(searchQueryProvider).isNotEmpty) {
      ref.read(enableFiltersState.notifier).state = true;
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return ResultPage(searchQuery: ref.read(searchQueryProvider));
      }));
    } else {
      showSnackBar(context: context, message: 'Search field is empty');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dropdownTypeValue = ref.watch(selectedTypeState);
    final dropdownSortValue = ref.watch(selectedSortState);
    final dropDownFileTypeValue = ref.watch(selectedFileTypeState);

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(AppLocalizations.of(context)!.search),
            Padding(
              padding: const EdgeInsets.only(left: 7, right: 7, top: 10),
              child: TextField(
                showCursor: true,
                cursorColor: Theme.of(context).colorScheme.secondary,
                onChanged: (value) =>
                    ref.read(searchQueryProvider.notifier).state = value,
                onSubmitted: (value) => onSubmit(context, ref),
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.tertiary,
                        width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                  ),
                  suffixIcon: IconButton(
                    padding: const EdgeInsets.only(right: 5),
                    color: Theme.of(context).colorScheme.secondary,
                    icon: const Icon(
                      Icons.search,
                      size: 23,
                    ),
                    onPressed: () => onSubmit(context, ref),
                  ),
                  filled: true,
                  hintStyle: const TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                  hintText: AppLocalizations.of(context)!.searchHint,
                  fillColor: Theme.of(context).colorScheme.primary,
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 7, right: 7, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context)!.filterByType),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    value: dropdownTypeValue,
                    isExpanded: true,
                    items: typeValues.keys.map<DropdownMenuItem<String>>((String value) {
                      String displayText = '';
                      switch (value) {
                        case 'typeAll': displayText = AppLocalizations.of(context)!.typeAll;
                        case 'typeAnyBooks': displayText = AppLocalizations.of(context)!.typeAnyBooks;
                        case 'typeUnknownBooks': displayText = AppLocalizations.of(context)!.typeUnknownBooks;
                        case 'typeFictionBooks': displayText = AppLocalizations.of(context)!.typeFictionBooks;
                        case 'typeNonFictionBooks': displayText = AppLocalizations.of(context)!.typeNonFictionBooks;
                        case 'typeComicBooks': displayText = AppLocalizations.of(context)!.typeComicBooks;
                        case 'typeMagazine': displayText = AppLocalizations.of(context)!.typeMagazine;
                        case 'typeStandardsDocument': displayText = AppLocalizations.of(context)!.typeStandardsDocument;
                        case 'typeJournalArticle': displayText = AppLocalizations.of(context)!.typeJournalArticle;
                      }
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(displayText),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      if (value != null) {
                        ref.read(selectedTypeState.notifier).state = value;
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 7, right: 7, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context)!.filterBySort),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    value: dropdownSortValue,
                    isExpanded: true,
                    items: sortValues.keys.map<DropdownMenuItem<String>>((String value) {
                      String displayText = '';
                      switch (value) {
                        case 'sortMostRelevant': displayText = AppLocalizations.of(context)!.sortMostRelevant;
                        case 'sortNewest': displayText = AppLocalizations.of(context)!.sortNewest;
                        case 'sortOldest': displayText = AppLocalizations.of(context)!.sortOldest;
                        case 'sortLargest': displayText = AppLocalizations.of(context)!.sortLargest;
                        case 'sortSmallest': displayText = AppLocalizations.of(context)!.sortSmallest;
                      }
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(displayText),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      if (value != null) {
                        ref.read(selectedSortState.notifier).state = value;
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 7, right: 7, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context)!.filterByFileType),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    value: dropDownFileTypeValue,
                    isExpanded: true,
                    items: fileType.map<DropdownMenuItem<String>>((String value) {
                      String displayText = '';
                      switch (value) {
                        case 'fileTypeAll': displayText = AppLocalizations.of(context)!.fileTypeAll;
                        case 'fileTypePdf': displayText = AppLocalizations.of(context)!.fileTypePdf;
                        case 'fileTypeEpub': displayText = AppLocalizations.of(context)!.fileTypeEpub;
                        case 'fileTypeCbr': displayText = AppLocalizations.of(context)!.fileTypeCbr;
                        case 'fileTypeCbz': displayText = AppLocalizations.of(context)!.fileTypeCbz;
                      }
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(displayText),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      if (value != null) {
                        ref.read(selectedFileTypeState.notifier).state = value;
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
