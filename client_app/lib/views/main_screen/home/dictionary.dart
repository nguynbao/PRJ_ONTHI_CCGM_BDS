import 'package:flutter/material.dart';
import '../../../config/assets/app_icons.dart';
import '../../../controllers/dictionary.controller.dart';
import '../../../models/dictionary.model.dart';
import 'package:client_app/widget/modal/show_modal.dart';


class DictionaryPage extends StatefulWidget {

  final VoidCallback? onBackToHome;

  const DictionaryPage({super.key, this.onBackToHome});

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  String _search = "";
  final DictionaryController _controller = DictionaryController();

  List<DictionaryTerm> _terms = [];

  @override
  void initState() {
    super.initState();
    _loadTerms();
  }

  void _loadTerms() async {
    final data = await _controller.getAllTerms();
    setState(() {
      _terms = data;
    });
  }

  void _showTermDetail(DictionaryTerm term) {
    showTermDetailModal(context, term);
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                if (widget.onBackToHome != null) {
                  widget.onBackToHome!();
                } else {
                  // Chỉ dùng pop() làm fallback nếu nó được push lên như một Route
                  Navigator.of(context).pop();
                }
              },
              icon: Image.asset(AppIcons.imgBack, color: Colors.black),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _search = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Tìm thuật ngữ…",
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.blueAccent,
                        width: 1.2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: _terms.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _terms
                  .where((item) => item.term
                  .toLowerCase()
                  .contains(_search.toLowerCase()))
                  .length,
              itemBuilder: (context, index) {
                final filtered = _terms
                    .where((item) => item.term
                    .toLowerCase()
                    .contains(_search.toLowerCase()))
                    .toList();

                final term = filtered[index];
                return _buildTermCard(term);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermCard(DictionaryTerm term) {
    return InkWell(
      onTap: () => _showTermDetail(term),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.blueAccent,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    term.term,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    term.definition,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}