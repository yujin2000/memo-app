import 'package:flutter/material.dart';
import 'package:flutter_memo_app/admob_banner.dart';
import 'package:flutter_memo_app/memo_list_controller.dart';
import 'package:flutter_memo_app/memo_model.dart';
import 'package:flutter_memo_app/memo_write_controller.dart';
import 'package:flutter_memo_app/memo_write_page.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  Widget _searchBar() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Color(0xffD8D8D8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Image.asset('assets/images/search.png'),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller:
                  Get.find<MemoListController>().searchKeywordController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '검색',
                hintStyle: TextStyle(
                  color: Color(0xff888888),
                  fontSize: 15,
                ),
              ),
              onChanged: (value) {
                Get.find<MemoListController>().search(value);
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.find<MemoListController>().clearSearchKeyword();
            },
            child: Icon(
              Icons.close,
              color: Color(0xff888888),
            ),
          ),
        ],
      ),
    );
  }

  Widget _monthlyMemoGroup(String monthString, List<MemoModel> memoList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 30),
        Text(
          '$monthString월',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          padding: const EdgeInsets.only(left: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(
              memoList.length,
              (i) {
                return GestureDetector(
                  onTap: () async {
                    var result = await Get.to(MemoWritePage(),
                        binding: BindingsBuilder(() {
                      Get.put(MemoWriteController(memoModel: memoList[i]));
                    }));
                    if (result != null) {
                      Get.find<MemoListController>().reload();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xffECECEC),
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          memoList[i].title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          memoList[i].memo,
                          style:
                              TextStyle(fontSize: 14, color: Color(0xff848484)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEBEBEB),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // 키보드 외 화면 눌렀을 때 키보드 비활성화
          FocusScope.of(context).unfocus(); // 추가
        },
        // 시스템 영역 침범하지 않게 공간 확보
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '메모',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _searchBar(),
                GetBuilder<MemoListController>(builder: (controller) {
                  List<String> keys = [];
                  List<List<MemoModel>> values = [];
                  controller.memoGroup.forEach((key, value) {
                    keys.add(key);
                    values.add(value);
                  });
                  return Column(
                    children: List.generate(keys.length, (i) {
                      return _monthlyMemoGroup(keys[i], values[i]);
                    }),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result =
              await Get.to(MemoWritePage(), binding: BindingsBuilder(() {
            Get.put(MemoWriteController());
          }));
          if (result != null) {
            Get.find<MemoListController>().reload();
          }
        },
        backgroundColor: Color(0xffF7C354),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Image.asset('assets/images/plus.png'),
      ),
      bottomNavigationBar: AdmobBanner(),
    );
  }
}
