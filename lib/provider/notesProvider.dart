import 'package:flutter/cupertino.dart';
import 'package:notesapp/models/note.dart';
import 'package:notesapp/services/apiService.dart';

class NotesProvider with ChangeNotifier {
  bool isLoading = true;
  List<Note> notes = [];

  NotesProvider() {
    fetchNotes();
  }

  void sortNotes() {
    notes.sort(
      (a, b) => b.dateadded!.compareTo(a.dateadded!),
    );
  }

  void addNote(Note note) {
    notes.add(note);
    sortNotes();
    notifyListeners();
    apiService.addNote(note);
  }

  void updateNote(Note note) {
    int indexOfNote =
        notes.indexOf(notes.firstWhere((element) => element.id == note.id));
    notes[indexOfNote] = note;
    sortNotes();
    notifyListeners();
    apiService.addNote(note);
  }

  void deleteNote(Note note) {
    int indexOfNote =
        notes.indexOf(notes.firstWhere((element) => element.id == note.id));
    notes.removeAt(indexOfNote);
    notifyListeners();
    apiService.deleteNote(note);
  }

  void fetchNotes() async {
    notes = await apiService.fetchNotes("khamkaratharv2002@gmail.com");
    sortNotes();
    isLoading = false;
    notifyListeners();
  }

  List<Note> getFilteredNotes(String searchQuery) {
    return notes
        .where(
          (element) =>
              element.title!
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) ||
              element.content!
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()),
        )
        .toList();
  }
}
