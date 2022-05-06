import 'package:flutter/material.dart';
import 'package:tmdb_movie_app/core/utils/api_helper.dart';
import 'package:tmdb_movie_app/core/utils/api_url.dart';
import 'package:tmdb_movie_app/core/utils/state_enum.dart';
import 'package:tmdb_movie_app/models/batch_pagination_model.dart';
import 'package:tmdb_movie_app/models/http_response.dart';
import 'package:tmdb_movie_app/models/movie.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class SearchMovieProvider extends ChangeNotifier {
  String query;
  SearchType optionType;
  int currentTopPage;
  int currentBottomPage;
  int totalPage;
  ResultState stateFirstAttempt = ResultState.noData;
  ResultState stateTopPagination = ResultState.noData;
  ResultState stateBottomPagination = ResultState.noData;
  ResultState stateWithIndex = ResultState.noData;
  String detailMessageFirstAttempt = "";
  String detailMessageTopPagination = "";
  String detailMessageBottomPagination = "";
  String detailMessageWithIndex = "";
  List<BatchPaginationModel> data;
  int showedPageNumber;
  VoidCallback? setClosePagination;
  VoidCallback? setOpenPagination;
  Uuid uuid = const Uuid();
  String uniqueId = "";

  SearchMovieProvider({
    this.query = "",
    this.optionType = SearchType.lazyLoading,
    this.currentTopPage = 1,
    this.currentBottomPage = 1,
    this.totalPage = 1,
    this.data = const [],
    this.showedPageNumber = 1,
  });

  void requestDataFirstAttempt() async {
    currentTopPage = showedPageNumber;
    currentBottomPage = showedPageNumber;
    stateFirstAttempt = ResultState.loading;
    detailMessageFirstAttempt = "";
    data = [];
    notifyListeners();
    String usedQuery = query.isEmpty ? '""' : query;

    try {
      String lockId = uuid.v1();
      uniqueId = lockId;
      HTTPResponse response = await APIHelper.get(
        http.Client(),
        ApiUrl.searchMovie,
        {
          "query": Uri.encodeComponent(usedQuery),
          "page": showedPageNumber.toString(),
        },
      );
      if (uniqueId == lockId) {
        List<Movie> listMovie = List<Movie>.from(
          response.data["results"].map((x) => Movie.fromMap(x)),
        );
        int totalPage = response.data["total_pages"];
        stateFirstAttempt = ResultState.hasData;

        currentTopPage = showedPageNumber;
        currentBottomPage = showedPageNumber;
        this.totalPage = totalPage;
        data = [
          BatchPaginationModel(
            listMovie: listMovie,
            pageNumber: showedPageNumber,
            keyWidget: GlobalKey(),
          ),
        ];
        notifyListeners();
        checkOpenClosePagination();
      }
    } catch (e) {
      String errorMessage =
          (e is HTTPResponse ? e.message : 'Something went wrong')!;
      stateFirstAttempt = ResultState.error;
      detailMessageFirstAttempt = errorMessage;
      notifyListeners();
    }
  }

  void reload() async {
    requestDataFirstAttempt();
  }

  void changeQuery(String query) async {
    if (this.query != query) {
      this.query = query;
      showedPageNumber = 1;
      notifyListeners();
      requestDataFirstAttempt();
    }
  }

  void reloadTopPagination() {
    requestDataTopPagination();
  }

  void loadTopPagination() {
    if (currentTopPage > 1 &&
        stateTopPagination != ResultState.loading &&
        stateTopPagination != ResultState.error &&
        optionType == SearchType.lazyLoading) {
      currentTopPage = currentTopPage - 1;
      notifyListeners();
      requestDataTopPagination();
    }
  }

  void requestDataTopPagination() async {
    stateTopPagination = ResultState.loading;
    detailMessageTopPagination = "";
    notifyListeners();

    try {
      String lockId = uuid.v1();
      uniqueId = lockId;
      HTTPResponse response = await APIHelper.get(
        http.Client(),
        ApiUrl.searchMovie,
        {
          "query": Uri.encodeComponent(query),
          "page": currentTopPage.toString(),
        },
      );
      if (uniqueId == lockId) {
        List<Movie> listMovie = List<Movie>.from(
          response.data["results"].map((x) => Movie.fromMap(x)),
        );
        List<BatchPaginationModel> newList = List.from(data);
        newList.insert(
          0,
          BatchPaginationModel(
            pageNumber: currentTopPage,
            listMovie: listMovie,
            keyWidget: GlobalKey(),
          ),
        );

        stateTopPagination = ResultState.hasData;
        data = newList;
        notifyListeners();
      }
    } catch (e) {
      String errorMessage =
          (e is HTTPResponse ? e.message : 'Something went wrong')!;
      stateTopPagination = ResultState.error;
      detailMessageTopPagination = errorMessage;

      notifyListeners();
    }
  }

  void reloadBottomPagination() {
    requestDataBottomPagination();
  }

  void loadBottomPagination() {
    if (currentBottomPage < totalPage &&
        stateBottomPagination != ResultState.loading &&
        stateBottomPagination != ResultState.error &&
        optionType == SearchType.lazyLoading) {
      currentBottomPage = currentBottomPage + 1;
      notifyListeners();
      requestDataBottomPagination();
    }
  }

  void requestDataBottomPagination() async {
    if (optionType == SearchType.lazyLoading) {
      stateBottomPagination = ResultState.loading;
      detailMessageBottomPagination = "";

      notifyListeners();

      try {
        String lockId = uuid.v1();
        uniqueId = lockId;
        HTTPResponse response = await APIHelper.get(
          http.Client(),
          ApiUrl.searchMovie,
          {
            "query": Uri.encodeComponent(query),
            "page": currentBottomPage.toString(),
          },
        );
        if (uniqueId == lockId) {
          List<Movie> listMovie = List<Movie>.from(
            response.data["results"].map((x) => Movie.fromMap(x)),
          );
          List<BatchPaginationModel> newList = List.from(data);
          newList.add(
            BatchPaginationModel(
              pageNumber: currentBottomPage,
              listMovie: listMovie,
              keyWidget: GlobalKey(),
            ),
          );
          stateBottomPagination = ResultState.hasData;

          data = newList;
          notifyListeners();
        }
      } catch (e) {
        String errorMessage =
            (e is HTTPResponse ? e.message : 'Something went wrong')!;
        stateBottomPagination = ResultState.error;
        detailMessageBottomPagination = errorMessage;

        notifyListeners();
      }
    }
  }

  void changeOptionType(SearchType optionType, {int? selectedPage}) {
    if (optionType != this.optionType) {
      if (optionType == SearchType.withIndex) {
        this.optionType = optionType;
        stateWithIndex = ResultState.hasData;
        stateFirstAttempt = ResultState.hasData;
        detailMessageWithIndex = "";
        detailMessageFirstAttempt = "";
        notifyListeners();
        if (data.isNotEmpty && selectedPage != null) {
          changeShowedPageNumber(selectedPage);
        } else {
          changeShowedPageNumber(showedPageNumber);
        }
      } else if (optionType == SearchType.lazyLoading) {
        List<BatchPaginationModel> newList = [];
        newList = List.from(data);
        newList = newList.where((element) {
          return element.pageNumber == showedPageNumber;
        }).toList();

        if (newList.isEmpty) {
          this.optionType = optionType;
          data = [];
          currentBottomPage = showedPageNumber;
          currentTopPage = showedPageNumber;
          stateBottomPagination = ResultState.hasData;
          stateTopPagination = ResultState.hasData;
          detailMessageBottomPagination = "";
          detailMessageTopPagination = "";

          notifyListeners();
          requestDataFirstAttempt();
        } else {
          this.optionType = optionType;
          data = newList;
          currentBottomPage = showedPageNumber;
          currentTopPage = showedPageNumber;
          stateBottomPagination = ResultState.hasData;
          stateTopPagination = ResultState.hasData;
          detailMessageBottomPagination = "";
          detailMessageTopPagination = "";
          notifyListeners();
        }
      }
      checkOpenClosePagination();
    }
  }

  void changeShowedPageNumber(int pageNumber) {
    if (optionType == SearchType.withIndex) {
      bool isLoadedPage = false;
      for (var item in data) {
        int page = item.pageNumber;
        if (page == pageNumber) {
          isLoadedPage = true;
        }
      }

      if (!isLoadedPage) {
        showedPageNumber = pageNumber;
        notifyListeners();
        requestDataWithIndex();
      } else {
        showedPageNumber = pageNumber;
        stateWithIndex = ResultState.hasData;
        detailMessageWithIndex = "";
        notifyListeners();
      }
    }
  }

  void requestDataWithIndex() async {
    stateWithIndex = ResultState.loading;
    detailMessageWithIndex = "";

    notifyListeners();

    try {
      String lockId = uuid.v1();
      uniqueId = lockId;
      HTTPResponse response = await APIHelper.get(
        http.Client(),
        ApiUrl.searchMovie,
        {
          "query": Uri.encodeComponent(query),
          "page": showedPageNumber.toString(),
        },
      );
      if (uniqueId == lockId) {
        List<Movie> listMovie = List<Movie>.from(
          response.data["results"].map((x) => Movie.fromMap(x)),
        );
        List<BatchPaginationModel> newList = List.from(data);
        newList.add(
          BatchPaginationModel(
            pageNumber: showedPageNumber,
            listMovie: listMovie,
            keyWidget: GlobalKey(),
          ),
        );

        stateWithIndex = ResultState.hasData;

        data = newList;
        notifyListeners();
      }
    } catch (e) {
      String errorMessage =
          (e is HTTPResponse ? e.message : 'Something went wrong')!;
      stateWithIndex = ResultState.error;
      detailMessageWithIndex = errorMessage;
      notifyListeners();
    }
  }

  void checkOpenClosePagination() {
    if (optionType == SearchType.lazyLoading) {
      if (setClosePagination != null) {
        setClosePagination!();
      }
    } else if (optionType == SearchType.withIndex) {
      if (stateFirstAttempt != ResultState.loading &&
          stateFirstAttempt != ResultState.error &&
          data.isNotEmpty) {
        if (setOpenPagination != null) {
          setOpenPagination!();
        }
      } else {
        if (setClosePagination != null) {
          setClosePagination!();
        }
      }
    }
  }

  void setTogglePagination({
    required VoidCallback setOpen,
    required VoidCallback setClose,
  }) {
    setClosePagination = setClose;
    setOpenPagination = setOpen;
  }

  void checkOpenClosePaginationByNavigation(int indexPage) {
    if (indexPage != 1) {
      if (setClosePagination != null) {
        setClosePagination!();
      }
    } else {
      checkOpenClosePagination();
    }
  }
}
