/*****************************************************************************
Copyright (c) 2006-2016 PDCSPB

Author: Виктор Юхтенко/WIN-5L3MH3V6R7Q
******************************************************************************/
class appHead
    open core

predicates
    new:(object Container)->iMonoPzl_$$(Project.Name) ComponentInterface procedure (i).
    % @short Component class Proxy Constructor.
    % @detail This predicate constructs the new object of the Component.
    % @end

end class appHead