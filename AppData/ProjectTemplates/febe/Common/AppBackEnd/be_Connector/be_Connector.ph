#requires @"..\Common\AppBackEnd\be_Connector\be_Connector.pack"
% publicly used packages
#include @"..\Common\AppBackEnd\be_Core\be_Dictionary\be_Dictionary.ph"
#include @"..\Common\AppBackEnd\be_Core\be_Tests\be_Tests.ph"
#include @"Packs\Logic\edf\edf.ph"
#include @"pfc\multiThread\monitorQueue\monitorQueue.ph"
#include @"Packs\Logic\Web\tsMapM_redBlack\tsMapM_redBlack.ph"
#include @"pfc\multiThread\multiThread.ph"
#include @"..\Common\AppBackEnd\be_Options\be_Options.ph"
#include @"..\Common\AppBackEnd\backEnd\backEnd.ph"
#include @"..\Common\AppBackEnd\be_Core\fe_Requests\fe_Requests.ph"
#include @"..\Common\AppBackEnd\be_Core\be_CoreTasks\be_CoreTasks.ph"
#include @"..\Common\AppBackEnd\be_Tasks\be_Tasks.i"
#include @"pfc\core.ph"

% exported interfaces
#include @"..\Common\AppBackEnd\be_Connector\be_Connector.i"

% exported classes
#include @"..\Common\AppBackEnd\be_Connector\be_Connector.cl"
