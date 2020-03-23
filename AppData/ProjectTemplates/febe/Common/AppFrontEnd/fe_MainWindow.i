% Copyright (c) Prolog Development Center SPb

interface fe_MainWindow
	open core

properties
    progress_P : core::predicate{integer,string}.
    ribbonControl_P : ribboncontrol (o).
    fe_Command_P : fe_Command.

predicates
    initContent:(frontEnd FrontEnd).

predicates
    progressBar_activate : (positive Count).
    progressBar_remove : ().
    progressBar_progress : (positive Progress).

predicates
    setStatusBar:().
    showBackEndStatus:(boolean).
    setTitle : ().

end interface fe_MainWindow
