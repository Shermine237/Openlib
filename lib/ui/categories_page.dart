// Flutter imports:
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports:
import 'package:openlib/ui/components/page_title_widget.dart';
import 'package:openlib/ui/extensions.dart';
import 'package:openlib/ui/results_page.dart';
import 'package:openlib/ui/components/error_widget.dart';
import 'package:openlib/state/state.dart'
    show getSubCategoryTypeList, enableFiltersState;
import 'package:openlib/l10n/app_localizations.dart';

class CategoryBook {
  final String info;
  final String thumbnail;
  final String title;
  final String tag;

  CategoryBook({
    required this.info,
    required this.thumbnail,
    required this.title,
    required this.tag,
  });

  factory CategoryBook.fromContext(
      BuildContext context, String info, String thumbnail, String title, String tag) {
    return CategoryBook(
      info: info,
      thumbnail: thumbnail,
      title: title,
      tag: tag,
    );
  }
}

List<CategoryBook> getCategoriesTypeValues(BuildContext context) {
  return [
    CategoryBook(
      info:
          "Timeless literary works often revered for their artistic merit and cultural significance.",
      thumbnail:
          "https://raw.githubusercontent.com/Nav-jangra/images/refs/heads/main/1%20classic.jpeg",
      title: AppLocalizations.of(context)!.classics,
      tag: "list/tag/classics",
    ),
    CategoryBook(
      info:
          "Stories focused on romantic relationships, exploring love, passion, and emotional connections.",
      thumbnail:
          "https://raw.githubusercontent.com/Nav-jangra/images/refs/heads/main/2%20romance.jpeg",
      title: AppLocalizations.of(context)!.romance,
      tag: "list/tag/romance",
    ),
    CategoryBook(
      info:
          "Narrative literature created from the imagination, not based on real events.",
      thumbnail:
          "https://raw.githubusercontent.com/Nav-jangra/images/refs/heads/main/3%20fiction.jpeg",
      title: AppLocalizations.of(context)!.fiction,
      tag: "list/tag/fiction",
    ),
    CategoryBook(
      info:
          "Literature aimed at adolescents and young adults, often dealing with coming-of-age themes.",
      thumbnail:
          "https://raw.githubusercontent.com/Nav-jangra/images/refs/heads/main/4%20young%20adult.jpeg",
      title: AppLocalizations.of(context)!.youngAdult,
      tag: "list/tag/young-adult",
    ),
    CategoryBook(
      info:
          "Literature featuring magical elements, mythical creatures, and imaginary worlds.",
      thumbnail:
          "https://raw.githubusercontent.com/Nav-jangra/images/refs/heads/main/5%20fantasy%20book.jpeg",
      title: AppLocalizations.of(context)!.fantasy,
      tag: "list/tag/fantasy",
    ),
    CategoryBook(
      info:
          "Literature based on scientific concepts, technological advancement, and futuristic scenarios.",
      thumbnail:
          "https://raw.githubusercontent.com/Nav-jangra/images/refs/heads/main/6%20science%20fiction.jpeg",
      title: AppLocalizations.of(context)!.scienceFiction,
      tag: "list/tag/science-fiction",
    ),
    CategoryBook(
      info:
          "Literature based on facts, real events, and real people.",
      thumbnail:
          "https://raw.githubusercontent.com/Nav-jangra/images/refs/heads/main/7%20non%20fiction.jpeg",
      title: AppLocalizations.of(context)!.nonfiction,
      tag: "list/tag/non-fiction",
    ),
    CategoryBook(
      info:
          "Literature written for and marketed to children.",
      thumbnail:
          "https://raw.githubusercontent.com/Nav-jangra/images/refs/heads/main/8%20children.jpeg",
      title: AppLocalizations.of(context)!.children,
      tag: "list/tag/children",
    ),
    CategoryBook(
      info:
          "Literature about past events, people, and societies.",
      thumbnail:
          "https://raw.githubusercontent.com/Nav-jangra/images/refs/heads/main/9%20history.jpeg",
      title: AppLocalizations.of(context)!.history,
      tag: "list/tag/history",
    ),
    CategoryBook(
      info:
          "Literature involving crime, suspense, and detective work.",
      thumbnail:
          "https://raw.githubusercontent.com/Nav-jangra/images/refs/heads/main/10%20mystery.jpeg",
      title: AppLocalizations.of(context)!.mystery,
      tag: "list/tag/mystery",
    ),
    CategoryBook(
      info:
          "Book covers and artwork.",
      thumbnail:
          "https://raw.githubusercontent.com/Nav-jangra/images/refs/heads/main/11%20covers.jpeg",
      title: AppLocalizations.of(context)!.covers,
      tag: "list/tag/covers",
    ),
    CategoryBook(
      info:
          "Literature designed to frighten and unsettle readers.",
      thumbnail:
          "https://raw.githubusercontent.com/Nav-jangra/images/refs/heads/main/12%20horror.jpeg",
      title: AppLocalizations.of(context)!.horror,
      tag: "list/tag/horror",
    ),
    CategoryBook(
      info:
          "Fiction set in the past, often during significant historical periods.",
      thumbnail:
          "https://raw.githubusercontent.com/Nav-jangra/images/refs/heads/main/13%20historical%20fiction.jpeg",
      title: AppLocalizations.of(context)!.historicalFiction,
      tag: "list/tag/historical-fiction",
    ),
    CategoryBook(
      info:
          "Highly rated and popular books.",
      thumbnail:
          "https://raw.githubusercontent.com/Nav-jangra/images/refs/heads/main/15%20best%20.jpeg",
      title: AppLocalizations.of(context)!.best,
      tag: "list/tag/best",
    ),
    CategoryBook(
      info:
          "Books organized by their titles.",
      thumbnail:
          "https://raw.githubusercontent.com/Nav-jangra/images/refs/heads/main/16%20titles.jpeg",
      title: AppLocalizations.of(context)!.titles,
      tag: "list/tag/titles",
    ),
    CategoryBook(
      info:
          "Literature for readers between children's and young adult levels.",
      thumbnail:
          "https://raw.githubusercontent.com/Nav-jangra/images/refs/heads/main/17%20middle%20grade.jpeg",
      title: AppLocalizations.of(context)!.middleGrade,
      tag: "list/tag/middle-grade",
    ),
    CategoryBook(
      info:
          "Literature featuring supernatural and paranormal elements.",
      thumbnail:
          "https://raw.githubusercontent.com/Nav-jangra/images/refs/heads/main/18%20paranormal.jpeg",
      title: AppLocalizations.of(context)!.paranormal,
      tag: "list/tag/paranormal",
    ),
    CategoryBook(
      info:
          "Literature focusing on romantic love and relationships.",
      thumbnail:
          "https://raw.githubusercontent.com/Nav-jangra/images/refs/heads/main/19%20love.jpeg",
      title: AppLocalizations.of(context)!.love,
      tag: "list/tag/love",
    ),
    CategoryBook(
      info:
          "Literature featuring LGBTQ+ themes and characters.",
      thumbnail:
          "https://raw.githubusercontent.com/Nav-jangra/images/refs/heads/main/20%20queer.jpeg",
      title: AppLocalizations.of(context)!.queer,
      tag: "list/tag/queer",
    ),
    CategoryBook(
      info:
          "Romance novels set in historical periods.",
      thumbnail:
          "https://raw.githubusercontent.com/Nav-jangra/images/refs/heads/main/22%20historical%20romance.jpeg",
      title: AppLocalizations.of(context)!.historicalRomance,
      tag: "list/tag/historical-romance",
    ),
    CategoryBook(
      info:
          "Literature set in the present day.",
      thumbnail:
          "https://raw.githubusercontent.com/Nav-jangra/images/refs/heads/main/24%20contemporary.jpeg",
      title: AppLocalizations.of(context)!.contemporary,
      tag: "list/tag/contemporary",
    ),
    CategoryBook(
      info:
          "Literature designed to create suspense and excitement.",
      thumbnail:
          "https://raw.githubusercontent.com/Nav-jangra/images/refs/heads/main/25%20thriller.jpeg",
      title: AppLocalizations.of(context)!.thriller,
      tag: "list/tag/thriller",
    ),
    CategoryBook(
      info:
          "Literature focusing on women's experiences and perspectives.",
      thumbnail:
          "https://raw.githubusercontent.com/Nav-jangra/images/refs/heads/main/26%20women.jpeg",
      title: AppLocalizations.of(context)!.women,
      tag: "list/tag/women",
    ),
    CategoryBook(
      info:
          "Non-fiction accounts of people's lives.",
      thumbnail:
          "https://raw.githubusercontent.com/Nav-jangra/images/refs/heads/main/27%20biography.jpeg",
      title: AppLocalizations.of(context)!.biography,
      tag: "list/tag/biography",
    ),
    CategoryBook(
      info:
          "Literature with LGBTQ+ themes and representation.",
      thumbnail:
          "https://raw.githubusercontent.com/Nav-jangra/images/refs/heads/main/28%20lgbtq.jpeg",
      title: AppLocalizations.of(context)!.lgbtq,
      tag: "list/tag/lgbtq",
    ),
    CategoryBook(
      info:
          "Books that are part of a series.",
      thumbnail:
          "https://raw.githubusercontent.com/Nav-jangra/images/refs/heads/main/29%20series%20.jpeg",
      title: AppLocalizations.of(context)!.series,
      tag: "list/tag/series",
    ),
    CategoryBook(
      info:
          "Books participating in the title challenge.",
      thumbnail:
          "https://raw.githubusercontent.com/Nav-jangra/images/refs/heads/main/30%20title%20chhallenge.jpeg",
      title: AppLocalizations.of(context)!.titleChallenge,
      tag: "list/tag/title-challenge",
    ),
  ];
}

