import 'package:flutter/material.dart';
import 'package:notes/data/models.dart';
import 'package:notes/screens/edit.dart';
import 'package:notes/screens/settings.dart';
import 'package:notes/services/database.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:share/share.dart';

class HomePage extends StatefulWidget {
  final Function(Brightness) changeTheme;
  
  const HomePage({
    Key? key,
    required this.changeTheme,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isFlagOn = false;
  List<NotesModel> notesList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getNotes();
  }

  Future<void> getNotes() async {
    setState(() => isLoading = true);
    notesList = await NotesDatabaseService.db.getNotesFromDB();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            icon: Icon(isFlagOn ? Icons.flag : OMIcons.flag),
            onPressed: () => setState(() => isFlagOn = !isFlagOn),
          ),
          IconButton(
            icon: const Icon(OMIcons.settings),
            onPressed: () => _openSettings(context),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : buildNotesList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditPage(context),
        label: const Text('Add note'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget buildNotesList() {
    if (notesList.isEmpty) {
      return const Center(child: Text('No notes yet'));
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: notesList.length,
      itemBuilder: (context, index) {
        final note = notesList[index];
        if (isFlagOn && !note.isImportant) return const SizedBox.shrink();
        
        return buildNoteCard(context, note);
      },
    );
  }

  Widget buildNoteCard(BuildContext context, NotesModel note) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        onTap: () => _openEditPage(context, existingNote: note),
        title: Text(
          note.title.trim().isEmpty ? 'Untitled' : note.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: note.content.trim().isEmpty
            ? null
            : Text(
                note.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
        trailing: IconButton(
          icon: const Icon(Icons.share),
          onPressed: () => Share.share('${note.title}\n\n${note.content}'),
        ),
      ),
    );
  }

  void _openEditPage(BuildContext context, {NotesModel? existingNote}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditNotePage(
          triggerRefetch: getNotes,
          existingNote: existingNote,
        ),
      ),
    );
  }

  void _openSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsPage(
          changeTheme: widget.changeTheme,
        ),
      ),
    );
  }
}
