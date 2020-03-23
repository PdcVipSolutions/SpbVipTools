%

interface aboutDialog supports dialog
    open core

properties
    baseFont_P:vpiDomains::font (i).
    defaultFont_P:vpiDomains::font (i).

    productFamily_P:string (i).
    productFamilyFont_P:vpiDomains::font (i).

    productName_P:string (i).
    productNameFont_P:vpiDomains::font (i).

    copyright_P:string (i).
    copyrightFont_P:vpiDomains::font (i).

    companyName_P:string (i).
    companyNameFont_P:vpiDomains::font (i).

    content_P:string (i).
    contentFont_P:vpiDomains::font (i).

    image_P:image (i).

end interface aboutDialog