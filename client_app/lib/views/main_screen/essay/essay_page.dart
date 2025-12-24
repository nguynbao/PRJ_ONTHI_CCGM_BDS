import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../controllers/essay.controller.dart';
import '../../../config/themes/app_color.dart'; // Đảm bảo đúng đường dẫn file AppColor
import 'essay_detail.dart';

class EssayPage extends ConsumerStatefulWidget {
  const EssayPage({super.key});

  @override
  ConsumerState<EssayPage> createState() => _EssayPageState();
}

class _EssayPageState extends ConsumerState<EssayPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(essayProvider.notifier).fetchEssays());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(essayProvider);
    final notifier = ref.read(essayProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white, // Sử dụng màu nền sáng
      appBar: AppBar(
        title: Text(
          "Ôn thi Tự luận",
          style: TextStyle(color: AppColor.textpriCol, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(115.h),
          child: Column(
            children: [
              // --- THANH TÌM KIẾM ---
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => notifier.applyFilter(search: val),
                  style: const TextStyle(color: AppColor.textpriCol),
                  decoration: InputDecoration(
                    hintText: "Tìm danh mục hoặc nội dung...",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                    prefixIcon: const Icon(Icons.search, color: AppColor.buttonprimaryCol),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          notifier.applyFilter(search: "");
                          FocusScope.of(context).unfocus();
                        })
                        : null,
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16.w),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              // --- TABS ---
              Row(
                children: [
                  _tabButton("Kiến thức cơ sở", state.currentGroup),
                  _tabButton("Kiến thức chuyên môn", state.currentGroup),
                ],
              ),
            ],
          ),
        ),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColor.buttonprimaryCol))
          : state.filteredList.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: state.filteredList.length,
        separatorBuilder: (context, index) => SizedBox(height: 14.h),
        itemBuilder: (context, index) {
          final item = state.filteredList[index];
          return _buildEssayCard(item, state, notifier);
        },
      ),
    );
  }

  Widget _buildEssayCard(dynamic item, dynamic state, dynamic notifier) {
    // Lấy tiến độ từ controller
    final progress = notifier.getProgress(item.id, item.keywords.length);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: AppColor.textpriCol.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => EssayDetailPage(essay: item))
        ),
        borderRadius: BorderRadius.circular(15.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColor.buttonprimaryCol.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      "Câu ${item.rawIndex}",
                      style: TextStyle(
                        color: AppColor.buttonprimaryCol,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      item.category,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColor.textpriCol.withOpacity(0.7),
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Icon trạng thái hoàn thành
                  if (progress == 1.0)
                    const Icon(Icons.check_circle, color: AppColor.buttomSecondCol, size: 20),
                ],
              ),
              SizedBox(height: 10.h),
              Text(
                item.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: AppColor.textpriCol,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 12.h),
              // Thanh tiến độ nhỏ dưới mỗi card
              ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 4.h,
                  backgroundColor: Colors.grey[100],
                  valueColor: AlwaysStoppedAnimation<Color>(
                      progress == 1.0 ? AppColor.buttomSecondCol : AppColor.buttonprimaryCol
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.find_in_page_outlined, size: 70.r, color: Colors.grey[300]),
          SizedBox(height: 16.h),
          Text(
            "Không tìm thấy nội dung phù hợp",
            style: TextStyle(color: Colors.grey, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }

  Widget _tabButton(String group, String currentGroup) {
    bool isSelected = currentGroup == group;
    return Expanded(
      child: InkWell(
        onTap: () {
          ref.read(essayProvider.notifier).applyFilter(group: group);
          _searchController.clear();
        },
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AppColor.buttonprimaryCol : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            group,
            style: TextStyle(
              color: isSelected ? AppColor.buttonprimaryCol : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
    );
  }
}