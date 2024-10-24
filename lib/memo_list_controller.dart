import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_memo_app/memo_model.dart';
import 'package:get/get.dart';

class MemoListController extends GetxController {
  late CollectionReference memoCollectionRef;
  List<MemoModel> memoList = [];
  Map<String, List<MemoModel>> memoGroup = {};

  @override
  void onInit() {
    super.onInit();
    memoCollectionRef = FirebaseFirestore.instance.collection('memo');
    loadAllMemos();
  }

  TextEditingController searchKeywordController = TextEditingController();

  void clearSearchKeyword() {
    searchKeywordController.text = '';
    reload();
  }

  void loadAllMemos() async {
    var memoData = await memoCollectionRef.get();
    memoList = memoData.docs
        .map<MemoModel>(
            (data) => MemoModel.fromJson(data.data() as Map<String, dynamic>))
        .toList();
    var monthkey = -1;
    memoList.map((memo) {
      monthkey = memo.createdAt.month;

      var group = memoGroup[monthkey.toString()];
      if (group == null) {
        group = [memo];
      } else {
        group.add(memo);
      }
      memoGroup[monthkey.toString()] = group;
    }).toList();
    print(memoGroup);
    update();
  }

  void reload() {
    memoGroup = {};
    loadAllMemos();
  }

  void search(String searchKeyword) {
    var searchResult = memoList.where((memo) {
      return memo.title.contains(searchKeyword) ||
          memo.memo.contains(searchKeyword);
    }).toList();
    memoGroup = {};
    var monthkey = -1;
    searchResult.map((memo) {
      monthkey = memo.createdAt.month;
      var group = memoGroup[monthkey.toString()];
      if (group == null) {
        group = [memo];
      } else {
        group.add(memo);
      }
      memoGroup[monthkey.toString()] = group;
    }).toList();
    update();
  }
}
