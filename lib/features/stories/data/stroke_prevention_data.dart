import 'package:flutter/material.dart';
import '../../../app/theme/colors.dart';

class PreventionFlipCardData {
  final String id;
  final String stepLabel;
  final bool isDangerDeck;
  final String title;
  final String rectoHook;
  final String rectoBadge;
  final String imageAsset;
  final IconData icon;
  final Color accentColor;
  final String versoWhyTitle;
  final String versoWhyBody;
  final String versoActionTitle;
  final String versoActionBody;

  const PreventionFlipCardData({
    required this.id,
    required this.stepLabel,
    required this.isDangerDeck,
    required this.title,
    required this.rectoHook,
    required this.rectoBadge,
    required this.imageAsset,
    required this.icon,
    required this.accentColor,
    required this.versoWhyTitle,
    required this.versoWhyBody,
    required this.versoActionTitle,
    required this.versoActionBody,
  });
}

class StrokePreventionData {
  static const List<PreventionFlipCardData> dangerCards = [
    PreventionFlipCardData(
      id: 'danger_hta',
      stepLabel: 'DANGER 1 / 6',
      isDangerDeck: true,
      title: 'La Tension Élevée (HTA)',
      rectoHook: 'L’ennemi silencieux n°1 en Côte d’Ivoire',
      rectoBadge: 'Impliquée dans près de 8 AVC sur 10',
      imageAsset: 'assets/images/PriseTension1.jpeg',
      icon: Icons.monitor_heart_rounded,
      accentColor: AppColors.emergency,
      versoWhyTitle: 'Pourquoi c’est dangereux ?',
      versoWhyBody:
          'Même sans aucun mal de tête, une tension trop forte (≥ 14/9) abîme les petits vaisseaux du cerveau jusqu’à les boucher ou les rompre.',
      versoActionTitle: 'Le bon réflexe',
      versoActionBody:
          'Faites vérifier votre tension régulièrement en pharmacie ou au centre de santé, même quand vous vous sentez bien.',
    ),
    PreventionFlipCardData(
      id: 'danger_inactivite',
      stepLabel: 'DANGER 2 / 6',
      isDangerDeck: true,
      title: 'Le Manque de Mouvement',
      rectoHook: 'Rester assis trop longtemps chaque jour',
      rectoBadge: 'Moins de 30 min de marche par jour',
      imageAsset: 'assets/images/Blog1.jpeg',
      icon: Icons.directions_walk_rounded,
      accentColor: AppColors.emergency,
      versoWhyTitle: 'Pourquoi c’est dangereux ?',
      versoWhyBody:
          'Quand le corps bouge peu, les artères s’encrassent plus vite et la tension ainsi que le poids augmentent silencieusement.',
      versoActionTitle: 'Le bon réflexe',
      versoActionBody:
          'Marchez d’un bon pas, dansez ou faites du sport au moins 30 minutes par jour, 5 fois par semaine.',
    ),
    PreventionFlipCardData(
      id: 'danger_assiette',
      stepLabel: 'DANGER 3 / 6',
      isDangerDeck: true,
      title: 'Trop de Sel, Sucre & Gras',
      rectoHook: 'Attention au contenu de l’assiette',
      rectoBadge: 'Cubes, fritures et boissons sucrées',
      imageAsset: 'assets/images/ci_salt_fried_food.png',
      icon: Icons.restaurant_menu_rounded,
      accentColor: AppColors.emergency,
      versoWhyTitle: 'Pourquoi c’est dangereux ?',
      versoWhyBody:
          'L’excès de sel et de bouillons cubes fait grimper la tension, tandis que les fritures déposent de la graisse dans les artères du cerveau.',
      versoActionTitle: 'Le bon réflexe',
      versoActionBody:
          'Réduisez le sel et l’huile de friture, et privilégiez les fruits, les légumes frais et le poisson.',
    ),
    PreventionFlipCardData(
      id: 'danger_poids',
      stepLabel: 'DANGER 4 / 6',
      isDangerDeck: true,
      title: 'Le Surpoids & le Ventre',
      rectoHook: 'La graisse autour du ventre fatigue le cœur',
      rectoBadge: 'Tour de taille > 88 cm (F) • > 102 cm (H)',
      imageAsset: 'assets/images/ci_waist_measure.png',
      icon: Icons.straighten_rounded,
      accentColor: AppColors.emergency,
      versoWhyTitle: 'Pourquoi c’est dangereux ?',
      versoWhyBody:
          'Un poids trop élevé ou un tour de taille important favorise directement la tension, le diabète et l’obstruction des vaisseaux.',
      versoActionTitle: 'Le bon réflexe',
      versoActionBody:
          'Surveillez votre tour de taille avec un simple mètre ruban et alliez repas légers et marche quotidienne.',
    ),
    PreventionFlipCardData(
      id: 'danger_tabac_alcool',
      stepLabel: 'DANGER 5 / 6',
      isDangerDeck: true,
      title: 'Le Tabac & l’Alcool',
      rectoHook: 'Deux poisons directs pour vos artères',
      rectoBadge: '1 bière = 1 verre de vin = 1 whisky',
      imageAsset: 'assets/images/ci_no_tobacco_alcohol.png',
      icon: Icons.smoke_free_rounded,
      accentColor: AppColors.emergency,
      versoWhyTitle: 'Pourquoi c’est dangereux ?',
      versoWhyBody:
          'Le tabac (même la fumée des autres) double le risque d’AVC. L’alcool en excès fait éclater les petits vaisseaux du cerveau.',
      versoActionTitle: 'Le bon réflexe',
      versoActionBody:
          'Arrêtez complètement le tabac, évitez les lieux enfumés et limitez fortement les boissons alcoolisées.',
    ),
    PreventionFlipCardData(
      id: 'danger_diabete_stress',
      stepLabel: 'DANGER 6 / 6',
      isDangerDeck: true,
      title: 'Sucre, Cœur & Stress',
      rectoHook: 'Des signaux qu’il ne faut jamais négliger',
      rectoBadge: 'Diabète, palpitations ou stress permanent',
      imageAsset: 'assets/images/GuideVite2.jpeg',
      icon: Icons.favorite_rounded,
      accentColor: AppColors.emergency,
      versoWhyTitle: 'Pourquoi c’est dangereux ?',
      versoWhyBody:
          'L’excès de sucre dans le sang et le stress usent les vaisseaux, et un cœur qui bat de façon irrégulière peut envoyer un caillot au cerveau.',
      versoActionTitle: 'Le bon réflexe',
      versoActionBody:
          'Faites contrôler votre taux de sucre une fois par an, consultez si votre cœur s’emballe et accordez-vous du repos.',
    ),
  ];

