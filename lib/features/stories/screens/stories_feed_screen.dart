import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/colors.dart';
import '../data/stroke_prevention_data.dart';
import '../widgets/prevention_flip_card.dart';

class StoriesFeedScreen extends StatefulWidget {
  const StoriesFeedScreen({super.key});

  @override
  State<StoriesFeedScreen> createState() => _StoriesFeedScreenState();
}

class _StoriesFeedScreenState extends State<StoriesFeedScreen> {
  late PageController _pageController;
  bool _showDangerDeck = true;
  int _currentIndex = 0;

  List<PreventionFlipCardData> get _activeCards => _showDangerDeck
      ? StrokePreventionData.dangerCards
      : StrokePreventionData.reflexCards;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.90);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _switchDeck(bool showDangers) {
    if (_showDangerDeck == showDangers) return;
    setState(() {
      _showDangerDeck = showDangers;
      _currentIndex = 0;
    });
    if (_pageController.hasClients) {
      _pageController.jumpToPage(0);
    }
  }

  void _goToCard(int index) {
    if (index < 0 || index >= _activeCards.length) return;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cards = _activeCards;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home, color: AppColors.primary),
          onPressed: () => context.go('/dashboard'),
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo_avc_espoir.png',
              height: 30,
              width: 30,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 10),
            const Flexible(
              child: Text(
                'Conseils & Prévention',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 66),
          child: Column(
            children: [
              _buildStylizedHeader(context),
              const SizedBox(height: 10),
              _buildDeckToggle(),
              const SizedBox(height: 8),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: cards.length,
                  onPageChanged: (idx) => setState(() => _currentIndex = idx),
                  itemBuilder: (context, index) {
                    return PreventionFlipCard(card: cards[index]);
                  },
                ),
              ),
              const SizedBox(height: 4),
              _buildCarouselControls(cards.length),
              const Text(
                'Sources : SIN (Société Ivoirienne de Neurologie)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10.5,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStylizedHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.emergency.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lightbulb_rounded,
                  size: 15,
                  color: AppColors.emergency,
                ),
                const SizedBox(width: 4),
                Text(
                  '9 AVC SUR 10 PEUVENT ÊTRE ÉVITÉS',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.emergency,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        fontSize: 10.5,
                      ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Facteurs de Risque',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                fontSize: 20,
                letterSpacing: -0.3,
              ),
        ),
      ],
    );
  }

  Widget _buildDeckToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              key: const Key('deck_toggle_dangers'),
              onTap: () => _switchDeck(true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: _showDangerDeck
                      ? AppColors.emergency
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Les 6 Dangers',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _showDangerDeck
                        ? Colors.white
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              key: const Key('deck_toggle_reflexes'),
              onTap: () => _switchDeck(false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: !_showDangerDeck
                      ? AppColors.success
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Les 6 Bons Réflexes',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: !_showDangerDeck
                        ? Colors.white
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselControls(int total) {
    final activeColor =
        _showDangerDeck ? AppColors.emergency : AppColors.success;

    return SizedBox(
      height: 36,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            key: const Key('prev_card_button'),
            padding: EdgeInsets.zero,
            onPressed:
                _currentIndex > 0 ? () => _goToCard(_currentIndex - 1) : null,
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
            color: AppColors.primary,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(total, (index) {
              final isSelected = index == _currentIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isSelected ? 22 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isSelected
                      ? activeColor
                      : AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
              );
            }),
          ),
          IconButton(
            key: const Key('next_card_button'),
            padding: EdgeInsets.zero,
            onPressed: _currentIndex < total - 1
                ? () => _goToCard(_currentIndex + 1)
                : null,
            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
