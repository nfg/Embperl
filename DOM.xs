###################################################################################
#
#   Embperl - Copyright (c) 1997-2001 Gerald Richter / ECOS
#
#   You may distribute under the terms of either the GNU General Public
#   License or the Artistic License, as specified in the Perl README file.
#   For use with Apache httpd and mod_perl, see also Apache copyright.
#
#   THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR
#   IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
#   WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
#
#   $Id: DOM.xs,v 1.1.2.27 2002/05/21 12:09:07 richter Exp $
#
###################################################################################



MODULE = XML::Embperl::DOM      PACKAGE = XML::Embperl::DOM     PREFIX = embperl_


################################################################################

MODULE = XML::Embperl::DOM      PACKAGE = XML::Embperl::DOM::Node     PREFIX = embperl_Node_

void
embperl_Node_attach (pRV,xDomTree,xNode)
    SV * pRV ;
    int  xDomTree
    int  xNode
CODE:
    tDomNode * pDomNode ;
    MAGIC * mg ;
    SV *    pSV = SvRV(pRV) ;
    if (mg = mg_find (pSV, '~'))
        {
        pDomNode = (tDomNode *)(mg -> mg_len) ;
        if (xDomTree)
            pDomNode -> xDomTree = xDomTree ;
        if (xNode)    
            pDomNode -> xNode = xNode ;
        }    
    else
        {
        Newc (0, pDomNode, 1, sizeof (tDomNode), tDomNode) ;
        pDomNode -> xDomTree = xDomTree ;
        pDomNode -> xNode = xNode ;
        pDomNode -> pDomNodeSV = pRV ;
        /* sv_unmagic ((SV *)pSV, '~') ; */
        sv_magic ((SV *)pSV, NULL, '~', (char *)&pDomNode, sizeof (pDomNode)) ;
        /* sv_bless (pRV, gv_stashpv ("XML::Embperl::DOM::Node", 0)) ; */
        }
    


SV *
embperl_Node_replaceChildWithCDATA (CurrApp, pDomNode,sText)
    tDomNode * pDomNode
    SV *     sText
PREINIT:
    STRLEN l ;
    char * s  ;
    tReq * r = CurrReq ;
PPCODE:
    RETVAL = NULL ; /* avoid warning */
    SvGETMAGIC_P4(sText) ;
    s = SV2String (sText, l) ;
    Node_replaceChildWithCDATA (CurrApp, DomTree_self(pDomNode -> xDomTree), pDomNode -> xNode, r -> Component.nCurrRepeatLevel, s, l, (r -> Component.nCurrEscMode & 11)== 3?1 + (r -> Component.nCurrEscMode & 4):r -> Component.nCurrEscMode, 0) ;
    r -> Component.nCurrEscMode = r -> Component.Config.nEscMode ;
    r -> Component.bEscModeSet = -1 ;
    /*SvREFCNT_inc (sText) ;*/
    ST(0) = sText ;
    XSRETURN(1) ;


SV *
embperl_Node_XXiReplaceChildWithCDATA (xDomTree, xOldChild,sText)
    int xDomTree
    int xOldChild
    SV * sText
PREINIT:
    STRLEN l ;
    char * s  ;
    tReq * r = CurrReq ;
PPCODE:
    RETVAL = NULL ; /* avoid warning */
    SvGETMAGIC_P4(sText) ;
    s = SV2String (sText, l) ;
    Node_replaceChildWithCDATA (CurrApp, DomTree_self(xDomTree), xOldChild, r -> Component.nCurrRepeatLevel, s, l, (r -> Component.nCurrEscMode & 11)== 3?1 + (r -> Component.nCurrEscMode & 4):r -> Component.nCurrEscMode, 0) ;
    r -> Component.nCurrEscMode = r -> Component.Config.nEscMode ;
    r -> Component.bEscModeSet = -1 ;
    /*SvREFCNT_inc (sText) ;*/
    ST(0) = sText ;
    XSRETURN(1) ;


SV *
embperl_Node_iReplaceChildWithCDATA (xOldChild,sText)
    int xOldChild
    SV * sText
PREINIT:
    STRLEN l ;
    char * s  ;
    tReq * r = CurrReq ;
PPCODE:
    RETVAL = NULL ; /* avoid warning */
    SvGETMAGIC_P4(sText) ;
    s = SV2String (sText, l) ;
    Node_replaceChildWithCDATA (r -> pApp, DomTree_self(r -> Component.xCurrDomTree), xOldChild, r -> Component.nCurrRepeatLevel, s, l, (r -> Component.nCurrEscMode & 11)== 3?1 + (r -> Component.nCurrEscMode & 4):r -> Component.nCurrEscMode, 0) ;
    r -> Component.nCurrEscMode = r -> Component.Config.nEscMode ;
    r -> Component.bEscModeSet = -1 ;
    /*SvREFCNT_inc (sText) ;*/
    ST(0) = sText ;
    XSRETURN(1) ;