class GenresPage extends ConsumerWidget {
  const GenresPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = getCategoriesTypeValues(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final category = categories[index];
                    return BookInfoCard(
                      title: category.title,
                      thumbnail: category.thumbnail,
                      info: category.info,
                      onClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return CategoryListingPage(
                                url: category.tag,
                                title: category.title,
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                  childCount: categories.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookInfoCard extends StatelessWidget {
  const BookInfoCard(
      {super.key,
      required this.title,
      required this.thumbnail,
      required this.info,
      required this.onClick});

  final String title;
  final String thumbnail;
  final String info;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CachedNetworkImage(
              height: 120,
              width: 90,
              imageUrl: thumbnail,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              placeholder: (context, url) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: "#F8C0C8".toColor(),
                ),
                height: 120,
                width: 90,
              ),
              errorWidget: (context, url, error) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: "#F8C0C8".toColor(),
                  ),
                  height: 120,
                  width: 90,
                  child: const Center(
                    child: Icon(Icons.image_rounded),
                  ),
                );
              },
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(5),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    Text(
                      info,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color:
                            Theme.of(context).textTheme.headlineMedium?.color,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class CategoryListingPage extends ConsumerWidget {
  const CategoryListingPage(
      {super.key, required this.url, required this.title});
  final double imageHeight = 145;
  final double imageWidth = 105;
  final String url;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksBasedOnGenre = ref.watch(getSubCategoryTypeList(url));
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text(AppLocalizations.of(context)!.appName),
          titleTextStyle: Theme.of(context).textTheme.displayLarge,
        ),
        body: booksBasedOnGenre.when(
            skipLoadingOnRefresh: false,
            data: (data) {
              return Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: TitleText(title),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(5),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 13.0,
                          mainAxisExtent: 205,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                ref.read(enableFiltersState.notifier).state =
                                    false;
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return ResultPage(
                                      searchQuery: data[index].title!);
                                }));
                              },
                              child: SizedBox(
                                width: double.infinity,
                                height: double.infinity,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CachedNetworkImage(
                                        height: imageHeight,
                                        width: imageWidth,
                                        imageUrl: data[index].thumbnail!,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.grey,
                                                  spreadRadius: 0.1,
                                                  blurRadius: 1)
                                            ],
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5)),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: "#E3E8E9".toColor(),
                                          ),
                                          height: imageHeight,
                                          width: imageWidth,
                                        ),
                                        errorWidget: (context, url, error) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.grey,
                                            ),
                                            height: imageHeight,
                                            width: imageWidth,
                                            child: const Center(
                                              child: Icon(Icons.image_rounded),
                                            ),
                                          );
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: SizedBox(
                                          width: imageWidth,
                                          child: Text(
                                            data[index].title!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium,
                                            maxLines: 2,
                                          ),
                                        ),
                                      ),
                                    ]),
                              ),
                            );
                          },
                          childCount: data.length,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            error: (error, _) {
              return CustomErrorWidget(
                error: error,
                stackTrace: _,
                // onRefresh: () {
                //   // ignore: unused_result
                //   ref.refresh(getbooksBasedOnGenre);
                // },
              );
            },
            loading: () {
              return Center(
                  child: SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.secondary,
                  strokeCap: StrokeCap.round,
                ),
              ));
            }));
  }
}
