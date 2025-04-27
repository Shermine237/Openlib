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
        enableFiltersState,
        selectedLanguageState,
        languageValues,
        selectedSourceState,
        sourceValues;

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
    final dropDownLanguageValue = ref.watch(selectedLanguageState);
    final dropDownSourceValue = ref.watch(selectedSourceState);

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
                        case 'all': displayText = AppLocalizations.of(context)!.typeAll;
                        case 'fiction': displayText = AppLocalizations.of(context)!.typeFiction;
                        case 'nonfiction': displayText = AppLocalizations.of(context)!.typeNonFiction;
                        case 'scientific': displayText = AppLocalizations.of(context)!.typeScientific;
                        case 'magazine': displayText = AppLocalizations.of(context)!.typeMagazine;
                        case 'comic': displayText = AppLocalizations.of(context)!.typeComic;
                        case 'standard': displayText = AppLocalizations.of(context)!.typeStandard;
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
                        case 'mostRelevant': displayText = AppLocalizations.of(context)!.sortMostRelevant;
                        case 'newest': displayText = AppLocalizations.of(context)!.sortNewest;
                        case 'oldest': displayText = AppLocalizations.of(context)!.sortOldest;
                        case 'largest': displayText = AppLocalizations.of(context)!.sortLargest;
                        case 'smallest': displayText = AppLocalizations.of(context)!.sortSmallest;
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
                        case 'all': displayText = AppLocalizations.of(context)!.fileTypeAll;
                        case 'pdf': displayText = AppLocalizations.of(context)!.fileTypePdf;
                        case 'epub': displayText = AppLocalizations.of(context)!.fileTypeEpub;
                        case 'doc': displayText = AppLocalizations.of(context)!.fileTypeDoc;
                        case 'docx': displayText = AppLocalizations.of(context)!.fileTypeDocx;
                        case 'cbr': displayText = AppLocalizations.of(context)!.fileTypeCbr;
                        case 'cbz': displayText = AppLocalizations.of(context)!.fileTypeCbz;
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
            Padding(
              padding: const EdgeInsets.only(left: 7, right: 7, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context)!.filterByLanguage),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    value: dropDownLanguageValue,
                    isExpanded: true,
                    items: languageValues.keys.map<DropdownMenuItem<String>>((String value) {
                      String displayText = '';
                      switch (value) {
                        case 'all': displayText = AppLocalizations.of(context)!.langAll;
                        case 'english': displayText = AppLocalizations.of(context)!.langEnglish;
                        case 'french': displayText = AppLocalizations.of(context)!.langFrench;
                        case 'german': displayText = AppLocalizations.of(context)!.langGerman;
                        case 'spanish': displayText = AppLocalizations.of(context)!.langSpanish;
                        case 'italian': displayText = AppLocalizations.of(context)!.langItalian;
                        case 'russian': displayText = AppLocalizations.of(context)!.langRussian;
                        case 'chinese': displayText = AppLocalizations.of(context)!.langChinese;
                        case 'japanese': displayText = AppLocalizations.of(context)!.langJapanese;
                      }
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(displayText),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      if (value != null) {
                        ref.read(selectedLanguageState.notifier).state = value;
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
                  Text(AppLocalizations.of(context)!.filterBySource),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    value: dropDownSourceValue,
                    isExpanded: true,
                    items: sourceValues.keys.map<DropdownMenuItem<String>>((String value) {
                      String displayText = '';
                      switch (value) {
                        case 'all': displayText = AppLocalizations.of(context)!.sourceAll;
                        case 'zlib': displayText = AppLocalizations.of(context)!.sourceZlib;
                        case 'zlibzh': displayText = AppLocalizations.of(context)!.sourceZlibzh;
                        case 'libgen': displayText = AppLocalizations.of(context)!.sourceLibgen;
                        case 'lgli': displayText = AppLocalizations.of(context)!.sourceLgli;
                        case 'lgrs': displayText = AppLocalizations.of(context)!.sourceLgrs;
                        case 'scihub': displayText = AppLocalizations.of(context)!.sourceScihub;
                        case 'magzdb': displayText = AppLocalizations.of(context)!.sourceMagzdb;
                        case 'duxiu': displayText = AppLocalizations.of(context)!.sourceDuxiu;
                        case 'nexusstc': displayText = AppLocalizations.of(context)!.sourceNexusstc;
                        case 'hathi': displayText = AppLocalizations.of(context)!.sourceHathi;
                        case 'ia': displayText = AppLocalizations.of(context)!.sourceIa;
                        case 'upload': displayText = AppLocalizations.of(context)!.sourceUpload;
                        case 'ipfs_infura': displayText = AppLocalizations.of(context)!.sourceIpfsInfura;
                        case 'ipfs_cloudflare': displayText = AppLocalizations.of(context)!.sourceIpfsCloudflare;
                      }
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(displayText),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      if (value != null) {
                        ref.read(selectedSourceState.notifier).state = value;
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
