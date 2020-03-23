%

interface appHead
    open core

properties
    mainWindow_P : taskWindow.
    frontEnd_P:frontEnd.

predicates
    createMainWindow:(frontEnd)->fe_MainWindow.

predicates
    run:().

end interface appHead