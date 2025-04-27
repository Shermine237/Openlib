import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Megalib'**
  String get appName;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @myLibrary.
  ///
  /// In en, this message translates to:
  /// **'My Library'**
  String get myLibrary;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @trending.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get trending;

  /// No description provided for @errorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading content'**
  String get errorLoading;

  /// No description provided for @noBooks.
  ///
  /// In en, this message translates to:
  /// **'No books found'**
  String get noBooks;

  /// No description provided for @downloadComplete.
  ///
  /// In en, this message translates to:
  /// **'Download complete'**
  String get downloadComplete;

  /// No description provided for @downloadError.
  ///
  /// In en, this message translates to:
  /// **'Download error'**
  String get downloadError;

  /// No description provided for @openWith.
  ///
  /// In en, this message translates to:
  /// **'Open with'**
  String get openWith;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get selectLanguage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @changeStoragePath.
  ///
  /// In en, this message translates to:
  /// **'Change storage path'**
  String get changeStoragePath;

  /// No description provided for @errorLoadingEpub.
  ///
  /// In en, this message translates to:
  /// **'Error loading epub file'**
  String get errorLoadingEpub;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search books...'**
  String get searchHint;

  /// No description provided for @searchFieldEmpty.
  ///
  /// In en, this message translates to:
  /// **'Search field is empty'**
  String get searchFieldEmpty;

  /// No description provided for @filterByType.
  ///
  /// In en, this message translates to:
  /// **'Filter by Type'**
  String get filterByType;

  /// No description provided for @filterBySort.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get filterBySort;

  /// No description provided for @filterByFileType.
  ///
  /// In en, this message translates to:
  /// **'File Type'**
  String get filterByFileType;

  /// No description provided for @filterByLanguage.
  ///
  /// In en, this message translates to:
  /// **'Filter by language'**
  String get filterByLanguage;

  /// No description provided for @typeAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get typeAll;

  /// No description provided for @typeAnyBooks.
  ///
  /// In en, this message translates to:
  /// **'Any Books'**
  String get typeAnyBooks;

  /// No description provided for @typeUnknownBooks.
  ///
  /// In en, this message translates to:
  /// **'Unknown Books'**
  String get typeUnknownBooks;

  /// No description provided for @typeFictionBooks.
  ///
  /// In en, this message translates to:
  /// **'Fiction Books'**
  String get typeFictionBooks;

  /// No description provided for @typeNonFictionBooks.
  ///
  /// In en, this message translates to:
  /// **'Non-fiction Books'**
  String get typeNonFictionBooks;

  /// No description provided for @typeComicBooks.
  ///
  /// In en, this message translates to:
  /// **'Comic Books'**
  String get typeComicBooks;

  /// No description provided for @typeMagazine.
  ///
  /// In en, this message translates to:
  /// **'Magazines'**
  String get typeMagazine;

  /// No description provided for @typeStandardsDocument.
  ///
  /// In en, this message translates to:
  /// **'Standards Document'**
  String get typeStandardsDocument;

  /// No description provided for @typeJournalArticle.
  ///
  /// In en, this message translates to:
  /// **'Journal Article'**
  String get typeJournalArticle;

  /// No description provided for @typeFiction.
  ///
  /// In en, this message translates to:
  /// **'Fiction'**
  String get typeFiction;

  /// No description provided for @typeNonFiction.
  ///
  /// In en, this message translates to:
  /// **'Non-fiction'**
  String get typeNonFiction;

  /// No description provided for @typeScientific.
  ///
  /// In en, this message translates to:
  /// **'Scientific articles'**
  String get typeScientific;

  /// No description provided for @typeComic.
  ///
  /// In en, this message translates to:
  /// **'Comics'**
  String get typeComic;

  /// No description provided for @typeStandard.
  ///
  /// In en, this message translates to:
  /// **'Standards documents'**
  String get typeStandard;

  /// No description provided for @sortMostRelevant.
  ///
  /// In en, this message translates to:
  /// **'Most Relevant'**
  String get sortMostRelevant;

  /// No description provided for @sortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get sortNewest;

  /// No description provided for @sortOldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest'**
  String get sortOldest;

  /// No description provided for @sortLargest.
  ///
  /// In en, this message translates to:
  /// **'Largest'**
  String get sortLargest;

  /// No description provided for @sortSmallest.
  ///
  /// In en, this message translates to:
  /// **'Smallest'**
  String get sortSmallest;

  /// No description provided for @fileTypeAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get fileTypeAll;

  /// No description provided for @fileTypePdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get fileTypePdf;

  /// No description provided for @fileTypeEpub.
  ///
  /// In en, this message translates to:
  /// **'EPUB'**
  String get fileTypeEpub;

  /// No description provided for @fileTypeCbr.
  ///
  /// In en, this message translates to:
  /// **'CBR'**
  String get fileTypeCbr;

  /// No description provided for @fileTypeCbz.
  ///
  /// In en, this message translates to:
  /// **'CBZ'**
  String get fileTypeCbz;

  /// No description provided for @langAll.
  ///
  /// In en, this message translates to:
  /// **'All languages'**
  String get langAll;

  /// No description provided for @langEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// No description provided for @langFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get langFrench;

  /// No description provided for @langGerman.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get langGerman;

  /// No description provided for @langSpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get langSpanish;

  /// No description provided for @langItalian.
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get langItalian;

  /// No description provided for @langRussian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get langRussian;

  /// No description provided for @langChinese.
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get langChinese;

  /// No description provided for @langJapanese.
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get langJapanese;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @mostRelevant.
  ///
  /// In en, this message translates to:
  /// **'Most Relevant'**
  String get mostRelevant;

  /// No description provided for @fileNotExists.
  ///
  /// In en, this message translates to:
  /// **'File does not exist'**
  String get fileNotExists;

  /// No description provided for @socketException.
  ///
  /// In en, this message translates to:
  /// **'Network error'**
  String get socketException;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @myBooks.
  ///
  /// In en, this message translates to:
  /// **'My Books'**
  String get myBooks;

  /// No description provided for @bookDetails.
  ///
  /// In en, this message translates to:
  /// **'Book Details'**
  String get bookDetails;

  /// No description provided for @author.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get author;

  /// No description provided for @publisher.
  ///
  /// In en, this message translates to:
  /// **'Publisher'**
  String get publisher;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @pages.
  ///
  /// In en, this message translates to:
  /// **'Pages'**
  String get pages;

  /// No description provided for @size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// No description provided for @format.
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get format;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @read.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get read;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteBookConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Delete Book'**
  String get deleteBookConfirmation;

  /// No description provided for @deletionIsPermanent.
  ///
  /// In en, this message translates to:
  /// **'This action is permanent and cannot be undone'**
  String get deletionIsPermanent;

  /// No description provided for @bookDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Book has been deleted'**
  String get bookDeletedSuccessfully;

  /// No description provided for @searchResult.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get searchResult;

  /// No description provided for @noResultFound.
  ///
  /// In en, this message translates to:
  /// **'No Results Found!'**
  String get noResultFound;

  /// No description provided for @myLibraryTitle.
  ///
  /// In en, this message translates to:
  /// **'My Library'**
  String get myLibraryTitle;

  /// No description provided for @myLibraryIsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Your library is empty'**
  String get myLibraryIsEmptyMessage;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @noDescription.
  ///
  /// In en, this message translates to:
  /// **'No description available'**
  String get noDescription;

  /// No description provided for @searchByTitle.
  ///
  /// In en, this message translates to:
  /// **'Search by title'**
  String get searchByTitle;

  /// No description provided for @searchByAuthor.
  ///
  /// In en, this message translates to:
  /// **'Search by author'**
  String get searchByAuthor;

  /// No description provided for @searchByPublisher.
  ///
  /// In en, this message translates to:
  /// **'Search by publisher'**
  String get searchByPublisher;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @relevance.
  ///
  /// In en, this message translates to:
  /// **'Relevance'**
  String get relevance;

  /// No description provided for @popularity.
  ///
  /// In en, this message translates to:
  /// **'Popularity'**
  String get popularity;

  /// No description provided for @newest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get newest;

  /// No description provided for @oldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest'**
  String get oldest;

  /// No description provided for @bookNotFound.
  ///
  /// In en, this message translates to:
  /// **'Book not found'**
  String get bookNotFound;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error'**
  String get networkError;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @storagePermission.
  ///
  /// In en, this message translates to:
  /// **'Storage permission'**
  String get storagePermission;

  /// No description provided for @storagePermissionMessage.
  ///
  /// In en, this message translates to:
  /// **'Storage permission is required to download and save books'**
  String get storagePermissionMessage;

  /// No description provided for @grantPermission.
  ///
  /// In en, this message translates to:
  /// **'Grant permission'**
  String get grantPermission;

  /// No description provided for @permissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get permissionDenied;

  /// No description provided for @downloadInProgress.
  ///
  /// In en, this message translates to:
  /// **'Download in progress...'**
  String get downloadInProgress;

  /// No description provided for @downloadStarted.
  ///
  /// In en, this message translates to:
  /// **'Download started'**
  String get downloadStarted;

  /// No description provided for @downloadCanceled.
  ///
  /// In en, this message translates to:
  /// **'Download canceled'**
  String get downloadCanceled;

  /// No description provided for @downloadPaused.
  ///
  /// In en, this message translates to:
  /// **'Download paused'**
  String get downloadPaused;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @bookmarks.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get bookmarks;

  /// No description provided for @addBookmark.
  ///
  /// In en, this message translates to:
  /// **'Add bookmark'**
  String get addBookmark;

  /// No description provided for @removeBookmark.
  ///
  /// In en, this message translates to:
  /// **'Remove bookmark'**
  String get removeBookmark;

  /// No description provided for @bookmarkAdded.
  ///
  /// In en, this message translates to:
  /// **'Bookmark added'**
  String get bookmarkAdded;

  /// No description provided for @bookmarkRemoved.
  ///
  /// In en, this message translates to:
  /// **'Bookmark removed'**
  String get bookmarkRemoved;

  /// No description provided for @openPdfWithExternalApp.
  ///
  /// In en, this message translates to:
  /// **'Open PDF with External App'**
  String get openPdfWithExternalApp;

  /// No description provided for @openEpubWithExternalApp.
  ///
  /// In en, this message translates to:
  /// **'Open EPUB with External App'**
  String get openEpubWithExternalApp;

  /// No description provided for @pageNumber.
  ///
  /// In en, this message translates to:
  /// **'Page {number}'**
  String pageNumber(int number);

  /// No description provided for @pageOf.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String pageOf(int current, int total);

  /// No description provided for @fontSize.
  ///
  /// In en, this message translates to:
  /// **'Font size'**
  String get fontSize;

  /// No description provided for @small.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get small;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @large.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get large;

  /// No description provided for @scrollingSpeed.
  ///
  /// In en, this message translates to:
  /// **'Scrolling speed'**
  String get scrollingSpeed;

  /// No description provided for @slow.
  ///
  /// In en, this message translates to:
  /// **'Slow'**
  String get slow;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @fast.
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get fast;

  /// No description provided for @veryFast.
  ///
  /// In en, this message translates to:
  /// **'Very fast'**
  String get veryFast;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemDefault;

  /// No description provided for @genres.
  ///
  /// In en, this message translates to:
  /// **'Genres'**
  String get genres;

  /// No description provided for @sciTech.
  ///
  /// In en, this message translates to:
  /// **'Sci-Tech'**
  String get sciTech;

  /// No description provided for @popular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popular;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @extension.
  ///
  /// In en, this message translates to:
  /// **'Extension'**
  String get extension;

  /// No description provided for @isbn.
  ///
  /// In en, this message translates to:
  /// **'ISBN'**
  String get isbn;

  /// No description provided for @ipfs.
  ///
  /// In en, this message translates to:
  /// **'IPFS'**
  String get ipfs;

  /// No description provided for @md5.
  ///
  /// In en, this message translates to:
  /// **'MD5'**
  String get md5;

  /// No description provided for @aboutPageDescription.
  ///
  /// In en, this message translates to:
  /// **'Megalib is an open source book search engine that allows you to search and download books from various sources.'**
  String get aboutPageDescription;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @github.
  ///
  /// In en, this message translates to:
  /// **'Github'**
  String get github;

  /// No description provided for @openGithubPage.
  ///
  /// In en, this message translates to:
  /// **'Open Github Page'**
  String get openGithubPage;

  /// No description provided for @contributeToMegalib.
  ///
  /// In en, this message translates to:
  /// **'Contribute To Megalib'**
  String get contributeToMegalib;

  /// No description provided for @reportAnIssue.
  ///
  /// In en, this message translates to:
  /// **'Report An Issue'**
  String get reportAnIssue;

  /// No description provided for @licence.
  ///
  /// In en, this message translates to:
  /// **'Licence'**
  String get licence;

  /// No description provided for @gplV30License.
  ///
  /// In en, this message translates to:
  /// **'GPL v3.0 license'**
  String get gplV30License;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @fileType.
  ///
  /// In en, this message translates to:
  /// **'File type'**
  String get fileType;

  /// No description provided for @couldNotOpenPdf.
  ///
  /// In en, this message translates to:
  /// **'Could not open the PDF'**
  String get couldNotOpenPdf;

  /// No description provided for @couldNotLaunchUrl.
  ///
  /// In en, this message translates to:
  /// **'Could not launch URL'**
  String get couldNotLaunchUrl;

  /// No description provided for @unableToOpenFile.
  ///
  /// In en, this message translates to:
  /// **'Unable to open file'**
  String get unableToOpenFile;

  /// No description provided for @unableToOpenEpub.
  ///
  /// In en, this message translates to:
  /// **'Unable to open epub'**
  String get unableToOpenEpub;

  /// No description provided for @bookDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Book has been downloaded!'**
  String get bookDownloaded;

  /// No description provided for @noMirrorsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No mirrors available'**
  String get noMirrorsAvailable;

  /// No description provided for @checksumFailed.
  ///
  /// In en, this message translates to:
  /// **'Checksum failed'**
  String get checksumFailed;

  /// No description provided for @checksumFailedWarning.
  ///
  /// In en, this message translates to:
  /// **'The downloaded book may be malicious. Delete it and get the same book from another source, or use the book at your own risk.'**
  String get checksumFailedWarning;

  /// No description provided for @addToLibrary.
  ///
  /// In en, this message translates to:
  /// **'Add To My Library'**
  String get addToLibrary;

  /// No description provided for @solveCaptcha.
  ///
  /// In en, this message translates to:
  /// **'Solve Captcha'**
  String get solveCaptcha;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @deleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this book?'**
  String get deleteConfirmation;

  /// No description provided for @classics.
  ///
  /// In en, this message translates to:
  /// **'Classics'**
  String get classics;

  /// No description provided for @classicsDescription.
  ///
  /// In en, this message translates to:
  /// **'Timeless literary works often revered for their artistic merit and cultural significance.'**
  String get classicsDescription;

  /// No description provided for @romance.
  ///
  /// In en, this message translates to:
  /// **'Romance'**
  String get romance;

  /// No description provided for @romanceDescription.
  ///
  /// In en, this message translates to:
  /// **'Stories focused on romantic relationships, exploring love, passion, and emotional connections.'**
  String get romanceDescription;

  /// No description provided for @fiction.
  ///
  /// In en, this message translates to:
  /// **'Fiction'**
  String get fiction;

  /// No description provided for @fictionDescription.
  ///
  /// In en, this message translates to:
  /// **'Narrative literature created from the imagination, not based on real events.'**
  String get fictionDescription;

  /// No description provided for @youngAdult.
  ///
  /// In en, this message translates to:
  /// **'Young Adult'**
  String get youngAdult;

  /// No description provided for @youngAdultDescription.
  ///
  /// In en, this message translates to:
  /// **'Literature aimed at adolescents and young adults, often dealing with coming-of-age themes.'**
  String get youngAdultDescription;

  /// No description provided for @fantasy.
  ///
  /// In en, this message translates to:
  /// **'Fantasy'**
  String get fantasy;

  /// No description provided for @fantasyDescription.
  ///
  /// In en, this message translates to:
  /// **'Literature featuring magical elements, mythical creatures, and imaginary worlds.'**
  String get fantasyDescription;

  /// No description provided for @scienceFiction.
  ///
  /// In en, this message translates to:
  /// **'Science Fiction'**
  String get scienceFiction;

  /// No description provided for @scienceFictionDescription.
  ///
  /// In en, this message translates to:
  /// **'Literature based on scientific concepts, technological advancement, and futuristic scenarios.'**
  String get scienceFictionDescription;

  /// No description provided for @nonfiction.
  ///
  /// In en, this message translates to:
  /// **'Nonfiction'**
  String get nonfiction;

  /// No description provided for @nonfictionDescription.
  ///
  /// In en, this message translates to:
  /// **'Literature based on facts, real events, and real people.'**
  String get nonfictionDescription;

  /// No description provided for @children.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get children;

  /// No description provided for @childrenDescription.
  ///
  /// In en, this message translates to:
  /// **'Literature written for and marketed to children.'**
  String get childrenDescription;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @historyDescription.
  ///
  /// In en, this message translates to:
  /// **'Literature about past events, people, and societies.'**
  String get historyDescription;

  /// No description provided for @mystery.
  ///
  /// In en, this message translates to:
  /// **'Mystery'**
  String get mystery;

  /// No description provided for @mysteryDescription.
  ///
  /// In en, this message translates to:
  /// **'Literature involving crime, suspense, and detective work.'**
  String get mysteryDescription;

  /// No description provided for @covers.
  ///
  /// In en, this message translates to:
  /// **'Covers'**
  String get covers;

  /// No description provided for @coversDescription.
  ///
  /// In en, this message translates to:
  /// **'Book covers and artwork.'**
  String get coversDescription;

  /// No description provided for @horror.
  ///
  /// In en, this message translates to:
  /// **'Horror'**
  String get horror;

  /// No description provided for @horrorDescription.
  ///
  /// In en, this message translates to:
  /// **'Literature designed to frighten and unsettle readers.'**
  String get horrorDescription;

  /// No description provided for @historicalFiction.
  ///
  /// In en, this message translates to:
  /// **'Historical Fiction'**
  String get historicalFiction;

  /// No description provided for @historicalFictionDescription.
  ///
  /// In en, this message translates to:
  /// **'Fiction set in the past, often during significant historical periods.'**
  String get historicalFictionDescription;

  /// No description provided for @best.
  ///
  /// In en, this message translates to:
  /// **'Best'**
  String get best;

  /// No description provided for @bestDescription.
  ///
  /// In en, this message translates to:
  /// **'Highly rated and popular books.'**
  String get bestDescription;

  /// No description provided for @titles.
  ///
  /// In en, this message translates to:
  /// **'Titles'**
  String get titles;

  /// No description provided for @titlesDescription.
  ///
  /// In en, this message translates to:
  /// **'Books organized by their titles.'**
  String get titlesDescription;

  /// No description provided for @middleGrade.
  ///
  /// In en, this message translates to:
  /// **'Middle Grade'**
  String get middleGrade;

  /// No description provided for @middleGradeDescription.
  ///
  /// In en, this message translates to:
  /// **'Literature for readers between children\'s and young adult levels.'**
  String get middleGradeDescription;

  /// No description provided for @paranormal.
  ///
  /// In en, this message translates to:
  /// **'Paranormal'**
  String get paranormal;

  /// No description provided for @paranormalDescription.
  ///
  /// In en, this message translates to:
  /// **'Literature featuring supernatural and paranormal elements.'**
  String get paranormalDescription;

  /// No description provided for @love.
  ///
  /// In en, this message translates to:
  /// **'Love'**
  String get love;

  /// No description provided for @loveDescription.
  ///
  /// In en, this message translates to:
  /// **'Literature focusing on romantic love and relationships.'**
  String get loveDescription;

  /// No description provided for @queer.
  ///
  /// In en, this message translates to:
  /// **'Queer'**
  String get queer;

  /// No description provided for @queerDescription.
  ///
  /// In en, this message translates to:
  /// **'Literature featuring LGBTQ+ themes and characters.'**
  String get queerDescription;

  /// No description provided for @historicalRomance.
  ///
  /// In en, this message translates to:
  /// **'Historical Romance'**
  String get historicalRomance;

  /// No description provided for @historicalRomanceDescription.
  ///
  /// In en, this message translates to:
  /// **'Romance novels set in historical periods.'**
  String get historicalRomanceDescription;

  /// No description provided for @contemporary.
  ///
  /// In en, this message translates to:
  /// **'Contemporary'**
  String get contemporary;

  /// No description provided for @contemporaryDescription.
  ///
  /// In en, this message translates to:
  /// **'Literature set in the present day.'**
  String get contemporaryDescription;

  /// No description provided for @thriller.
  ///
  /// In en, this message translates to:
  /// **'Thriller'**
  String get thriller;

  /// No description provided for @thrillerDescription.
  ///
  /// In en, this message translates to:
  /// **'Literature designed to create suspense and excitement.'**
  String get thrillerDescription;

  /// No description provided for @women.
  ///
  /// In en, this message translates to:
  /// **'Women'**
  String get women;

  /// No description provided for @womenDescription.
  ///
  /// In en, this message translates to:
  /// **'Literature focusing on women\'s experiences and perspectives.'**
  String get womenDescription;

  /// No description provided for @biography.
  ///
  /// In en, this message translates to:
  /// **'Biography'**
  String get biography;

  /// No description provided for @biographyDescription.
  ///
  /// In en, this message translates to:
  /// **'Non-fiction accounts of people\'s lives.'**
  String get biographyDescription;

  /// No description provided for @lgbtq.
  ///
  /// In en, this message translates to:
  /// **'LGBTQ'**
  String get lgbtq;

  /// No description provided for @lgbtqDescription.
  ///
  /// In en, this message translates to:
  /// **'Literature with LGBTQ+ themes and representation.'**
  String get lgbtqDescription;

  /// No description provided for @series.
  ///
  /// In en, this message translates to:
  /// **'Series'**
  String get series;

  /// No description provided for @seriesDescription.
  ///
  /// In en, this message translates to:
  /// **'Books that are part of a series.'**
  String get seriesDescription;

  /// No description provided for @titleChallenge.
  ///
  /// In en, this message translates to:
  /// **'Title Challenge'**
  String get titleChallenge;

  /// No description provided for @titleChallengeDescription.
  ///
  /// In en, this message translates to:
  /// **'Books participating in the title challenge.'**
  String get titleChallengeDescription;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
