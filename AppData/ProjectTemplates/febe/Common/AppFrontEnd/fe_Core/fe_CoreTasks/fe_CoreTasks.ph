#requires @"..\Common\AppFrontEnd\fe_Core\fe_CoreTasks\fe_CoreTasks.pack"
% publicly used packages
#include @"pfc\gui\controls\ribboncontrol\ribboncontrol.ph"
#include @"Packs\Gui\ribbonLoader\cmdPerformers\cmdPerformers.ph"
#include @"..\Common\AppFrontEnd\fe_Core\be_Responses\be_Responses.ph"
#include @"Packs\Logic\promiseExt\promiseExt.ph"
#include @"pfc\asynchronous\future\future.ph"
#include @"Packs\Logic\edf\edf.ph"
#include @"pfc\gui\commands\checkCommand\checkCommand.ph"
#include @"pfc\gui\controls\TreeControl\treeModel_std\treeModel_std.ph"
#include @"pfc\core.ph"

% exported interfaces
#include @"..\Common\AppFrontEnd\fe_Core\fe_CoreTasks\fe_CoreTasks.i"
#include @"Interfaces\Logic\coreDictionary.i"
#include @"Packs\Logic\appFrameSupport\coreIdentifiers.i"
#include @"..\Common\AppFrontEnd\fe_Core\fe_HandleResponse_async.i"

% exported classes
#include @"..\Common\AppFrontEnd\fe_Core\fe_CoreTasks\fe_CoreTasks.cl"
