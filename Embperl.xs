/*###################################################################################
#
#   Embperl - Copyright (c) 1997-1999 Gerald Richter / ECOS
#
#   You may distribute under the terms of either the GNU General Public
#   License or the Artistic License, as specified in the Perl README file.
#   For use with Apache httpd and mod_perl, see also Apache copyright.
#
#   THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR
#   IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
#   WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
#
###################################################################################*/

#include "ep.h"
#include "xs/ep_xs_typedefs.h"
#include "xs/ep_xs_sv_convert.h"


/* for embperl_exit */
static IV errgv_empty_set(pTHX_ IV ix, SV * sv)
{ 
    sv_setsv(sv, &sv_undef);
    return TRUE;
}




MODULE = Embperl    PACKAGE = Embperl   PREFIX = embperl_

int
embperl_Init(pApacheSrvSV=NULL, pPerlParam=NULL)
    SV * pApacheSrvSV
    SV * pPerlParam
CODE:
    RETVAL = embperl_Init (aTHX_ pApacheSrvSV, pPerlParam, NULL) ;
OUTPUT:
    RETVAL


#ifdef APACHEXXX

void 
embperl_ApacheAddModule ()

#endif



MODULE = Embperl::Req    PACKAGE = Embperl::Req   PREFIX = embperl_

int
embperl_InitRequest(pApacheReqSV, pPerlParam)
    SV * pApacheReqSV
    SV * pPerlParam
PREINIT:
    Embperl__Req ppReq;
PPCODE:
    RETVAL = embperl_InitRequest(aTHX_ pApacheReqSV, pPerlParam, &ppReq);
    XSprePUSH ;
    EXTEND(SP, 2) ;
    PUSHs(epxs_IV_2obj(RETVAL)) ;
    PUSHs(epxs_Embperl__Req_2obj(ppReq)) ;

int
embperl_InitRequestComponent(pApacheReqSV, pPerlParam)
    SV * pApacheReqSV
    SV * pPerlParam
PREINIT:
    Embperl__Req ppReq;
PPCODE:
    RETVAL = embperl_InitRequestComponent(aTHX_ pApacheReqSV, pPerlParam, &ppReq);
    XSprePUSH ;
    EXTEND(SP, 2) ;
    PUSHs(epxs_IV_2obj(RETVAL)) ;
    PUSHs(epxs_Embperl__Req_2obj(ppReq)) ;


int
embperl_ExecuteRequest(pApacheReqSV=NULL, pPerlParam=NULL)
    SV * pApacheReqSV
    SV * pPerlParam
CODE:
    RETVAL = embperl_ExecuteRequest (aTHX_ pApacheReqSV, pPerlParam) ;
OUTPUT:
    RETVAL




INCLUDE: Old.xs


MODULE = Embperl    PACKAGE = Embperl   PREFIX = embperl_

void
embperl_Boot(version)
    SV * version
CODE:
    PUSHMARK(sp);  
    XPUSHs(sv_2mortal(newSVpv("Embperl::Thread", 0))) ;   
    XPUSHs(version) ;   
    PUTBACK;
    boot_Embperl__Thread (aTHX_ cv) ;

    PUSHMARK(sp);  
    XPUSHs(sv_2mortal(newSVpv("Embperl::App", 0))) ;   
    XPUSHs(version) ;   
    PUTBACK;
    boot_Embperl__App (aTHX_ cv) ;

    PUSHMARK(sp);  
    XPUSHs(sv_2mortal(newSVpv("Embperl::App::Config", 0))) ;   
    XPUSHs(version) ;   
    PUTBACK;
    boot_Embperl__App__Config (aTHX_ cv) ;

    PUSHMARK(sp);  
    XPUSHs(sv_2mortal(newSVpv("Embperl::Req", 0))) ;   
    XPUSHs(version) ;   
    PUTBACK;
    boot_Embperl__Req (aTHX_ cv) ;

    PUSHMARK(sp);  
    XPUSHs(sv_2mortal(newSVpv("Embperl::Req::Config", 0))) ;   
    XPUSHs(version) ;   
    PUTBACK;
    boot_Embperl__Req__Config (aTHX_ cv) ;

    PUSHMARK(sp);  
    XPUSHs(sv_2mortal(newSVpv("Embperl::Req::Param", 0))) ;   
    XPUSHs(version) ;   
    PUTBACK;
    boot_Embperl__Req__Param (aTHX_ cv) ;

    PUSHMARK(sp);  
    XPUSHs(sv_2mortal(newSVpv("Embperl::Component", 0))) ;   
    XPUSHs(version) ;   
    PUTBACK;
    boot_Embperl__Component (aTHX_ cv) ;

    PUSHMARK(sp);  
    XPUSHs(sv_2mortal(newSVpv("Embperl::Component::Config", 0))) ;   
    XPUSHs(version) ;   
    PUTBACK;
    boot_Embperl__Component__Config (aTHX_ cv) ;

    PUSHMARK(sp);  
    XPUSHs(sv_2mortal(newSVpv("Embperl::Component::Param", 0))) ;   
    XPUSHs(version) ;   
    PUTBACK;
    boot_Embperl__Component__Param (aTHX_ cv) ;

    PUSHMARK(sp);  
    XPUSHs(sv_2mortal(newSVpv("Embperl::Component::Output", 0))) ;   
    XPUSHs(version) ;   
    PUTBACK;
    boot_Embperl__Component__Output (aTHX_ cv) ;

    PUSHMARK(sp);  
    XPUSHs(sv_2mortal(newSVpv("Embperl::Syntax", 0))) ;   
    XPUSHs(version) ;   
    PUTBACK;
    boot_Embperl__Syntax (aTHX_ cv) ;



