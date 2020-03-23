interface appHead
    open core

properties
    mainWindow_P : fe_Form.
    backEndServiceIP_P:string.
    backEndServicePath_P:string.
    frontEnd_P:frontEnd.

predicates
    createMainWindow:(frontEnd)->fe_MainWindow.

predicates
    run:(window ParentWindow).

end interface appHead