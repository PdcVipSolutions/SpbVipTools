%

implement aboutDialog
    inherits dialog
    open core, vpiDomains

facts - settings_FB
    baseFont_V:vpiDomains::font:=erroneous.
    defaultFont_V:vpiDomains::font:=erroneous.

clauses
    baseFont_P(Font):-baseFont_V:=Font.
    defaultFont_P(Font):-defaultFont_V:=Font.
    productFamily_P(Text):-productFamily_St_ctl:setText(Text).
    productFamilyFont_P(Font):-productFamily_St_ctl:setFont(Font).
    productName_P(Text):-productName_St_ctl:setText(Text).
    productNameFont_P(Font):-productName_St_ctl:setFont(Font).
    copyright_P(Text):-copyright_St_ctl:setText(Text).
    copyrightFont_P(Font):-copyright_St_ctl:setFont(Font).
    companyName_P(Text):-companyName_ST_ctl:setText(Text).
    companyNameFont_P(Font):-companyName_ST_ctl:setFont(Font).
    content_P(Text):-content_EC_ctl:setText(Text).
    contentFont_P(Font):-content_EC_ctl:setFont(Font).

clauses
    display(Parent) = Dialog :-
        Dialog = new(Parent),
        Dialog:show().

clauses
    new(Parent) :-
        dialog::new(Parent),
        generatedInitialize().

predicates
    onContent_ECModified : editControl::modifiedListener.
clauses
    onContent_ECModified(_Source).

% This code is maintained automatically, do not update it manually. 22:32:25-10.10.2015
facts
    ok_ctl : button.
    productFamily_St_ctl : textControl.
    productName_St_ctl : textControl.
    copyright_St_ctl : textControl.
    companyName_ST_ctl : textControl.
    icon_ctl : iconControl.
    content_EC_ctl : textControl.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize():-
        setText("AboutDialog"),
        setRect(rct(50,40,262,198)),
        setModal(true),
        setDecoration(titlebar([closeButton])),
        setState([wsf_NoClipSiblings]),
        ok_ctl := button::newOk(This),
        ok_ctl:setText("&OK"),
        ok_ctl:setPosition(76, 142),
        ok_ctl:setSize(56, 12),
        ok_ctl:defaultHeight := false,
        ok_ctl:setAnchors([control::right,control::bottom]),
        productFamily_St_ctl := textControl::new(This),
        productFamily_St_ctl:setText("Product Family"),
        productFamily_St_ctl:setPosition(4, 4),
        productFamily_St_ctl:setSize(204, 14),
        productFamily_St_ctl:setAlignment(alignCenter),
        productName_St_ctl := textControl::new(This),
        productName_St_ctl:setText("Product Name"),
        productName_St_ctl:setPosition(4, 18),
        productName_St_ctl:setSize(204, 24),
        productName_St_ctl:setAlignment(alignCenter),
        copyright_St_ctl := textControl::new(This),
        copyright_St_ctl:setText("Copyright (c)"),
        copyright_St_ctl:setPosition(44, 46),
        copyright_St_ctl:setSize(164, 10),
        companyName_ST_ctl := textControl::new(This),
        companyName_ST_ctl:setText("Company Name"),
        companyName_ST_ctl:setPosition(44, 56),
        companyName_ST_ctl:setSize(164, 10),
        icon_ctl := iconControl::new(This),
        icon_ctl:setIcon(application_icon),
        icon_ctl:setPosition(8, 46),
        icon_ctl:setSize(25, 25),
        icon_ctl:setBorder(true),
        content_EC_ctl := textControl::new(This),
        content_EC_ctl:setText("Static text"),
        content_EC_ctl:setPosition(4, 72),
        content_EC_ctl:setSize(204, 68),
        content_EC_ctl:setBorder(true).
% end of automatic code
end implement aboutDialog