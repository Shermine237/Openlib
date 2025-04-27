// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

// Project imports:
import 'package:openlib/services/annas_archieve.dart';
import 'package:openlib/services/database.dart';
import 'package:openlib/services/files.dart';
import 'package:openlib/services/open_library.dart';
import 'package:openlib/services/goodreads.dart';

MyLibraryDb dataBase = MyLibraryDb.instance;

//Provider for dropdownbutton in search page

Map<String, String> typeValues = {
  'all': '',
  'fiction': 'book_fiction',
  'nonfiction': 'book_nonfiction',
  'scientific': 'scientific_article',
  'magazine': 'magazine',
  'comic': 'comic',
  'standard': 'standards_document',
};

Map<String, String> sortValues = {
  'mostRelevant': '',
  'newest': 'newest',
  'oldest': 'oldest',
  'largest': 'largest',
  'smallest': 'smallest',
};

List<String> fileType = [
  'all',
  'pdf',
  'epub',
  'doc',
  'docx',
  'cbr',
  'cbz'
];

Map<String, String> sourceValues = {
  'all': '',
  'zlib': 'zlib',
  'zlibzh': 'zlibzh',
  'libgen': 'libgen',
  'lgli': 'lgli',
  'lgrs': 'lgrs',
  'scihub': 'scihub',
  'magzdb': 'magzdb',
  'duxiu': 'duxiu',
  'nexusstc': 'nexusstc',
  'hathi': 'hathi',
  'ia': 'ia',
  'upload': 'upload',
  'ipfs_infura': 'ipfs_infura',
  'ipfs_cloudflare': 'ipfs_cloudflare'
};

final selectedIndexProvider = StateProvider<int>((ref) => 0);
final homePageSelectedIndexProvider = StateProvider<int>((ref) => 0);

// Database provider
final databaseProvider = Provider<Database>((ref) => throw UnimplementedError('Database must be initialized'));

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

final localeProvider = StateProvider<Locale?>((ref) => null);

class LocaleNotifier extends StateNotifier<Locale?> {
  final Database database;
  
  LocaleNotifier(this.database) : super(null) {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    try {
      final result = await database.query(
        'preferences',
        columns: ['value'],
        where: 'name = ?',
        whereArgs: ['locale'],
      );
      
      if (result.isNotEmpty) {
        state = Locale(result.first['value'] as String);
      }
    } catch (e) {
      // Ignore les erreurs de base de données
    }
  }

  Future<void> setLocale(Locale? newLocale) async {
    state = newLocale;
    if (newLocale != null) {
      await database.insert(
        'preferences',
        {
          'name': 'locale',
          'value': newLocale.languageCode,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      await database.delete(
        'preferences',
        where: 'name = ?',
        whereArgs: ['locale'],
      );
    }
  }
}

final localeNotifierProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  final database = ref.watch(databaseProvider);
  return LocaleNotifier(database);
});

final selectedTypeState = StateProvider<String>((ref) => "all");

final getTypeValue = Provider.autoDispose<String>((ref) {
  return typeValues[ref.read(selectedTypeState)] ?? '';
});

final selectedSortState = StateProvider<String>((ref) => "mostRelevant");

final getSortValue = Provider.autoDispose<String>((ref) {
  return sortValues[ref.read(selectedSortState)] ?? '';
});

final selectedFileTypeState = StateProvider<String>((ref) => "all");

final getFileTypeValue = Provider.autoDispose<String>((ref) {
  final selectedType = ref.read(selectedFileTypeState);
  switch (selectedType) {
    case "pdf":
      return "pdf";
    case "epub":
      return "epub";
    case "doc":
      return "doc";
    case "docx":
      return "docx";
    case "cbr":
      return "cbr";
    case "cbz":
      return "cbz";
    default:
      return "";
  }
});

final selectedSourceState = StateProvider<String>((ref) => "all");

final getSourceValue = Provider.autoDispose<String>((ref) {
  return sourceValues[ref.watch(selectedSourceState)] ?? '';
});

//searchQueryProvider

final searchQueryProvider = StateProvider<String>((ref) => "");

// Sub category type list providers

final getSubCategoryTypeList = FutureProvider.family
    .autoDispose<List<CategoryBookData>, String>((ref, url) async {
  SubCategoriesTypeList subCategoriesTypeList = SubCategoriesTypeList();
  List<CategoryBookData> subCategories =
      await subCategoriesTypeList.categoriesBooks(url: url);
  List<CategoryBookData> uniqueArray = subCategories.toSet().toList();
  uniqueArray.shuffle();
  return uniqueArray;
});

//Provider for Trending Books

