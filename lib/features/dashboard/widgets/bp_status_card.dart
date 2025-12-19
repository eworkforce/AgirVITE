import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/colors.dart';
import '../../../core/models/bp_reading.dart';
import '../providers/dashboard_provider.dart';

class BPStatusCard extends ConsumerWidget {
  const BPStatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(recentBPHistoryProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: historyAsync.when(
        data: (history) {
          if (history.isEmpty) return _buildEmptyState(context);
          
          final latest = history.last;
          final previous = history.length > 1 ? history[history.length - 2] : null;
          final statusColor = _getStatusColor(latest.systolic, latest.diastolic);
          final statusText = _getStatusText(latest.systolic, latest.diastolic);
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Compact
            children: [
              // Top Row: Title & Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tension Artérielle',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  _buildStatusBadge(statusText, statusColor),
                ],
              ),
              const SizedBox(height: 8),

              // Value & Trend Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${latest.systolic}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '/${latest.diastolic}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      'mmHg',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (previous != null)
                     _buildTrendIndicator(latest.systolic, previous.systolic),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Chart (Compact)
              SizedBox(
                height: 60,
                child: _buildChart(history, statusColor),
              ),
              
              const SizedBox(height: 12),
              
              // Footer (Recommendation)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: statusColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _getRecommendation(latest.systolic, latest.diastolic),
                        style: TextStyle(
                          color: statusColor.withValues(alpha: 1.0),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => const Text('Erreur de chargement'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(Icons.monitor_heart_outlined, size: 32, color: AppColors.textSecondary.withValues(alpha: 0.5)),
            const SizedBox(height: 8),
            Text(
              "Aucune mesure récente",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            TextButton(
              onPressed: () {}, 
              style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
              child: const Text("Prendre une mesure"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildTrendIndicator(int current, int previous) {
    final diff = current - previous;
    IconData icon;
    Color color;

    if (diff > 5) {
      icon = Icons.trending_up;
      color = AppColors.emergency; // Rising is generally bad or needs attention
    } else if (diff < -5) {
      icon = Icons.trending_down;
      color = AppColors.success; // Falling is generally good
    } else {
      icon = Icons.trending_flat;
      color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 16, color: color),
    );
  }

  Widget _buildChart(List<BPReading> history, Color color) {
    // Determine min/max Y for dynamic scaling
    double minY = 40;
    double maxY = 180;
    
    if (history.isNotEmpty) {
      final allValues = history.expand((e) => [e.systolic, e.diastolic]).toList();
      minY = (allValues.reduce((a, b) => a < b ? a : b) - 10).toDouble();
      maxY = (allValues.reduce((a, b) => a > b ? a : b) + 10).toDouble();
    }

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (history.length - 1).toDouble(),
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          // Systolic Line
          LineChartBarData(
            spots: history.asMap().entries.map((e) {
              return FlSpot(e.key.toDouble(), e.value.systolic.toDouble());
            }).toList(),
            isCurved: true,
            color: color,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: color.withValues(alpha: 0.1),
            ),
          ),
          // Diastolic Line
          LineChartBarData(
            spots: history.asMap().entries.map((e) {
              return FlSpot(e.key.toDouble(), e.value.diastolic.toDouble());
            }).toList(),
            isCurved: true,
            color: color.withValues(alpha: 0.5),
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(int sys, int dia) {
    if (sys >= 160 || dia >= 100) return AppColors.emergency; // Red
    if (sys >= 140 || dia >= 90) return Colors.orange; // Orange
    return AppColors.success; // Green
  }

  String _getStatusText(int sys, int dia) {
    if (sys >= 180 || dia >= 110) return 'CRISE HYPERTENSIVE';
    if (sys >= 160 || dia >= 100) return 'Hypertension Stade 2';
    if (sys >= 140 || dia >= 90) return 'Hypertension Stade 1';
    if (sys >= 130 || dia >= 85) return 'Normale Haute';
    if (sys >= 120 || dia >= 80) return 'Normale';
    return 'Optimale';
  }

  String _getRecommendation(int sys, int dia) {
    if (sys >= 180 || dia >= 110) return 'Urgence médicale ! Appelez le 185 immédiatement.';
    if (sys >= 160 || dia >= 100) return 'Consultez un médecin rapidement.';
    if (sys >= 140 || dia >= 90) return 'Surveillez votre tension et consultez.';
    return 'Continuez vos bonnes habitudes. Consultez un médecin pour un suivi régulier.';
  }
}
