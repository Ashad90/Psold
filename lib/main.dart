import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:psold/flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:psold/core/locale_provider.dart';
import 'package:psold/core/router.dart';
import 'package:psold/core/supabase_client.dart';
import 'package:psold/core/theme.dart';
import 'package:psold/shared/utils/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('settings');

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final supabase = PsoldSupabaseClient();
  await supabase.initialize();

  runApp(const ProviderScope(child: PsoldApp()));
}

class PsoldApp extends ConsumerStatefulWidget {
  const PsoldApp({super.key});

  @override
  ConsumerState<PsoldApp> createState() => _PsoldAppState();
}

class _PsoldAppState extends ConsumerState<PsoldApp> {
  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      final notificationService = ref.read(notificationServiceProvider);
      await notificationService.initialize();
      
      final token = await notificationService.getToken();
      if (token != null) {
        await notificationService.saveTokenToDatabase(token);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'Psold',
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: psoldLightTheme,
      darkTheme: psoldDarkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
