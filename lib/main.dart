import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Bloc paketini ekledik
import 'package:hasta_yasli_kontrol/features/notes/cubit/notes_cubit.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/life_check/cubit/life_check_cubit.dart';
import 'features/medication/cubit/medication_cubit.dart'; // Cubit'i ekledik

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // BlocProvider: Yazdığımız Cubit'i uygulamanın tepesine yerleştirir.
    // Böylece altındaki tüm sayfalar (HomePage vb.) bu Cubit'e ulaşabilir.
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MedicationCubit(),),
        BlocProvider(create: (context) => LifeCheckCubit()..startTimer(),),
        BlocProvider(create: (context) => NoteCubit(),),
      ],
      child: MaterialApp(
        title: 'Yaşlı Bakım',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}