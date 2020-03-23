/*****************************************************************************
Copyright (c) Victor Yukhtenko

******************************************************************************/

implement projectToolbar
    open core, vpiDomains, vpiToolbar, resourceIdentifiers

clauses
    create(Parent):-
        _ = vpiToolbar::create(style, Parent, controlList).

% This code is maintained automatically, do not update it manually. 17:06:42-13.2.2008
constants
    style : vpiToolbar::style = tb_top().
    controlList : vpiToolbar::control_list =
        [
        tb_ctrl(id_file_new,pushb(),resId(idb_NewFileBitmap),"New;New File",1,1),
        tb_ctrl(id_file_open,pushb(),resId(idb_OpenFileBitmap),"Open;Open File",1,1),
        tb_ctrl(id_file_save,pushb(),resId(idb_SaveFileBitmap),"Save;Save File",1,1),
        vpiToolbar::separator,
        tb_ctrl(id_edit_undo,pushb(),resId(idb_UndoBitmap),"Undo;Undo",1,1),
        tb_ctrl(id_edit_redo,pushb(),resId(idb_RedoBitmap),"Redo;Redo",1,1),
        vpiToolbar::separator,
        tb_ctrl(id_edit_cut,pushb(),resId(idb_CutBitmap),"Cut;Cut to Clipboard",1,1),
        tb_ctrl(id_edit_copy,pushb(),resId(idb_CopyBitmap),"Copy;Copy to Clipboard",1,1),
        tb_ctrl(id_edit_paste,pushb(),resId(idb_PasteBitmap),"Paste;Paste from Clipboard",1,1),
        vpiToolbar::separator,
        tb_ctrl(id_help_contents,pushb(),resId(idb_HelpBitmap),"Help;Help",1,1)
        ].
% end of automatic code
end implement projectToolbar
