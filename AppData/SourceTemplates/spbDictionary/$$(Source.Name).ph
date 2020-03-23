#requires @"$$(Source.Path)$$(Source.Name).pack"

% publicly used packages
#include @"pfc\core.ph"

% exported interfaces
#include @"$$(Source.Path)$$(Source.Name).i"
#include @"Interfaces\Logic\coreDictionary.i"

% exported classes
#include @"$$(Source.Path)$$(Source.Name).cl"