import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_memo_app/memo_model.dart';
import 'package:get/get.dart';

class MemoWriteController extends GetxController {
  late CollectionReference memoCollectionRef;

  String title = '';
  String memo = '';
  DateTime? memoDate;

  @override
  void onInit() {
    super.onInit();
    memoCollectionRef = FirebaseFirestore.instance.collection('memo');
    memoDate = DateTime.now();
  }

  void setTitle(String title) {
    this.title = title;
    update();
  }

  void setMemo(String memo) {
    this.memo = memo;
    update();
  }

  void save() {
    var memoModel = MemoModel(title: title, memo: memo);
    memoCollectionRef.add(memoModel.toMap());
    Get.back(result: memoModel);
  }
}
