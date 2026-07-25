import '../data/models/medication_model.dart';

abstract class MedicationState {}

class MedicationInitial extends MedicationState {}

class MedicationLoading extends MedicationState {}

class MedicationLoaded extends MedicationState {
  final List<MedicationModel> medications;
  MedicationLoaded(this.medications);
}

class MedicationError extends MedicationState {
  final String message;
  MedicationError(this.message);
}