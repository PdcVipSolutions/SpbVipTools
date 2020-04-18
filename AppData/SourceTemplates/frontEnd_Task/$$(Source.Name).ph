#requires @"$$(Source.Path)$$(Source.Name).pack"

% publicly used packages
#include @"pfc\core.ph"
#include @"Packs\Logic\promiseExt\promiseExt.ph"
#include @"pfc\asynchronous\future\future.ph"
#include @"Packs\Logic\edf\edf.ph"
#include @"pfc\gui\commands\checkCommand\checkCommand.ph"
#include @"..\common\appfrontend\frontend\frontend.ph"

% exported interfaces
#include @"$$(Source.Path)$$(Source.Name).i"
#include @"Interfaces\Logic\coreDictionary.i"

% exported classes
#include @"$$(Source.Path)$$(Source.Name).cl"