void
embperl_Node_iReplaceChildWithMsgId (xOldChild,sId)
    int xOldChild
    char * sId
PREINIT:
    STRLEN l ;
    const char * s  ;
    tReq * r = CurrReq ;
PPCODE:
    s = embperl_GetText (r, sId) ;
    l = strlen (s) ;
    Node_replaceChildWithCDATA (r -> pApp, DomTree_self(r -> Component.xCurrDomTree), xOldChild, r -> Component.nCurrRepeatLevel, s, l, (r -> Component.nCurrEscMode & 11)== 3?1 + (r -> Component.nCurrEscMode & 4):r -> Component.nCurrEscMode, 0) ;
    r -> Component.nCurrEscMode = r -> Component.Config.nEscMode ;
    r -> Component.bEscModeSet = -1 ;



SV *
embperl_Node_replaceChildWithUrlDATA (pDomNode,sText)
    tDomNode * pDomNode
    SV * sText
PREINIT:
    SV * sRet  ;
    tReq * r = CurrReq ;
PPCODE:
    RETVAL = NULL ; /* avoid warning */
    SvGETMAGIC_P4(sText) ;
    sRet = Node_replaceChildWithUrlDATA (r, pDomNode -> xDomTree, pDomNode -> xNode, r -> Component.nCurrRepeatLevel, sText) ;

    ST(0) = sRet ;
    XSRETURN(1) ;

SV *
embperl_Node_iReplaceChildWithUrlDATA (xOldChild,sText)
    int xOldChild
    SV * sText
PREINIT:
    SV * sRet  ;
    tReq * r = CurrReq ;
PPCODE:
    RETVAL = NULL ; /* avoid warning */
    SvGETMAGIC_P4(sText) ;
    sRet = Node_replaceChildWithUrlDATA (r, r -> Component.xCurrDomTree, xOldChild, r -> Component.nCurrRepeatLevel, sText) ;

    ST(0) = sRet ;
    XSRETURN(1) ;


void
embperl_Node_removeChild (pDomNode)
    tDomNode * pDomNode
CODE:
    Node_removeChild (CurrApp, DomTree_self (pDomNode -> xDomTree), -1, pDomNode -> xNode, 0) ;


void
embperl_Node_iRemoveChild (xDomTree, xChild)
    int xDomTree
    int xChild
CODE:
    Node_removeChild (CurrApp, DomTree_self (xDomTree), -1, xChild, 0) ;


void
embperl_Node_appendChild (pParentNode, nType, sText)
    tDomNode * pParentNode
    int nType
    SV * sText
PREINIT:
    STRLEN nText ;
    char * sT  ;
    tDomTree * pDomTree  ;
    tReq * r = CurrReq ;
CODE:
    sT = SV2String (sText, nText) ;
    pDomTree = DomTree_self(pParentNode -> xDomTree) ;
    Node_appendChild (r -> pApp, pDomTree, pParentNode -> xNode, r -> Component.nCurrRepeatLevel, (tNodeType)nType, 0, sT, nText, 0, 0, NULL) ;


void
embperl_Node_iAppendChild (xDomTree, xParent, nType, sText)
    int xDomTree
    int xParent
    int nType
    SV * sText
    tReq * r = CurrReq ;
CODE:
    STRLEN nText ;
    char * sT = SV2String (sText, nText) ;
    tDomTree * pDomTree = DomTree_self(xDomTree) ;
    Node_appendChild (r -> pApp, pDomTree, xParent, r -> Component.nCurrRepeatLevel, (tNodeType)nType, 0, sT, nText, 0, 0, NULL) ;


char *
embperl_Node_iChildsText (xDomTree, xChild, bDeep=0)
    int xDomTree
    int xChild
    int bDeep
PREINIT:
    char * sText ;
    tReq * r = CurrReq ;
CODE:
    sText = Node_childsText (r -> pApp, DomTree_self (xDomTree), xChild, r -> Component.nCurrRepeatLevel, 0, bDeep) ;
    RETVAL = sText?sText:"" ;
OUTPUT:
    RETVAL
CLEANUP:
    StringFree (r -> pApp, &sText) ;


################################################################################

MODULE = XML::Embperl::DOM      PACKAGE = XML::Embperl::DOM::Tree     PREFIX = embperl_DomTree_

void
embperl_DomTree_iCheckpoint (nCheckpoint)
    int nCheckpoint
PREINIT:
    tReq * r = CurrReq ;
CODE:
    r -> Component.nCurrEscMode = r -> Component.Config.nEscMode ;
    r -> Component.bEscModeSet = -1 ;
    DomTree_checkpoint (r, nCheckpoint) ;

