import 'package:flutter/material.dart';
import 'package:gitjournal/core/note.dart';
import 'package:share/share.dart';

typedef NoteCallback = void Function(Note);

abstract class Editor {
  NoteCallback get noteDeletionSelected;
  NoteCallback get noteEditorChooserSelected;
  NoteCallback get exitEditorSelected;
  NoteCallback get renameNoteSelected;
  NoteCallback get moveNoteToFolderSelected;
  NoteCallback get discardChangesSelected;
}

abstract class EditorState {
  Note getNote();
}

enum DropDownChoices { Rename, MoveToFolder, DiscardChanges, Share }

AppBar buildEditorAppBar(
  Editor editor,
  EditorState editorState, {
  @required bool noteModified,
  List<IconButton> extraButtons,
}) {
  return AppBar(
    leading: IconButton(
      key: const ValueKey("NewEntry"),
      icon: Icon(noteModified ? Icons.check : Icons.close),
      onPressed: () {
        editor.exitEditorSelected(editorState.getNote());
      },
    ),
    actions: <Widget>[
      ...?extraButtons,
      IconButton(
        key: const ValueKey("EditorSelector"),
        icon: const Icon(Icons.library_books),
        onPressed: () {
          var note = editorState.getNote();
          editor.noteEditorChooserSelected(note);
        },
      ),
      IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          var note = editorState.getNote();
          editor.noteDeletionSelected(note);
        },
      ),
      PopupMenuButton<DropDownChoices>(
        onSelected: (DropDownChoices choice) {
          switch (choice) {
            case DropDownChoices.Rename:
              var note = editorState.getNote();
              editor.renameNoteSelected(note);
              return;

            case DropDownChoices.MoveToFolder:
              var note = editorState.getNote();
              editor.moveNoteToFolderSelected(note);
              return;

            case DropDownChoices.DiscardChanges:
              var note = editorState.getNote();
              editor.discardChangesSelected(note);
              return;

            case DropDownChoices.Share:
              var note = editorState.getNote();
              Share.share(note.body);
              return;
          }
        },
        itemBuilder: (BuildContext context) =>
            <PopupMenuEntry<DropDownChoices>>[
          const PopupMenuItem<DropDownChoices>(
            value: DropDownChoices.Rename,
            child: Text('Edit File Name'),
          ),
          const PopupMenuItem<DropDownChoices>(
            value: DropDownChoices.MoveToFolder,
            child: Text('Move to Folder'),
          ),
          const PopupMenuItem<DropDownChoices>(
            value: DropDownChoices.DiscardChanges,
            child: Text('Discard Changes'),
          ),
          const PopupMenuItem<DropDownChoices>(
            value: DropDownChoices.Share,
            child: Text('Share Note'),
          ),
        ],
      ),
    ],
  );
}
