%

interface appHead
    open core

properties
    mainWindow_P : fe_Form.
    frontEnd_P:frontEnd.

predicates
    createMainWindow:(frontEnd)->fe_MainWindow.

predicates
    run:(window).

end interface appHead