void
embperl_DomTree_iDiscardAfterCheckpoint (nCheckpoint)
    int nCheckpoint
CODE:
    DomTree_discardAfterCheckpoint (CurrReq, nCheckpoint) ;

#void
#Node_parentNode (xChild)
#    int xChild
#
#void
#Node_firstChild (xChild)
#    int xChild


################################################################################

MODULE = XML::Embperl::DOM      PACKAGE = XML::Embperl::DOM::Element     PREFIX = embperl_Element_


void
embperl_Element_setAttribut (pDomNode, sAttr, sText)
    tDomNode * pDomNode
    SV * sAttr
    SV * sText
PREINIT:
    STRLEN nAttr ;
    STRLEN nText ;
    char * sT  ;
    char * sA  ;
    tDomTree * pDomTree ;
    tReq * r = CurrReq ;
CODE:
    sT = SV2String (sText, nText) ;
    sA = SV2String (sAttr, nAttr) ;

    pDomTree = DomTree_self (pDomNode -> xDomTree) ;

    Element_selfSetAttribut (r -> pApp, pDomTree, Node_self (pDomTree, pDomNode -> xNode), r -> Component.nCurrRepeatLevel, sA, nAttr, sT, nText) ;


void
embperl_Element_iSetAttribut (xDomTree, xNode, sAttr, sText)
    int xDomTree
    int xNode
    SV * sAttr
    SV * sText
PREINIT:
    tReq * r = CurrReq ;
CODE:
    STRLEN nAttr ;
    STRLEN nText ;
    char * sT = SV2String (sText, nText) ;
    char * sA = SV2String (sAttr, nAttr) ;
    tDomTree * pDomTree = DomTree_self (xDomTree) ;

    Element_selfSetAttribut (r -> pApp, pDomTree, Node_self (pDomTree, xNode), r -> Component.nCurrRepeatLevel, sA, nAttr, sT, nText) ;




void
embperl_Element_removeAttribut (pDomNode, xNode, sAttr)
    tDomNode * pDomNode
    SV * sAttr
PREINIT:
    STRLEN nAttr ;
    char * sA  ;
    tDomTree * pDomTree ;
    tReq * r = CurrReq ;
CODE:
    sA = SV2String (sAttr, nAttr) ;
    pDomTree = DomTree_self (pDomNode -> xDomTree) ;

    Element_selfRemoveAttribut (r -> pApp, pDomTree, Node_self (pDomTree, pDomNode -> xNode), r -> Component.nCurrRepeatLevel, sA, nAttr) ;


void
embperl_Element_iRemoveAttribut (xDomTree, xNode, sAttr)
    int xDomTree
    int xNode
    SV * sAttr
PREINIT:
    tReq * r = CurrReq ;
CODE:
    STRLEN nAttr ;
    char * sA = SV2String (sAttr, nAttr) ;
    tDomTree * pDomTree = DomTree_self (xDomTree) ;

    Element_selfRemoveAttribut (r -> pApp, pDomTree, Node_self (pDomTree, xNode), r -> Component.nCurrRepeatLevel, sA, nAttr) ;


################################################################################

MODULE = XML::Embperl::DOM      PACKAGE = XML::Embperl::DOM::Attr     PREFIX = embperl_Attr_



SV *
embperl_Attr_value (pAttr)
    tDomNode * pAttr
PREINIT:
    tDomTree * pDomTree  ;
    char * sAttrText = NULL ;
    tReq * r = CurrReq ;
CODE:
    pDomTree = DomTree_self (pAttr -> xDomTree) ;

    Attr_selfValue (r -> pApp, pDomTree, Attr_self(pDomTree, pAttr -> xNode), r -> Component.nCurrRepeatLevel, &sAttrText) ;
    RETVAL = sAttrText?newSVpv (sAttrText, 0):&sv_undef ;
    StringFree (r -> pApp, &sAttrText) ;
OUTPUT:
    RETVAL


SV *
embperl_Attr_iValue (xDomTree, xAttr)
    int xDomTree
    int xAttr
PREINIT:
    tReq * r = CurrReq ;
CODE:
    tDomTree * pDomTree = DomTree_self (xDomTree) ;
    char * sAttrText = NULL ;
    tAttrData * pAttr  ;
    
    /* lprintf (CurrReq, "xDomTree=%d, xAttr=%d pDomTree=%x\n", xDomTree, xAttr, pDomTree) ;*/
    
    pAttr = Attr_self(pDomTree, xAttr) ;
    Attr_selfValue (r -> pApp, pDomTree, pAttr , r -> Component.nCurrRepeatLevel, &sAttrText) ;
    RETVAL = sAttrText?newSVpv (sAttrText, 0):&sv_undef ;
    StringFree (r -> pApp, &sAttrText) ;
OUTPUT:
    RETVAL