  static const List<PreventionFlipCardData> reflexCards = [
    PreventionFlipCardData(
      id: 'reflex_tension',
      stepLabel: 'RÉFLEXE 1 / 6',
      isDangerDeck: false,
      title: 'Connaître mes Chiffres',
      rectoHook: 'Un contrôle simple peut vous sauver la vie',
      rectoBadge: 'Objectif Tension : moins de 14 / 9',
      imageAsset: 'assets/images/PriseTension2.jpeg',
      icon: Icons.health_and_safety_rounded,
      accentColor: AppColors.primary,
      versoWhyTitle: 'Pourquoi c’est essentiel ?',
      versoWhyBody:
          'La tension et le diabète n’entraînent souvent aucune douleur au début : seul un contrôle permet de les détecter à temps.',
      versoActionTitle: 'Mon engagement',
      versoActionBody:
          'Je fais mesurer ma tension artérielle et mon taux de sucre régulièrement, même si je me sens en pleine forme.',
    ),
    PreventionFlipCardData(
      id: 'reflex_bouger',
      stepLabel: 'RÉFLEXE 2 / 6',
      isDangerDeck: false,
      title: 'Bouger 30 min par Jour',
      rectoHook: 'Chaque pas nettoie et protège vos artères',
      rectoBadge: '30 minutes • 5 jours par semaine',
      imageAsset: 'assets/images/ci_active_walk.png',
      icon: Icons.directions_run_rounded,
      accentColor: AppColors.success,
      versoWhyTitle: 'Pourquoi c’est essentiel ?',
      versoWhyBody:
          'L’activité physique régulière fait baisser naturellement la tension, le sucre, le mauvais cholestérol et le stress.',
      versoActionTitle: 'Mon engagement',
      versoActionBody:
          'Je privilégie la marche rapide, les escaliers, le vélo ou la danse au moins 30 minutes par jour.',
    ),
    PreventionFlipCardData(
      id: 'reflex_manger',
      stepLabel: 'RÉFLEXE 3 / 6',
      isDangerDeck: false,
      title: 'Manger Léger & Naturel',
      rectoHook: 'Moins de sel et de fritures, plus de couleurs',
      rectoBadge: 'Fruits • Légumes frais • Poisson',
      imageAsset: 'assets/images/ci_healthy_food.png',
      icon: Icons.eco_rounded,
      accentColor: AppColors.success,
      versoWhyTitle: 'Pourquoi c’est essentiel ?',
      versoWhyBody:
          'Les fruits, les légumes et le poisson apportent des nutriments qui gardent les vaisseaux du cerveau souples et propres.',
      versoActionTitle: 'Mon engagement',
      versoActionBody:
          'Je réduis le sel et les cubes en cuisine, je ne resale jamais mon plat à table et je limite les boissons sucrées.',
    ),
    PreventionFlipCardData(
      id: 'reflex_traitement',
      stepLabel: 'RÉFLEXE 4 / 6',
      isDangerDeck: false,
      title: 'Suivre mon Traitement',
      rectoHook: 'Ne jamais arrêter ses comprimés tout seul',
      rectoBadge: '100 % d’observance tous les jours',
      imageAsset: 'assets/images/Centre2.jpeg',
      icon: Icons.medication_liquid_rounded,
      accentColor: AppColors.primary,
      versoWhyTitle: 'Pourquoi c’est essentiel ?',
      versoWhyBody:
          'Si votre tension est redevenue normale grâce aux médicaments, l’arrêt brutal du traitement fait remonter la tension en flèche.',
      versoActionTitle: 'Mon engagement',
      versoActionBody:
          'Je prends mes médicaments pour la tension, le diabète ou le cœur chaque jour sans interruption.',
    ),
    PreventionFlipCardData(
      id: 'reflex_age_famille',
      stepLabel: 'RÉFLEXE 5 / 6',
      isDangerDeck: false,
      title: 'Vigilance dès 45–50 ans',
      rectoHook: 'L’AVC touche aussi les adultes jeunes et actifs',
      rectoBadge: 'Âge moyen en Côte d’Ivoire : 58 ans',
      imageAsset: 'assets/images/GuideVite3.jpeg',
      icon: Icons.family_restroom_rounded,
      accentColor: AppColors.primary,
      versoWhyTitle: 'Pourquoi c’est essentiel ?',
      versoWhyBody:
          '1 AVC sur 4 survient avant 65 ans, et le risque est plus élevé si un parent proche a déjà eu un AVC ou un problème cardiaque.',
      versoActionTitle: 'Mon engagement',
      versoActionBody:
          'Je n’attends pas la vieillesse pour protéger mes artères et j’encourage mes proches à vérifier leur tension.',
    ),
    PreventionFlipCardData(
      id: 'reflex_vite_sos',
      stepLabel: 'RÉFLEXE 6 / 6',
      isDangerDeck: false,
      title: '1 Signe V.I.T.E. = SOS',
      rectoHook: 'Vous avez 4h30 maximum pour agir',
      rectoBadge: 'Visage • Incapacité • Trouble de la parole',
      imageAsset: 'assets/images/urgence_samu_ci.jpg',
      icon: Icons.bolt_rounded,
      accentColor: AppColors.emergency,
      versoWhyTitle: 'Pourquoi c’est essentiel ?',
      versoWhyBody:
          'Dès le premier signe (bouche déviée, bras sans force ou parole bizarre), chaque minute compte pour déboucher l’artère à l’hôpital.',
      versoActionTitle: 'Mon engagement',
      versoActionBody:
          'Je n’attends jamais que ça passe : j’appuie immédiatement sur le bouton SOS pour appeler le centre AVC.',
    ),
  ];
}
