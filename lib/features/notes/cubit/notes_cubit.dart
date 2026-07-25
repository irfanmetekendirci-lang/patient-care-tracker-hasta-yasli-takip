import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/note_model.dart';

// --- NOTUN DURUMLARI (STATES) ---
abstract class NoteState {}

// Uygulama ilk açıldığında
class NoteInitial extends NoteState {}

// Notlar listelendiğinde (İçinde not listesini taşır)
class NoteLoaded extends NoteState {
  final List<NoteModel> notes;
  NoteLoaded(this.notes);
}

// --- NOTUN BEYNİ (CUBIT) ---
class NoteCubit extends Cubit<NoteState> {
  NoteCubit() : super(NoteInitial());

  // Notları tutacağımız geçici liste
  final List<NoteModel> _notesList = [];

  // YENİ NOT EKLEME
  void addNote(NoteModel newNote) {
    _notesList.add(newNote);
    // Ekranı "Yeni notlar geldi!" diye uyarıyoruz
    emit(NoteLoaded(List.from(_notesList)));
  }

  // NOT SİLME
  void deleteNote(String id) {
    _notesList.removeWhere((note) => note.id == id);
    emit(NoteLoaded(List.from(_notesList)));
  }
}