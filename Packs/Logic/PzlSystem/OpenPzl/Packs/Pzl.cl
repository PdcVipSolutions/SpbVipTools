﻿/*****************************************************************************
SpbSolutions
Visual Prolog PuZzLe

Copyright (c) Victor Yukhtenko

Send feedback to mailto:victor.a.yukhtenko@gmail.com

Package: PzlSystem
Class: pzl

@short The class contains the declaration for the class pzl predicates.

@detail This class includes class pzl declarations. The  pzl class is the only class,
 which users can use to communicae with the Puzzle system. Every pzlContainer includes
 this class, any class can use it.

@author Victor Yukhtenko
@end
******************************************************************************/
class pzl

predicates
    log:()->pzlLog.

predicates
    newByID:(pzlDomains::entityUID_D EntityUID,object InObject)->object OutObject.

predicates % Creation Object By Name
    newByName:(string Name,object InObject)->object OutObject procedure (i,i).
    % @short The class constructor, which creates the new instance of the PzlComponent with the given name
    % @detail Creates the new instance of the pzlComponent with the name Name.
    % The pzlComponent with the name Name must be registered in one of
    % the registration domains - in the Windows Registry or in the local registration file *.pzr.
    % The InObject may be the object pointer of any class instance. And the pzlComponent must
    % know the domain of this Object, if the conversion in the pzlComponent is to be performed.<br>
    %<br>
    % The returned object OutObject is the pointer to the requested object. To invoke the
    % predicate of the named pzlComponent the OutObject must be converted to the domain of
    % this class, for example:<br>
    %  ...<br>
    %  Object=newByName("MyComponent",This),<br>
    %  MyComponentInstance=tryConvert(iMyComponent,Object),<br>
    %  MyComponentInstance:myPredicate(...),<br>
    %  ...
    %
    % @exception The exception is rized if the pzlSystem can not perform the constructor by reasons:<br>
    % - the PzlSystem has no access to the registry store.<br>
    % - the pzlComponent with the given name is not found in the registry Store.<br>
    % - the pzlContainer, which contains the given pzlComponent can not be loaded<br>
    % - the lodaded pzlContainer doesn't contain the given pzlComponent<br>
    % - the constructor of the given pzlComponent can not create the instance<br>
    % The last exception desription contains the text: <br>
    % 'New2. newByName failured for the Component 'Name' '<br>
    % @end

predicates
    getContainerName:()->string ThisContainerName procedure ().
    % @short get the file name of the pzlContainer, in which the given class is placed
    % @detail Returnes the name (full path) of the file, where the given pzlComponent is placed.<br>
    % example:<br>
    %  ...<br>
    %  ContainerName=pzl:getContainerName(),<br>
    %  stdIO::writef("The component "MyComponent" placed in the Container %",ContainerName),<br>
    %  ...
    % @exception No special exception generated by the PzlSystem<br>
    % @end

predicates
    getContainerVersion:()->string ThisContainerVersion procedure ().
    % @short get the version of the current pzlContainer, in which the given class is placed
    % @detail Returnes the version of the pzlContainer, where the given pzlComponent is placed.<br>
    % The version of the pzlContainer is of string type and is defined by the constant "pzlContainerVersion_C" in the file iPzlConfig.i
    % of the pzlContainer's Project<br>
    % example:<br>
    %  the file iPzlCongig.i of the given pzlContainer contains the declaration of the constant<br>
    %   constants<br>
    %   pzlContainerVersion_C="1.0;001".<br>
    % the code below can obtain the version of the current pzlContainer<br>
    %  ContainerVersion=pzl::getContainerVersion(),<br>
    %  stdIO::writef("The version of the Container is  %",ContainerVersion),<br>
    %  ...
    % @exception No special exception generated by the PzlSystem<br>
    % @end

predicates
    getLicenseLevel:()->string PZLUserLicenseLevel procedure (). % supported for special cases only
    % @short get the license level of the given pzlContainer, in which the given class is placed
    % @detail Returnes the license level of the pzlContainer, where the given pzlComponent is placed.<br>
    % The License Level is defined by the company, which produces the pzlContainer<br>
    % and may have one of the following string values<br>
    % "Public"<br>
    % "Commercial"<br>
    % "Exclusive"<br>
    % "SuperExclusive"<br>
    % "Unknown"<br>
    %  if the current pzlContainer is the application, then the LicenseLevel returns the License
    %  level of the PzlPort
    %
    % example:<br>
    % the code below can obtain the license level of the current pzlContainer<br>
    %  ...<br>
    %  LicenseLevel=pzl:getLicenseLevel(),<br>
    %  stdIO::writef("The License Level of the current pzlContainer is  %",LicenseLevel),<br>
    %  ...
    % @exception No special exception generated by the PzlSystem<br>
    % @end

predicates
    setStdOutputStream:(outputStream OutputStream).

predicates
    getComponentRegisterFileName:()->pzlDomains::pzlComponentsRegisterFileName_D ComponentRegisterFileName procedure ().
    getContainerContentList:(string PZLContainerFileName)->pzlDomains::pzlContainerContentInfo_D ContentInfo procedure (i).

    releaseInactiveContainers:().
    getContainerActivity_nd:(string FileName,unsigned RefCounter) nondeterm (o,o).
    getContainerToBeUnloaded_nd:(string FileName) nondeterm (o).

    subscribe:(notificationAgency::notificationListenerFiltered NotificationListener).
    unSubscribe:(notificationAgency::notificationListenerFiltered NotificationListener).

predicates % Object registration
    register:(string ObjectName,object Object).
    registerMulti:(string ObjectName,object Object).
    getObjectByName_nd:(string ObjectName)->object Object nondeterm.
    getNameByObject_nd:(object Object)->string ObjectNameLow nondeterm.
    getNameAndObject_nd:(string ObjectName,object Object) nondeterm (o,o).
    unRegister:(string ObjectName,object Object).
    unRegisterByName:(string ObjectName).
    unRegisterAllByNamePrefix:(string EntityPrefix). % unregister all entities with the Prefixed names
    unRegisterByObject:(object Object).
    unRegisterAll:().

/* *************************************************************************
The two predicates below can not be invoked by Users.
The only PZL system may use these predicates
***************************************************************************/
predicates
    newInstance:().
    release:().
/* The end of system-privilaged predicates*/
end class pzl