final getTrendingBooks = FutureProvider<List<TrendingBookData>>((ref) async {
  // OpenLibrary openLibrary = OpenLibrary();
  GoodReads goodReads = GoodReads();
  PenguinRandomHouse penguinTrending = PenguinRandomHouse();
  BookDigits bookDigits = BookDigits();
  List<TrendingBookData> trendingBooks =
      await Future.wait<List<TrendingBookData>>([
    goodReads.trendingBooks(),
    penguinTrending.trendingBooks(),
    // openLibrary.trendingBooks(),
    bookDigits.trendingBooks(),
  ]).then((List<List<TrendingBookData>> listOfData) =>
          listOfData.expand((element) => element).toList());

  if (trendingBooks.isEmpty) {
    throw 'Nothing Trending Today :(';
  }
  trendingBooks.shuffle();
  return trendingBooks;
});

final enableFiltersState = StateProvider<bool>((ref) => true);

//Provider for Trending Books
final searchProvider = FutureProvider.family
    .autoDispose<List<BookData>, String>((ref, searchQuery) async {
  AnnasArchieve annasArchieve = AnnasArchieve();
  List<BookData> data = await annasArchieve.searchBooks(
      searchQuery: searchQuery,
      content: ref.watch(getTypeValue),
      sort: ref.watch(getSortValue),
      fileType: ref.watch(getFileTypeValue),
      source: ref.watch(getSourceValue),
      language: ref.watch(getLanguageValue),
      enableFilters: ref.watch(enableFiltersState));
  return data;
});

final cookieProvider = StateProvider<String>((ref) => "");
final userAgentProvider = StateProvider<String>((ref) => "");

final webViewLoadingState = StateProvider.autoDispose<bool>((ref) => true);

//Provider for Book Info
final bookInfoProvider =
    FutureProvider.family<BookInfoData, String>((ref, url) async {
  AnnasArchieve annasArchieve = AnnasArchieve();
  BookInfoData data = await annasArchieve.bookInfo(url: url);
  return data;
});

final downloadProgressProvider =
    StateProvider.autoDispose<double>((ref) => 0.0);

final mirrorStatusProvider = StateProvider.autoDispose<bool>((ref) => false);

final totalFileSizeInBytes = StateProvider.autoDispose<int>((ref) => 0);
final downloadedFileSizeInBytes = StateProvider.autoDispose<int>((ref) => 0);

String bytesToFileSize(int bytes) {
  const int decimals = 1;
  const suffixes = ["b", " Kb", "Mb", "Gb", "Tb"];
  if (bytes == 0) return '0${suffixes[0]}';
  var i = (log(bytes) / log(1024)).floor();
  return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
}

final getTotalFileSize = StateProvider.autoDispose<String>((ref) {
  return bytesToFileSize(ref.watch(totalFileSizeInBytes));
});

final getDownloadedFileSize = StateProvider.autoDispose<String>((ref) {
  return bytesToFileSize(ref.watch(downloadedFileSizeInBytes));
});

final cancelCurrentDownload = StateProvider<CancelToken>((ref) {
  return CancelToken();
});

enum ProcessState { waiting, running, complete }

enum CheckSumProcessState { waiting, running, failed, success }

final downloadState =
    StateProvider.autoDispose<ProcessState>((ref) => ProcessState.waiting);
final checkSumState = StateProvider.autoDispose<CheckSumProcessState>(
    (ref) => CheckSumProcessState.waiting);

final myLibraryProvider = FutureProvider((ref) async {
  return dataBase.getAll();
});

final checkIdExists =
    FutureProvider.family.autoDispose<bool, String>((ref, id) async {
  return await dataBase.checkIdExists(id);
});

class FileName {
  final String md5;
  final String format;

  FileName({required this.md5, required this.format});
}

final deleteFileFromMyLib =
    FutureProvider.family<void, FileName>((ref, fileName) async {
  return await deleteFileWithDbData(ref, fileName.md5, fileName.format);
});

final pdfCurrentPage = StateProvider.autoDispose<int>((ref) => 0);
final totalPdfPage = StateProvider.autoDispose<int>((ref) => 0);

Future<void> savePdfState(String fileName, WidgetRef ref) async {
  String position = ref.watch(pdfCurrentPage).toString();
  await dataBase.saveBookState(fileName, position);
}

Future<void> saveEpubState(
    String fileName, String? position, WidgetRef ref) async {
  String pos = position ?? '';
  await dataBase.saveBookState(fileName, pos);
}

final getBookPosition =
    FutureProvider.family.autoDispose<String?, String>((ref, fileName) async {
  return await dataBase.getBookState(fileName);
});

final openPdfWithExternalAppProvider = StateProvider<bool>((ref) => false);
final openEpubWithExternalAppProvider = StateProvider<bool>((ref) => false);

final filePathProvider =
    FutureProvider.family<String, String>((ref, fileName) async {
  String path = await getFilePath(fileName);
  return path;
});

Map<String, String> languageValues = {
  'all': '',
  'english': 'en',
  'french': 'fr',
  'german': 'de',
  'spanish': 'es',
  'italian': 'it',
  'russian': 'ru',
  'chinese': 'zh',
  'japanese': 'ja',
};

final selectedLanguageState = StateProvider<String>((ref) => "all");

final getLanguageValue = Provider.autoDispose<String>((ref) {
  return languageValues[ref.watch(selectedLanguageState)] ?? '';
});
