import 'package:client_app/controllers/flashcard.controller.dart';
import 'package:client_app/models/flashcard_card.model.dart';
import 'package:client_app/models/flashcard_set.model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

class FlashcardSetDetailPage extends StatefulWidget {
  final FlashcardSet set;

  const FlashcardSetDetailPage({super.key, required this.set});

  @override
  State<FlashcardSetDetailPage> createState() => _FlashcardSetDetailPageState();
}

class _FlashcardSetDetailPageState extends State<FlashcardSetDetailPage> {
  final FlashcardService _flashcardService = FlashcardService();
  final PageController _pageController = PageController();

  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _updateProgress(String cardId, {bool? isCompleted, bool? isMarked}) {
    _flashcardService.updateProgress(
      cardId,
      isCompleted: isCompleted,
      isMarked: isMarked,
    );
  }

  /// Stream chung: Cards + Progress gộp lại
  Stream<Map<String, dynamic>> _combinedStream() {
    final cardsStream = _flashcardService.getCards(widget.set.id);
    final progressStream = FirebaseFirestore.instance
        .collection('users')
        .doc(_flashcardService.userId)
        .collection('progress')
        .snapshots();

    return cardsStream.asyncMap((cardList) async {
      final progressSnap = await progressStream.first;

      final progressMap = {
        for (var doc in progressSnap.docs)
          doc.id: {
            'isCompleted': doc['isCompleted'] ?? false,
            'isMarked': doc['isMarked'] ?? false,
          }
      };

      return {
        'cards': cardList,
        'progress': progressMap,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.set.title),
        backgroundColor: Colors.blue.shade700,
      ),

      body: StreamBuilder<Map<String, dynamic>>(
        stream: _combinedStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final cards = snapshot.data!['cards'] as List<FlashcardCard>;
          final progress = snapshot.data!['progress'] as Map<String, dynamic>;

          if (cards.isEmpty) {
            return const Center(child: Text('Bộ đề chưa có thẻ nào.'));
          }

          final totalCards = cards.length;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Thẻ ${_currentIndex + 1} / $totalCards',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),

              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: totalCards,
                  onPageChanged: (index) {
                    setState(() => _currentIndex = index);
                  },
                  itemBuilder: (_, index) {
                    final card = cards[index];
                    final state = progress[card.id] ?? {};

                    return CardWidget(
                      key: ValueKey(card.id),
                      card: card,
                      isMarked: state['isMarked'] ?? false,
                      isCompleted: state['isCompleted'] ?? false,
                      onToggleMarked: (v) => _updateProgress(card.id, isMarked: v),
                      onToggleCompleted: (v) => _updateProgress(card.id, isCompleted: v),
                    );
                  },
                ),
              ),

              _buildControlBar(totalCards),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  Widget _buildControlBar(int totalCards) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: _currentIndex > 0
                ? () => _pageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            )
                : null,
            child: const Text('Thẻ trước'),
          ),
          ElevatedButton(
            onPressed: _currentIndex < totalCards - 1
                ? () => _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            )
                : null,
            child: const Text('Thẻ tiếp'),
          ),
        ],
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final FlashcardCard card;
  final bool isMarked;
  final bool isCompleted;
  final ValueChanged<bool> onToggleMarked;
  final ValueChanged<bool> onToggleCompleted;

  const CardWidget({
    super.key,
    required this.card,
    required this.isMarked,
    required this.isCompleted,
    required this.onToggleMarked,
    required this.onToggleCompleted,
  });

  Widget _content(String text, bool front) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      color: front ? Colors.white : Colors.blue.shade100,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: front ? Colors.black87 : Colors.blue.shade900,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FlipCard(
              key: ValueKey("flip_${card.id}"),
              direction: FlipDirection.HORIZONTAL,
              front: _content(card.question, true),
              back: _content(card.answer, false),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(bottom: 16, top: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  isMarked ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.orange,
                  size: 30,
                ),
                onPressed: () => onToggleMarked(!isMarked),
              ),
              const SizedBox(width: 40),
              IconButton(
                icon: Icon(
                  isCompleted ? Icons.check_circle : Icons.circle_outlined,
                  color: isCompleted ? Colors.green : Colors.grey,
                  size: 30,
                ),
                onPressed: () => onToggleCompleted(!isCompleted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
