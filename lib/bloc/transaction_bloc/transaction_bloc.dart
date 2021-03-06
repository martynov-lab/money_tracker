import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/data/models/category.dart';
import 'package:money_tracker/data/models/transaction.dart';
import 'package:money_tracker/data/repository/category_repository.dart';
import 'package:money_tracker/data/repository/transaction_repository.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository _transactionRepository;
  final CategoryRepository _categoryRepository;
  TransactionBloc(this._transactionRepository, this._categoryRepository)
      : super(TransactionEmptyState());

  // final TransactionRepository _transactionRepository;
  // TransactionBloc({required TransactionRepository transactionRepository})
  //     : _transactionRepository = transactionRepository,
  //       super(TransactionEmptyState());

  @override
  Stream<TransactionState> mapEventToState(TransactionEvent event) async* {
    if (event is TransactionLoad) {
      yield* _mapLoadTransactionToState();
    } else if (event is TransactionAdd) {
      yield* _mapAddTransactionToState(
        currentDate: event.currentDate,
        amount: event.amount,
        categoryId: event.categoryId,
        categoryName: event.categoryName,
        categoryColor: event.categoryColor,
        categoryIcon: event.categoryIcon,
        comment: event.comment,
        typeTransaction: event.typeTransaction,
      );
    } else if (event is TransactionUpdate) {
      yield* _mapUpdateTransactionToState(
        id: event.id,
        currentDate: event.currentDate,
        amount: event.amount,
        categoryId: event.categoryId,
        categoryName: event.categoryName,
        categoryColor: event.categoryColor,
        categoryIcon: event.categoryIcon,
        comment: event.comment,
        typeTransaction: event.typeTransaction,
      );
    } else if (event is TransactionDelete) {
      yield* _mapDeleteTransactionToState(
        id: event.id,
      );
    } else if (event is TransactionClearCompleted) {
      yield* _mapClearCompletedToState();
    }
  }

  Stream<TransactionState> _mapLoadTransactionToState() async* {
    try {
      yield TransactionLoadingState();

      List<MyTransaction>? transaction =
          await _transactionRepository.fetchTransaction();
      var sum = 0.00;

      if (transaction.isEmpty) {
        yield TransactionEmptyState();
      } else {
        for (var item in transaction) {
          //* ?????????????? ?????????? ???????? ????????????????????

          var value = item.amount;
          if (item.typeTransaction == 'income') {
            sum += double.parse(value!);
          } else if (item.typeTransaction == 'expenditure') {
            sum -= double.parse(value!);
          }
        }
        //* ???????????????????? ???????????????????? ???? ????????
        transaction.sort((a, b) => b.currentDate!.compareTo(a.currentDate!));

        transaction.forEach((element) {
          element.currentDate = DateFormat('dd.MM.yyyy')
              .format(DateTime.parse(element.currentDate!));
        });
        //* ?????????????????????? ???????????????????? ???? ????????.?????????????? ???????????? ???????????????????? ???? ????????
        var transactionGroupData =
            groupBy(transaction, (MyTransaction obj) => obj.currentDate);

        //* ?????????????????????? ???????????????????? ???? ??????????????????
        var transactionGroupCategory =
            groupBy(transaction, (MyTransaction obj) => obj.categoryName);
        //print('transactionGroupCategory - $transactionGroupCategory');

        //* ???????????? ??????????????????
        List<Category>? category = await _categoryRepository.fetchCategory();

        yield TransactionLoadedState(
          transactionGroupData,
          sum,
          category,
          transactionGroupCategory,
        );
      }
      // if (state is TransactionLoadedState) {
      //   yield TransactionLoadedState(transaction);
      //   print("???????????? ???????? State is Loaded: ${transaction}");
      // }
    } catch (e) {
      print('????????????: $e');
      yield TransactionErrorState();
    }
  }

  Stream<TransactionState> _mapAddTransactionToState({
    required String currentDate,
    required String amount,
    required String categoryId,
    required String categoryName,
    required String categoryColor,
    required int categoryIcon,
    required String comment,
    required String typeTransaction,
  }) async* {
    await _transactionRepository.addTransaction(
      currentDate: currentDate,
      amount: amount,
      categoryId: categoryId,
      categoryName: categoryName,
      categoryColor: categoryColor,
      categoryIcon: categoryIcon,
      comment: comment,
      typeTransaction: typeTransaction,
    );
    // if (state is TransactionLoadedState) {
    //   var transaction = await _transactionRepository.fetchTransaction();
    //   yield TransactionLoadedState(transaction);
    // }
  }

  Stream<TransactionState> _mapUpdateTransactionToState({
    required String id,
    required String currentDate,
    required String amount,
    required String categoryId,
    required String categoryName,
    required String categoryColor,
    required int categoryIcon,
    required String comment,
    required String typeTransaction,
  }) async* {
    await _transactionRepository.updateTransaction(
      id,
      currentDate,
      amount,
      categoryId,
      categoryName,
      categoryColor,
      categoryIcon,
      comment,
      typeTransaction,
    );
  }

  Stream<TransactionState> _mapDeleteTransactionToState({
    required String id,
  }) async* {
    await _transactionRepository.deleteTransaction(id);
  }

  Stream<TransactionState> _mapClearCompletedToState() async* {}
}
