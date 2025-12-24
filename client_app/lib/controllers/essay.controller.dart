import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/legacy.dart';
import '../models/essay.model.dart';

// 1. Định nghĩa State (Dữ liệu mà UI sẽ quan sát)
class EssayState {
  final List<EssayModel> masterList;
  final List<EssayModel> filteredList;
  final bool isLoading;
  final String currentGroup;
  final Map<String, List<String>> userProgress;

  EssayState({
    this.masterList = const [],
    this.filteredList = const [],
    this.isLoading = false,
    this.currentGroup = "Kiến thức cơ sở",
    this.userProgress = const {},
  });

  EssayState copyWith({
    List<EssayModel>? masterList,
    List<EssayModel>? filteredList,
    bool? isLoading,
    String? currentGroup,
    Map<String, List<String>>? userProgress,
  }) {
    return EssayState(
      masterList: masterList ?? this.masterList,
      filteredList: filteredList ?? this.filteredList,
      isLoading: isLoading ?? this.isLoading,
      currentGroup: currentGroup ?? this.currentGroup,
      userProgress: userProgress ?? this.userProgress,
    );
  }
}

// 2. Tạo Provider toàn cục để UI ref.watch
final essayProvider = StateNotifierProvider<EssayController, EssayState>((ref) {
  return EssayController();
});

// 3. Class Controller xử lý Logic
class EssayController extends StateNotifier<EssayState> {
  EssayController() : super(EssayState());

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> fetchEssays() async {

    print("---------- BẮT ĐẦU FETCH DỮ LIỆU ----------");
    if (state.masterList.isNotEmpty) return;
    state = state.copyWith(isLoading: true);

    try {
      QuerySnapshot snapshot = await _db.collection('essays').orderBy('rawIndex').get();
      final list = snapshot.docs.map((doc) =>
          EssayModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id)).toList();

      debugPrint("Tổng số câu tải về: ${list.length}"); // Dòng này quan trọng
      debugPrint("Các Group hiện có: ${list.map((e) => e.group).toSet()}"); // Xem có bao nhiêu loại group

      state = state.copyWith(masterList: list, isLoading: false);
      applyFilter(); // Lọc mặc định sau khi tải xong
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void applyFilter({String? group, String? search}) {
    final grp = group ?? state.currentGroup;
    final query = search?.toLowerCase() ?? "";

    final filtered = state.masterList.where((item) {
      final matchesGroup = item.group == grp;
      final matchesSearch = query.isEmpty ||
          item.content.toLowerCase().contains(query) ||
          item.keywords.any((k) => k.toLowerCase().contains(query));
      return matchesGroup && matchesSearch;
    }).toList();

    state = state.copyWith(filteredList: filtered, currentGroup: grp);
  }

  void toggleKeyword(String essayId, String keyword) {
    final newProgress = Map<String, List<String>>.from(state.userProgress);
    final currentList = List<String>.from(newProgress[essayId] ?? []);

    if (currentList.contains(keyword)) {
      currentList.remove(keyword);
    } else {
      currentList.add(keyword);
    }

    newProgress[essayId] = currentList;
    state = state.copyWith(userProgress: newProgress);
  }

  double getProgress(String essayId, int totalKeys) {
    if (totalKeys == 0) return 0.0;
    int current = state.userProgress[essayId]?.length ?? 0;
    return (current / totalKeys).clamp(0.0, 1.0);
  }
}