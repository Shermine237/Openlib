// Package imports:
import 'package:dio/dio.dart';
import 'package:html/parser.dart' show parse;

class TrendingBookData {
  final String? title;
  final String? thumbnail;
  TrendingBookData({this.title, this.thumbnail});
}

abstract class TrendingBooksImpl {
  String url = '';
  int timeOutDuration = 20;
  List<TrendingBookData> _parser(dynamic data);

  Future<List<TrendingBookData>> trendingBooks() async {
    try {
      print("Fetching URL: $url");
      final dio = Dio();
      final response = await dio.get(url,
          options: Options(
              sendTimeout: Duration(seconds: timeOutDuration),
              receiveTimeout: Duration(seconds: timeOutDuration)));
      
      print("Response status: ${response.statusCode}");
      print("Response length: ${response.data?.toString().length}");
      
      if (response.statusCode == 200) {
        var books = _parser(response.data.toString());
        print("Parsed books count: ${books.length}");
        return books;
      } else {
        print("Error status code: ${response.statusCode}");
        return [];
      }
    } on DioException catch (e) {
      print("Dio error: ${e.message}");
      print("Error type: ${e.type}");
      if (e.response != null) {
        print("Error response: ${e.response?.statusCode}");
      }
      return [];
    } catch (e) {
      print("Other error: $e");
      return [];
    }
  }
}

class GoodReads extends TrendingBooksImpl {
  GoodReads({required String language}) {
    url = language == 'fr' 
        ? "https://www.goodreads.com/list/show/84164.Les_meilleurs_livres_d_origine_fran_aise?tab=all_votes"
        : "https://www.goodreads.com/shelf/show/trending";
  }

  @override
  List<TrendingBookData> _parser(data) {
    print("Starting to parse data");
    var document = parse(data.toString());
    List<TrendingBookData> trendingBooks = [];
    
    if (url.contains("84164.Les_meilleurs_livres_d_origine_fran_aise")) {
      // Parser pour la page française
      print("Parsing French page");
      var bookList = document.querySelectorAll('tr[itemscope]');
      print("Found ${bookList.length} table rows");
      
      for (var element in bookList) {
        var titleElement = element.querySelector('a.bookTitle span[itemprop="name"]');
        var imageElement = element.querySelector('img.bookCover');
        var titleText = titleElement?.text;
        var imageUrl = imageElement?.attributes['src'];
        
        print("Found element - Title: $titleText, Image: $imageUrl");
        
        if (titleText != null && imageUrl != null) {
          // Remplacer les petites images par des plus grandes
          var largeImageUrl = imageUrl
              .replaceAll("._SY75_.", "._SY225_.")
              .replaceAll("._SX50_.", "._SX148_.");
              
          trendingBooks.add(
            TrendingBookData(
              title: titleText.trim(),
              thumbnail: largeImageUrl,
            ),
          );
        }
      }
    } else {
      // Parser pour la page anglaise
      var bookList = document.querySelectorAll('div[class="elementList"]');
      for (var element in bookList) {
        var titleElement = element.querySelector('a[class="leftAlignedImage"]');
        var imageElement = element.querySelector('img');
        var titleText = titleElement?.attributes['title'];
        var imageUrl = imageElement?.attributes['src'];
        
        if (titleText != null && imageUrl != null) {
          trendingBooks.add(
            TrendingBookData(
              title: titleText.trim(),
              thumbnail: imageUrl.replaceAll("._SY75_.", "._SY225_.")
                  .replaceAll("._SX50_.", "._SX148_."),
            ),
          );
        }
      }
    }
    
    print("Total books found: ${trendingBooks.length}");
    return trendingBooks;
  }
}

/* Commented out as we're only using GoodReads for now
class OpenLibrary extends TrendingBooksImpl {
  OpenLibrary() {
    super.url = "https://openlibrary.org/trending/daily";
  }

  @override
  List<TrendingBookData> _parser(data) {
    var document = parse(data.toString());
    var bookList =
        document.querySelectorAll('li[class="searchResultItem sri--w-main"]');
    List<TrendingBookData> trendingBooks = [];
    for (var element in bookList) {
      if (element.querySelector('h3[class="booktitle"]')?.text != null &&
          element.querySelector('img[itemprop="image" ]')?.attributes['src'] !=
              null) {
        String? thumbnail =
            element.querySelector('img[itemprop="image" ]')?.attributes['src'];
        trendingBooks.add(
          TrendingBookData(
              title:
                  element.querySelector('h3[class="booktitle"]')?.text.trim(),
              thumbnail: 'https:${thumbnail.toString()}'),
        );
      }
    }
    return trendingBooks;
  }

  @override
  Future<List<TrendingBookData>> trendingBooks() async {
    try {
      final dio = Dio();
      const timeOutDuration = 5;
      final response = await dio.get(url,
          options: Options(
              sendTimeout: const Duration(seconds: timeOutDuration),
              receiveTimeout: const Duration(seconds: timeOutDuration)));
      final response2 = await dio.get(
          "https://openlibrary.org/trending/daily?page=2",
          options: Options(
              sendTimeout: const Duration(seconds: timeOutDuration),
              receiveTimeout: const Duration(seconds: timeOutDuration)));
      return _parser('${response.data.toString()}${response2.data.toString()}');
    } on DioException catch (_) {
      return [];
    }
  }
}

class PenguinRandomHouse extends TrendingBooksImpl {
  PenguinRandomHouse() {
    super.url =
        "https://www.penguinrandomhouse.com/ajaxc/categories/books/?from=0&to=50&contentId=&elClass=book&dataType=html&catFilter=best-sellers";
  }

  @override
  List<TrendingBookData> _parser(data) {
    var document = parse(data.toString());
    var bookList = document.querySelectorAll('div[class="book"]');
    List<TrendingBookData> trendingBooks = [];
    for (var element in bookList) {
      if (element.querySelector('div[class="title"]')?.text != null &&
          element
                  .querySelector('img[class="responsive_img"]')
                  ?.attributes['src'] !=
              null) {
        String? thumbnail = element
            .querySelector('img[class="responsive_img"]')
            ?.attributes['src'];
        trendingBooks.add(
          TrendingBookData(
              title: element
                  .querySelector('div[class="title"]')
                  ?.text
                  .toString()
                  .trim(),
              thumbnail: thumbnail.toString()),
        );
      }
    }
    return trendingBooks;
  }
}

class BookDigits extends TrendingBooksImpl {
  BookDigits() {
    super.url = "https://bookdigits.com/fresh";
  }

  @override
  List<TrendingBookData> _parser(data) {
    var document = parse(data.toString());
    var bookList = document.querySelectorAll('div[class="list-row"]');
    List<TrendingBookData> trendingBooks = [];
    for (var element in bookList) {
      if (element.querySelector('div[class="list-title link-reg"]')?.text !=
              null &&
          element.querySelector('img')?.attributes['src'] != null) {
        String? thumbnail = element.querySelector('img')?.attributes['src'];
        trendingBooks.add(
          TrendingBookData(
              title: element
                  .querySelector('div[class="list-title link-reg"]')
                  ?.text
                  .toString()
                  .trim(),
              thumbnail: thumbnail.toString()),
        );
      }
    }
    return trendingBooks;
  }
}
*/
