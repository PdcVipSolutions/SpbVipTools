#requires @"..\Common\AppFrontEnd\fe_Tasks\fe_Tasks.pack"

% publicly used packages
#include @"pfc\core.ph"
#include @"Packs\Logic\promiseExt\promiseExt.ph"
#include @"pfc\asynchronous\future\future.ph"
#include @"Packs\Logic\edf\edf.ph"
#include @"pfc\gui\commands\checkCommand\checkCommand.ph"
#include @"..\Common\appfrontend\frontend\frontend.ph"

% exported interfaces
#include @"..\Common\AppFrontEnd\fe_Tasks\fe_Tasks.i"
#include @"Interfaces\Logic\coreDictionary.i"
#include @"..\Common\dataExchangeIdentifiers.i"
#include @"..\Common\AppFrontEnd\fe_Core\fe_HandleResponse_async.i"

% exported classes
#include @"..\Common\AppFrontEnd\fe_Tasks\fe_Tasks.cl"
