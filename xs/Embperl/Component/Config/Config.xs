
/*
 * *********** WARNING **************
 * This file generated by Embperl::WrapXS/0.01
 * Any changes made here will be lost
 * ***********************************
 * 1. /opt/perlt5.6.1/lib/site_perl/5.6.1/ExtUtils/XSBuilder/WrapXS.pm:37
 * 2. /opt/perlt5.6.1/lib/site_perl/5.6.1/ExtUtils/XSBuilder/WrapXS.pm:1814
 * 3. xsbuilder/xs_generate.pl:6
 */


#include "ep.h"

#include "epmacro.h"

#include "EXTERN.h"

#include "perl.h"

#include "XSUB.h"

#include "eptypes.h"

#include "eppublic.h"

#include "epdat2.h"

#include "ep_xs_sv_convert.h"

#include "ep_xs_typedefs.h"



void Embperl__Component__Config_destroy (pTHX_ Embperl__Component__Config  obj) {
            if (obj -> pExpiredFunc)
                SvREFCNT_dec(obj -> pExpiredFunc);
            if (obj -> pCacheKeyFunc)
                SvREFCNT_dec(obj -> pCacheKeyFunc);
            if (obj -> pRecipe)
                SvREFCNT_dec(obj -> pRecipe);

};



void Embperl__Component__Config_new_init (pTHX_ Embperl__Component__Config  obj, SV * item, int overwrite) {

    SV * * tmpsv ;

    if (SvTYPE(item) == SVt_PVMG) 
        memcpy (obj, (void *)SvIVX(item), sizeof (*obj)) ;
    else if (SvTYPE(item) == SVt_PVHV) {
        if ((tmpsv = hv_fetch((HV *)item, "package", sizeof("package") - 1, 0)) || overwrite)
            obj -> sPackage = (char *)ep_pstrdup(obj->pPool,((char *)epxs_sv2_PV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef))));
        if ((tmpsv = hv_fetch((HV *)item, "debug", sizeof("debug") - 1, 0)) || overwrite)
            obj -> bDebug = (unsigned)epxs_sv2_UV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)) ;
        if ((tmpsv = hv_fetch((HV *)item, "options", sizeof("options") - 1, 0)) || overwrite)
            obj -> bOptions = (unsigned)epxs_sv2_UV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)) ;
        if ((tmpsv = hv_fetch((HV *)item, "cleanup", sizeof("cleanup") - 1, 0)) || overwrite)
            obj -> nCleanup = (int)epxs_sv2_IV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)) ;
        if ((tmpsv = hv_fetch((HV *)item, "escmode", sizeof("escmode") - 1, 0)) || overwrite)
            obj -> nEscMode = (int)epxs_sv2_IV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)) ;
        if ((tmpsv = hv_fetch((HV *)item, "input_escmode", sizeof("input_escmode") - 1, 0)) || overwrite)
            obj -> nInputEscMode = (int)epxs_sv2_IV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)) ;
        if ((tmpsv = hv_fetch((HV *)item, "input_charset", sizeof("input_charset") - 1, 0)) || overwrite)
            obj -> sInputCharset = (char *)ep_pstrdup(obj->pPool,((char *)epxs_sv2_PV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef))));
        if ((tmpsv = hv_fetch((HV *)item, "ep1compat", sizeof("ep1compat") - 1, 0)) || overwrite)
            obj -> bEP1Compat = (int)epxs_sv2_IV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)) ;
        if ((tmpsv = hv_fetch((HV *)item, "cache_key", sizeof("cache_key") - 1, 0)) || overwrite)
            obj -> sCacheKey = (char *)ep_pstrdup(obj->pPool,((char *)epxs_sv2_PV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef))));
        if ((tmpsv = hv_fetch((HV *)item, "cache_key_options", sizeof("cache_key_options") - 1, 0)) || overwrite)
            obj -> bCacheKeyOptions = (unsigned)epxs_sv2_UV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)) ;
        if ((tmpsv = hv_fetch((HV *)item, "expires_func", sizeof("expires_func") - 1, 0)) || overwrite)
            obj -> pExpiredFunc = (CV *)SvREFCNT_inc(((CV *)epxs_sv2_SVPTR((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef))));
        if ((tmpsv = hv_fetch((HV *)item, "cache_key_func", sizeof("cache_key_func") - 1, 0)) || overwrite)
            obj -> pCacheKeyFunc = (CV *)SvREFCNT_inc(((CV *)epxs_sv2_SVPTR((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef))));
        if ((tmpsv = hv_fetch((HV *)item, "expires_in", sizeof("expires_in") - 1, 0)) || overwrite)
            obj -> nExpiresIn = (int)epxs_sv2_IV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)) ;
        if ((tmpsv = hv_fetch((HV *)item, "syntax", sizeof("syntax") - 1, 0)) || overwrite)
            obj -> sSyntax = (char *)ep_pstrdup(obj->pPool,((char *)epxs_sv2_PV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef))));
        if ((tmpsv = hv_fetch((HV *)item, "recipe", sizeof("recipe") - 1, 0)) || overwrite)
            obj -> pRecipe = (SV *)SvREFCNT_inc(((SV *)epxs_sv2_SVPTR((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef))));
        if ((tmpsv = hv_fetch((HV *)item, "xsltstylesheet", sizeof("xsltstylesheet") - 1, 0)) || overwrite)
            obj -> sXsltstylesheet = (char *)ep_pstrdup(obj->pPool,((char *)epxs_sv2_PV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef))));
        if ((tmpsv = hv_fetch((HV *)item, "xsltproc", sizeof("xsltproc") - 1, 0)) || overwrite)
            obj -> sXsltproc = (char *)ep_pstrdup(obj->pPool,((char *)epxs_sv2_PV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef))));
        if ((tmpsv = hv_fetch((HV *)item, "compartment", sizeof("compartment") - 1, 0)) || overwrite)
            obj -> sCompartment = (char *)ep_pstrdup(obj->pPool,((char *)epxs_sv2_PV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef))));
   ; }

    else
        croak ("initializer for Embperl::Component::Config::new is not a hash or object reference") ;

} ;


