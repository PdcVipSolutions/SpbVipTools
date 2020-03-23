#requires @"..\Common\AppFrontEnd\fe_Ribbons\fe_RibbonScriptLoadable\fe_RibbonScriptLoadable.pack"

% publicly used packages
#include @"..\Common\AppFrontEnd\frontEnd\frontEnd.ph"
#include @"pfc\gui\controls\ribbonControl\ribbonControl.ph"
#include @"pfc\gui\gui.ph"
#include @"pfc\gui\commands\command\Command.ph"
#include @"pfc\core.ph"
#include @"..\Common\AppFrontEnd\fe_Core\fe_Command\fe_Ribbon.i"

% exported interfaces
#include @"..\Common\AppFrontEnd\fe_Ribbons\fe_RibbonScriptLoadable\fe_RibbonScriptLoadable.i"
#include @"Interfaces\Logic\PzlRun.i"
% exported classes
#include @"..\Common\AppFrontEnd\fe_Ribbons\fe_RibbonScriptLoadable\fe_RibbonScriptLoadable.cl"
