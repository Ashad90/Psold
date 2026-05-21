import 'package:flutter/material.dart';
import 'package:psold/shared/widgets/_role_card.dart';
import 'package:psold/core/theme.dart';
import 'package:go_router/go_router.dart';

class RegisterChoiceScreen extends StatelessWidget {
  const RegisterChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PsoldColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.only(start: PsoldSpacing.md, end: PsoldSpacing.md, top: PsoldSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: PsoldSpacing.xl),
              Text(
                'Créer un compte',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: PsoldSpacing.sm),
              Text(
                'Choisissez votre profil',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: PsoldSpacing.xxl),
              RoleCard(
                icon: Icons.storefront_rounded,
                title: 'Compte Marchand',
                subtitle: 'Je vends des produits\nen solde ou proches de la date de péremption',
                features: const [
                  'Upload de photos & vidéos produits',
                  'Validation IA automatique',
                  'Dashboard de statistiques',
                  'Visibilité auprès des acheteurs',
                ],
                color: PsoldColors.primary,
                onTap: () => context.go('/register/merchant'),
              ),
              const SizedBox(height: PsoldSpacing.md),
              RoleCard(
                icon: Icons.shopping_bag_rounded,
                title: 'Compte Client',
                subtitle: 'Je cherche des bonnes affaires\nsur des produits en solde',
                features: const [
                  'Parcourir les produits proches de moi',
                  'Liker et commenter les publications',
                  'Contacter le vendeur via WhatsApp',
                  'Notifications de nouvelles offres',
                ],
                color: PsoldColors.textPrimary,
                onTap: () => context.go('/register/client'),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Déjà un compte ? ", style: Theme.of(context).textTheme.bodyMedium),
                  GestureDetector(
                    onTap: () => context.go('/login'),
                    child: Text(
                      'Se connecter',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: PsoldColors.primary, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: PsoldSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}