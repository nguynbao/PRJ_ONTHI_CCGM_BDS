import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:confetti/confetti.dart'; // Thêm dependency: confetti: ^0.7.0 cho animation success
import '../../../controllers/flashcard.controller.dart';
import '../../../models/flashcard_card.model.dart';
import '../../../models/flashcard_set.model.dart';

class AddFlashcardSetPage extends StatefulWidget {
  const AddFlashcardSetPage({super.key});

  @override
  State<AddFlashcardSetPage> createState() => _AddFlashcardSetPageState();
}

class _AddFlashcardSetPageState extends State<AddFlashcardSetPage> with TickerProviderStateMixin {
  final FlashcardService _flashcardService = FlashcardService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  String _difficulty = 'Cơ bản';
  String? _newSetId;
  bool _isLoading = false;

  // Danh sách thẻ tạm thời cho bộ đề đang tạo
  List<FlashcardCard> _cards = [];

  // Confetti controller cho animation success
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  // Thêm bộ đề mới vào Firestore
  Future<void> _createSet() async {
    if (_formKey.currentState!.validate() && _cards.isNotEmpty) {
      setState(() {
        _isLoading = true;
        _newSetId = 'LOADING';
      });

      final newSet = FlashcardSet(
        id: '', // ID sẽ được Firestore cung cấp
        title: _titleController.text,
        subtitle: _subtitleController.text,
        difficulty: _difficulty,
      );

      try {
        final setId = await _flashcardService.addFlashcardSet(newSet);
        setState(() {
          _newSetId = setId;
        });

        // Sau khi tạo set, thêm các card đã lưu tạm thời
        for (var card in _cards) {
          await _flashcardService.addCard(setId, card);
        }

        // Trigger confetti
        _confettiController.play();

        // Thông báo thành công và thoát sau delay
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 8),
                  Text('Tạo bộ đề và thẻ thành công!'),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
          // Delay để confetti chạy
          await Future.delayed(const Duration(seconds: 2));
          if (mounted) Navigator.pop(context);
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
          _newSetId = null;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error, color: Colors.red),
                  const SizedBox(width: 8),
                  Text('Lỗi: Không thể tạo bộ đề. ${e.toString()}'),
                ],
              ),
              backgroundColor: Colors.red.shade100,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      }
    }
  }

  void _showAddCardDialog() {
    String question = '';
    String answer = '';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder( // <<< SỬ DỤNG STATEFULBUILDER
        builder: (context, setDialogState) {
          // Hàm kiểm tra tính hợp lệ
          bool isButtonEnabled = question.isNotEmpty && answer.isNotEmpty;

          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              padding: const EdgeInsets.all(20),
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ... (Phần Header không đổi)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade400, Colors.blue.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.add_card, color: Colors.white, size: 28),
                        SizedBox(width: 12),
                        Text(
                          'Thêm Thẻ Mới',
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // TextField cho Câu hỏi
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Câu hỏi',
                      prefixIcon: const Icon(Icons.help_outline, color: Colors.blue),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    onChanged: (value) => setDialogState(() { // <<< GỌI setDialogState()
                      question = value;
                    }),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  // TextField cho Trả lời
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Trả lời',
                      prefixIcon: const Icon(Icons.lightbulb_outline, color: Colors.green),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    onChanged: (value) => setDialogState(() { // <<< GỌI setDialogState()
                      answer = value;
                    }),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  // Nút Thêm
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                        label: const Text('Hủy'),
                        style: TextButton.styleFrom(foregroundColor: Colors.grey),
                      ),
                      ElevatedButton.icon(
                        // <<< Kiểm tra isButtonEnabled
                        onPressed: isButtonEnabled
                            ? () {
                          // Thêm thẻ
                          setState(() {
                            _cards.add(FlashcardCard(
                              id: UniqueKey().toString(),
                              question: question,
                              answer: answer,
                            ));
                          });
                          Navigator.pop(context);
                          HapticFeedback.lightImpact();
                        }
                            : null, // <<< Đặt là null nếu không hợp lệ
                        icon: const Icon(Icons.add),
                        label: const Text('Thêm'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isButtonEnabled ? Colors.blue.shade600 : Colors.grey, // <<< Cập nhật màu
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Tạo Bộ Flashcard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade600, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showHelpDialog(),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade100, Colors.indigo.shade100],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade200.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.school, size: 40, color: Colors.blue),
                        SizedBox(height: 8),
                        Text(
                          'Tạo bộ đề học tập của bạn',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                        Text(
                          'Thêm tiêu đề, mô tả và thẻ để bắt đầu!',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- Phần Thông tin Set ---
                  _buildSectionHeader('Thông tin Bộ Đề', Icons.folder_open),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _titleController,
                    label: 'Tiêu đề bộ đề',
                    hint: 'VD: Luật Đất đai 2024',
                    icon: Icons.title,
                    validator: (value) => value!.isEmpty ? 'Vui lòng nhập tiêu đề' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _subtitleController,
                    label: 'Mô tả ngắn',
                    hint: 'Mô tả nội dung bộ đề...',
                    icon: Icons.description,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  _buildDifficultySelector(),
                  const SizedBox(height: 32),

                  // --- Phần Quản lý Card ---
                  _buildSectionHeader('Thẻ Flashcard', Icons.credit_card),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Thẻ Flashcard',
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${_cards.length} thẻ đã thêm',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                        FloatingActionButton(
                          mini: true,
                          onPressed: _showAddCardDialog,
                          backgroundColor: Colors.blue.shade600,
                          child: const Icon(Icons.add, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Danh sách Card tạm thời với preview đẹp
                  if (_cards.isEmpty)
                    _buildEmptyState()
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _cards.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final card = _cards[index];
                        return _buildCardPreview(card, index);
                      },
                    ),
                  const SizedBox(height: 80), // Space cho bottom button
                ],
              ),
            ),
          ),
          // Confetti overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: 0.5,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.1,
              colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange],
            ),
          ),
        ],
      ),
      // Nút Lưu floating
      floatingActionButton: _isLoading
          ? null
          : FloatingActionButton.extended(
        onPressed: _cards.isEmpty ? null : _createSet,
        backgroundColor: Colors.green.shade600,
        icon: const Icon(Icons.save, color: Colors.white),
        label: Text(
          _cards.isEmpty ? 'Thêm ít nhất 1 thẻ' : 'Lưu bộ đề',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue.shade600, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.blue.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: validator,
    );
  }

  Widget _buildDifficultySelector() {
    return SegmentedButton<String>(
      segments: const [
        ButtonSegment(value: 'Dễ', label: Text('Dễ'), icon: Icon(Icons.sentiment_very_satisfied)),
        ButtonSegment(value: 'Trung bình', label: Text('Trung bình'), icon: Icon(Icons.sentiment_neutral)),
        ButtonSegment(value: 'Khó', label: Text('Khó'), icon: Icon(Icons.sentiment_dissatisfied)),
      ],
      selected: {_difficulty},
      onSelectionChanged: (Set<String> newSelection) {
        setState(() {
          _difficulty = newSelection.first;
        });
      },
      style: SegmentedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.card_membership_outlined, size: 64, color: Colors.orange.shade400),
          const SizedBox(height: 16),
          Text(
            'Chưa có thẻ nào',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange.shade700),
          ),
          const SizedBox(height: 8),
          Text(
            'Nhấn nút + để thêm thẻ flashcard đầu tiên!',
            style: TextStyle(color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCardPreview(FlashcardCard card, int index) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.purple.shade400, Colors.pink.shade400]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.question_mark, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.question,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    card.answer,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
              onPressed: () {
                setState(() {
                  _cards.removeAt(index);
                });
                HapticFeedback.lightImpact();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.help_outline, color: Colors.blue),
            SizedBox(width: 8),
            Text('Hướng dẫn'),
          ],
        ),
        content: const Text(
          '1. Nhập thông tin bộ đề.\n2. Thêm ít nhất 1 thẻ flashcard.\n3. Nhấn "Lưu Bộ Đề" để tạo trên Firestore.\n\nMẹo: Thẻ sẽ được lưu tạm và thêm tự động sau khi tạo bộ đề!',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}