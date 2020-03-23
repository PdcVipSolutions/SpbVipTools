%

interface ribbonLoader
    open core

constants
    xmlRibbonScriptVersion_C="23.08.2019".
    noNameSpace_C="noNameSpace".

% If no function defined or not faund then the default function name used
    default_C="default".
    undefined_C="undefined".

% Ribbon Main Features
    ribbon_layout_C="ribbon-layout".
    basedir_C="basedir".
    dictionary_C="dictionary".
    namespace_C="namespace".
    version_C="version".

% Ribbon Structure
    section_C="section".
    block_C="block".
    row_C="row".
    cmd_C="cmd".
    menu_C="menu".
    custom_C="custom".
    separator_C="separator".

% Entities Usually Have
    id_C="id". % Must be
    label_C="label".
    icon_C="icon".
    tooltip_C="tooltip".
        text_C="text".
    % render_C="render"  - has functionName

%Commands attributes
constants
    run_C="run".
    cmdstyle_C="cmdstyle".
        imageOnly_C="image-only".
        textOnly_C="text-only".
        imageAndTextVertical_C="image-and-text-vertical".
        imageAndTextHorizontal_C="image-and-text-horizontal".
    menu_label_C="menu-label".
    enabled_C="enabled".
    visible_C="visible".
    changeEvent_C="changeEvent".
    category_C="category".
    badge_C="badge".

    %menuCommand specific
    layout_C="layout".
        static_C="static".
        render_C="render".
    function_C="function".
    style_C="style".
        popupmenu_C="popupmenu".
        variantmenu_C="variantmenu".
        toolmenu_C="toolmenu".

    %customCommand specific
    factory_C="factory".
    control_type_C="control-type".
    width_C="width".
    height_C="height".

% Icon Specific
    file_C="file".
    binary_C="binary".
    iconID_C="icon-id".
    functionID_C="function-id".

% Accelerators handling
    acceleratorkey_C="acceleratorkey".
    keycode_C="keycode".
    keymodifier_C="keymodifier".
    nothing_C="nothing".
    shift_C="shift".
    control_C="control".
    alt_C="alt".
    shiftctl_C="shiftctl".
    shiftalt_C="shiftalt".
    ctlalt_C="ctlalt".
    shiftctlalt_C="shiftctlalt".

properties
    xmlDataFile_P:string.

predicates
    tryLoadXmlDataFile : () determ.
    loadXmlData:(binary BinaryXml).

predicates
    getLayout:(cmdPerformers ContextObj)->ribbonControl::layout.

end interface ribbonLoader
