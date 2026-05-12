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
import 'package:sentry/sentry.dart' as sentry;

const String _sentryDsn = String.fromEnvironment('SENTRY_DSN', defaultValue: '');

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> _initializeSentry() async {
  if (_sentryDsn.isNotEmpty) {
    await sentry.Sentry.init(
      (options) {
        options.dsn = _sentryDsn;
        options.tracesSampleRate = 1.0;
        options.attachStacktrace = true;
        options.sendDefaultPii = false;
      },
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('settings');

  await _initializeSentry();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final supabase = PsoldSupabaseClient();
  await supabase.initialize();

  runApp(const ProviderScope(child: PsoldApp()));
}

class PsoldApp extends ConsumerStatefulWidget {///
  const PsoldApp({super.key});

  @override
  ConsumerState<PsoldApp> createState() => _PsoldAppState();
}

class _PsoldAppState extends ConsumerState<PsoldApp> {
  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _initializeBackgroundLocation();
  }

  Future<void> _initializeNotifications() async {
    try {
      final notificationService = ref.read(notificationServiceProvider);
      final hasDecided = await notificationService.hasUserDecidedNotifications();

      if (!hasDecided) {
        await notificationService.requestPermission();
      }

      if (mounted) {
        final token = await notificationService.getToken();
        if (token != null) {
          await notificationService.saveTokenToDatabase(token);
        }
      }
    } catch (e) {
      debugPrint('Notification init error: $e');
    }
  }

  void _initializeBackgroundLocation() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(merchantBackgroundLocationProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    ref.watch(merchantBackgroundLocationProvider);

    return MaterialApp.router(
      title: 'Psold',
      debugShowCheckedModeBanner: false,
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