MODULE = Embperl::Component::Config    PACKAGE = Embperl::Component::Config 

char *
package(obj, val=NULL)
    Embperl::Component::Config obj
    char * val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (char *)  obj->sPackage;

    if (items > 1) {
        obj->sPackage = (char *)ep_pstrdup(obj->pPool,val);
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component::Config    PACKAGE = Embperl::Component::Config 

unsigned
debug(obj, val=0)
    Embperl::Component::Config obj
    unsigned val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (unsigned)  obj->bDebug;

    if (items > 1) {
        obj->bDebug = (unsigned) val;
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component::Config    PACKAGE = Embperl::Component::Config 

unsigned
options(obj, val=0)
    Embperl::Component::Config obj
    unsigned val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (unsigned)  obj->bOptions;

    if (items > 1) {
        obj->bOptions = (unsigned) val;
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component::Config    PACKAGE = Embperl::Component::Config 

int
cleanup(obj, val=0)
    Embperl::Component::Config obj
    int val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (int)  obj->nCleanup;

    if (items > 1) {
        obj->nCleanup = (int) val;
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component::Config    PACKAGE = Embperl::Component::Config 

int
escmode(obj, val=0)
    Embperl::Component::Config obj
    int val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (int)  obj->nEscMode;

    if (items > 1) {
        obj->nEscMode = (int) val;
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component::Config    PACKAGE = Embperl::Component::Config 

int
input_escmode(obj, val=0)
    Embperl::Component::Config obj
    int val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (int)  obj->nInputEscMode;

    if (items > 1) {
        obj->nInputEscMode = (int) val;
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component::Config    PACKAGE = Embperl::Component::Config 

char *
input_charset(obj, val=NULL)
    Embperl::Component::Config obj
    char * val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (char *)  obj->sInputCharset;

    if (items > 1) {
        obj->sInputCharset = (char *)ep_pstrdup(obj->pPool,val);
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component::Config    PACKAGE = Embperl::Component::Config 

int
ep1compat(obj, val=0)
    Embperl::Component::Config obj
    int val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (int)  obj->bEP1Compat;

    if (items > 1) {
        obj->bEP1Compat = (int) val;
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component::Config    PACKAGE = Embperl::Component::Config 

char *
cache_key(obj, val=NULL)
    Embperl::Component::Config obj
    char * val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (char *)  obj->sCacheKey;

    if (items > 1) {
        obj->sCacheKey = (char *)ep_pstrdup(obj->pPool,val);
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component::Config    PACKAGE = Embperl::Component::Config 

unsigned
cache_key_options(obj, val=0)
    Embperl::Component::Config obj
    unsigned val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (unsigned)  obj->bCacheKeyOptions;

    if (items > 1) {
        obj->bCacheKeyOptions = (unsigned) val;
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component::Config    PACKAGE = Embperl::Component::Config 

CV *
expires_func(obj, val=NULL)
    Embperl::Component::Config obj
    CV * val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (CV *)  obj->pExpiredFunc;

    if (items > 1) {
        obj->pExpiredFunc = (CV *)SvREFCNT_inc(val);
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component::Config    PACKAGE = Embperl::Component::Config 

CV *
cache_key_func(obj, val=NULL)
    Embperl::Component::Config obj
    CV * val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (CV *)  obj->pCacheKeyFunc;

    if (items > 1) {
        obj->pCacheKeyFunc = (CV *)SvREFCNT_inc(val);
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component::Config    PACKAGE = Embperl::Component::Config 

int
expires_in(obj, val=0)
    Embperl::Component::Config obj
    int val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (int)  obj->nExpiresIn;

    if (items > 1) {
        obj->nExpiresIn = (int) val;
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component::Config    PACKAGE = Embperl::Component::Config 

char *
syntax(obj, val=NULL)
    Embperl::Component::Config obj
    char * val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (char *)  obj->sSyntax;

    if (items > 1) {
        obj->sSyntax = (char *)ep_pstrdup(obj->pPool,val);
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component::Config    PACKAGE = Embperl::Component::Config 

SV *
recipe(obj, val=NULL)
    Embperl::Component::Config obj
    SV * val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (SV *)  obj->pRecipe;

    if (items > 1) {
        obj->pRecipe = (SV *)SvREFCNT_inc(val);
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component::Config    PACKAGE = Embperl::Component::Config 

char *
xsltstylesheet(obj, val=NULL)
    Embperl::Component::Config obj
    char * val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (char *)  obj->sXsltstylesheet;

    if (items > 1) {
        obj->sXsltstylesheet = (char *)ep_pstrdup(obj->pPool,val);
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component::Config    PACKAGE = Embperl::Component::Config 

char *
xsltproc(obj, val=NULL)
    Embperl::Component::Config obj
    char * val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (char *)  obj->sXsltproc;

    if (items > 1) {
        obj->sXsltproc = (char *)ep_pstrdup(obj->pPool,val);
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component::Config    PACKAGE = Embperl::Component::Config 

char *
compartment(obj, val=NULL)
    Embperl::Component::Config obj
    char * val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (char *)  obj->sCompartment;

    if (items > 1) {
        obj->sCompartment = (char *)ep_pstrdup(obj->pPool,val);
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component::Config    PACKAGE = Embperl::Component::Config 



SV *
new (class,initializer=NULL)
    char * class
    SV * initializer 
PREINIT:
    SV * svobj ;
    Embperl__Component__Config  cobj ;
    SV * tmpsv ;
CODE:
    epxs_Embperl__Component__Config_create_obj(cobj,svobj,RETVAL,malloc(sizeof(*cobj))) ;

    if (initializer) {
        if (!SvROK(initializer) || !(tmpsv = SvRV(initializer))) 
            croak ("initializer for Embperl::Component::Config::new is not a reference") ;

        if (SvTYPE(tmpsv) == SVt_PVHV || SvTYPE(tmpsv) == SVt_PVMG)  
            Embperl__Component__Config_new_init (aTHX_ cobj, tmpsv, 1) ;
        else if (SvTYPE(tmpsv) == SVt_PVAV) {
            int i ;
            SvGROW(svobj, sizeof (*cobj) * av_len((AV *)tmpsv)) ;     
            for (i = 0; i <= av_len((AV *)tmpsv); i++) {
                SV * * itemrv = av_fetch((AV *)tmpsv, i, 0) ;
                SV * item ;
                if (!itemrv || !*itemrv || !SvROK(*itemrv) || !(item = SvRV(*itemrv))) 
                    croak ("array element of initializer for Embperl::Component::Config::new is not a reference") ;
                Embperl__Component__Config_new_init (aTHX_ &cobj[i], item, 1) ;
            }
        }
        else {
             croak ("initializer for Embperl::Component::Config::new is not a hash/array/object reference") ;
        }
    }
OUTPUT:
    RETVAL 

MODULE = Embperl::Component::Config    PACKAGE = Embperl::Component::Config 



void
DESTROY (obj)
    Embperl::Component::Config  obj 
CODE:
    Embperl__Component__Config_destroy (aTHX_ obj) ;

PROTOTYPES: disabled

BOOT:
    items = items; /* -Wall */

