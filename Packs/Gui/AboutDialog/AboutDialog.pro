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
    image_P(Image):-about_Shadow_ctl:setGdipImage(Image).

clauses
    display(Parent) = Dialog :-
        Dialog = new(Parent),
        Dialog:show().

clauses
    new(Parent) :-
        dialog::new(Parent),
        generatedInitialize().

% This code is maintained automatically, do not update it manually.
%  12:03:33-25.6.2019

facts
    ok_ctl : button.
    productFamily_St_ctl : textControl.
    productName_St_ctl : textControl.
    copyright_St_ctl : textControl.
    companyName_ST_ctl : textControl.
    content_EC_ctl : textControl.
    about_Shadow_ctl : imagecontrol.

predicates
    generatedInitialize : ().
clauses
    generatedInitialize() :-
        setText("AboutDialog"),
        setRect(rct(50, 40, 262, 236)),
        setModal(true),
        setDecoration(titlebar([closeButton])),
        setState([wsf_NoClipSiblings]),
        ok_ctl := button::newOk(This),
        ok_ctl:setText("&OK"),
        ok_ctl:setPosition(72, 180),
        ok_ctl:setSize(56, 12),
        ok_ctl:defaultHeight := false,
        ok_ctl:setAnchors([control::right, control::bottom]),
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
        copyright_St_ctl:setPosition(52, 46),
        copyright_St_ctl:setSize(156, 10),
        companyName_ST_ctl := textControl::new(This),
        companyName_ST_ctl:setText("Company Name"),
        companyName_ST_ctl:setPosition(52, 56),
        companyName_ST_ctl:setSize(156, 36),
        content_EC_ctl := textControl::new(This),
        content_EC_ctl:setText("Static text"),
        content_EC_ctl:setPosition(4, 94),
        content_EC_ctl:setSize(204, 82),
        content_EC_ctl:setBorder(true),
        content_EC_ctl:setVerticalScroll(true),
        about_Shadow_ctl := imagecontrol::new(This),
        about_Shadow_ctl:setPosition(4, 46),
        about_Shadow_ctl:setSize(46, 46).
% end of automatic code
end implement aboutDialog