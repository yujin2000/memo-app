import 'package:cloud_firestore/cloud_firestore.dart';
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
}
