#requires @"..\Common\AppFrontEnd\fe_Core\fe_Tests\fe_Tests.pack"

% publicly used packages
#include @"pfc\core.ph"
#include @"Packs\Logic\promiseExt\promiseExt.ph"
#include @"pfc\asynchronous\future\future.ph"
#include @"Packs\Logic\edf\edf.ph"
#include @"pfc\gui\commands\checkCommand\checkCommand.ph"
#include @"..\Common\appfrontend\frontend\frontend.ph"

% exported interfaces
#include @"..\Common\AppFrontEnd\fe_Core\fe_Tests\fe_Tests.i"
#include @"Interfaces\Logic\coreDictionary.i"
#include @"..\Common\AppFrontEnd\fe_Core\fe_HandleResponse_async.i"

% exported classes
#include @"..\Common\AppFrontEnd\fe_Core\fe_Tests\fe_Tests.cl"
