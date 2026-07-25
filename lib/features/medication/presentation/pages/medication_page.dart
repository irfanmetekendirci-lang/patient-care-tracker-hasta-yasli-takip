import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/medication_cubit.dart';
import '../../cubit/medication_state.dart';

class MedicationPage extends StatelessWidget {
  const MedicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MedicationCubit, MedicationState>(
        builder: (context, state) {

          // 1. Durum: Yükleniyor
          if (state is MedicationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Durum: Veriler Geldi (Loaded)
          else if (state is MedicationLoaded) {
            return ListView.builder(
              itemCount: state.medications.length,
              itemBuilder: (context, index) {
                final item = state.medications[index];
                return ListTile(
                  leading: const Icon(Icons.medication, color: Colors.deepPurple),
                  title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Saat: ${item.time}"),
                  trailing: IconButton(
                    icon: Icon(
                      item.isTaken ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: item.isTaken ? Colors.green : Colors.grey,
                    ),
                    onPressed: () {
                      context.read<MedicationCubit>().toggleMedicationStatus(item.id);
                    },
                  ),
                );
              },
            );
          }

          // 3. Durum: Hata
          else if (state is MedicationError) {
            return Center(child: Text(state.message));
          }

          // Başlangıç durumu veya hata sonrası manuel tetikleme butonu
          return Center(
            child: ElevatedButton(
              onPressed: () => context.read<MedicationCubit>().fetchMedications(),
              child: const Text("İlaçları Listele"),
            ),
          );
        },
      ),
    );
  }
}