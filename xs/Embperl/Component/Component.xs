
/*
 * *********** WARNING **************
 * This file generated by Embperl::WrapXS/0.01
 * Any changes made here will be lost
 * ***********************************
 * 1. /opt/perlt5.8.3/lib/site_perl/5.8.3/ExtUtils/XSBuilder/WrapXS.pm:39
 * 2. /opt/perlt5.8.3/lib/site_perl/5.8.3/ExtUtils/XSBuilder/WrapXS.pm:2061
 * 3. xsbuilder/xs_generate.pl:6
 */


#include "ep.h"

#include "epmacro.h"

#include "epdat2.h"

#include "eptypes.h"

#include "eppublic.h"

#include "EXTERN.h"

#include "perl.h"

#include "XSUB.h"

#include "ep_xs_sv_convert.h"

#include "ep_xs_typedefs.h"



void Embperl__Component_destroy (pTHX_ Embperl__Component  obj) {
            if (obj -> ifdobj)
                SvREFCNT_dec(obj -> ifdobj);
            if (obj -> pImportStash)
                SvREFCNT_dec(obj -> pImportStash);
            if (obj -> pExportHash)
                SvREFCNT_dec(obj -> pExportHash);
            if (obj -> pCodeSV)
                SvREFCNT_dec(obj -> pCodeSV);

};



void Embperl__Component_new_init (pTHX_ Embperl__Component  obj, SV * item, int overwrite) {

    SV * * tmpsv ;

    if (SvTYPE(item) == SVt_PVMG) 
        memcpy (obj, (void *)SvIVX(item), sizeof (*obj)) ;
    else if (SvTYPE(item) == SVt_PVHV) {
        if ((tmpsv = hv_fetch((HV *)item, "req_running", sizeof("req_running") - 1, 0)) || overwrite) {
            obj -> bReqRunning = (bool)epxs_sv2_IV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)) ;
        }
        if ((tmpsv = hv_fetch((HV *)item, "sub_req", sizeof("sub_req") - 1, 0)) || overwrite) {
            obj -> bSubReq = (bool)epxs_sv2_IV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)) ;
        }
        if ((tmpsv = hv_fetch((HV *)item, "inside_sub", sizeof("inside_sub") - 1, 0)) || overwrite) {
            obj -> nInsideSub = (int)epxs_sv2_IV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)) ;
        }
        if ((tmpsv = hv_fetch((HV *)item, "had_exit", sizeof("had_exit") - 1, 0)) || overwrite) {
            obj -> bExit = (int)epxs_sv2_IV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)) ;
        }
        if ((tmpsv = hv_fetch((HV *)item, "path_ndx", sizeof("path_ndx") - 1, 0)) || overwrite) {
            obj -> nPathNdx = (int)epxs_sv2_IV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)) ;
        }
        if ((tmpsv = hv_fetch((HV *)item, "cwd", sizeof("cwd") - 1, 0)) || overwrite) {
            char * tmpobj = ((char *)epxs_sv2_PV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)));
            if (tmpobj)
                obj -> sCWD = (char *)ep_pstrdup(obj->pPool,tmpobj);
            else
                obj -> sCWD = NULL ;
        }
        if ((tmpsv = hv_fetch((HV *)item, "ep1_compat", sizeof("ep1_compat") - 1, 0)) || overwrite) {
            obj -> bEP1Compat = (bool)epxs_sv2_IV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)) ;
        }
        if ((tmpsv = hv_fetch((HV *)item, "phase", sizeof("phase") - 1, 0)) || overwrite) {
            obj -> nPhase = (int)epxs_sv2_IV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)) ;
        }
        if ((tmpsv = hv_fetch((HV *)item, "sourcefile", sizeof("sourcefile") - 1, 0)) || overwrite) {
            char * tmpobj = ((char *)epxs_sv2_PV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)));
            if (tmpobj)
                obj -> sSourcefile = (char *)ep_pstrdup(obj->pPool,tmpobj);
            else
                obj -> sSourcefile = NULL ;
        }
        if ((tmpsv = hv_fetch((HV *)item, "buf", sizeof("buf") - 1, 0)) || overwrite) {
            char * tmpobj = ((char *)epxs_sv2_PV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)));
            if (tmpobj)
                obj -> pBuf = (char *)ep_pstrdup(obj->pPool,tmpobj);
            else
                obj -> pBuf = NULL ;
        }
        if ((tmpsv = hv_fetch((HV *)item, "end_pos", sizeof("end_pos") - 1, 0)) || overwrite) {
            char * tmpobj = ((char *)epxs_sv2_PV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)));
            if (tmpobj)
                obj -> pEndPos = (char *)ep_pstrdup(obj->pPool,tmpobj);
            else
                obj -> pEndPos = NULL ;
        }
        if ((tmpsv = hv_fetch((HV *)item, "curr_pos", sizeof("curr_pos") - 1, 0)) || overwrite) {
            char * tmpobj = ((char *)epxs_sv2_PV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)));
            if (tmpobj)
                obj -> pCurrPos = (char *)ep_pstrdup(obj->pPool,tmpobj);
            else
                obj -> pCurrPos = NULL ;
        }
        if ((tmpsv = hv_fetch((HV *)item, "sourceline", sizeof("sourceline") - 1, 0)) || overwrite) {
            obj -> nSourceline = (int)epxs_sv2_IV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)) ;
        }
        if ((tmpsv = hv_fetch((HV *)item, "sourceline_pos", sizeof("sourceline_pos") - 1, 0)) || overwrite) {
            char * tmpobj = ((char *)epxs_sv2_PV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)));
            if (tmpobj)
                obj -> pSourcelinePos = (char *)ep_pstrdup(obj->pPool,tmpobj);
            else
                obj -> pSourcelinePos = NULL ;
        }
        if ((tmpsv = hv_fetch((HV *)item, "line_no_curr_pos", sizeof("line_no_curr_pos") - 1, 0)) || overwrite) {
            char * tmpobj = ((char *)epxs_sv2_PV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)));
            if (tmpobj)
                obj -> pLineNoCurrPos = (char *)ep_pstrdup(obj->pPool,tmpobj);
            else
                obj -> pLineNoCurrPos = NULL ;
        }
        if ((tmpsv = hv_fetch((HV *)item, "document", sizeof("document") - 1, 0)) || overwrite) {
            obj -> xDocument = (tNode)epxs_sv2_IV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)) ;
        }
        if ((tmpsv = hv_fetch((HV *)item, "curr_node", sizeof("curr_node") - 1, 0)) || overwrite) {
            obj -> xCurrNode = (tNode)epxs_sv2_IV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)) ;
        }
        if ((tmpsv = hv_fetch((HV *)item, "curr_repeat_level", sizeof("curr_repeat_level") - 1, 0)) || overwrite) {
            obj -> nCurrRepeatLevel = (tRepeatLevel)epxs_sv2_IV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)) ;
        }
        if ((tmpsv = hv_fetch((HV *)item, "curr_checkpoint", sizeof("curr_checkpoint") - 1, 0)) || overwrite) {
            obj -> nCurrCheckpoint = (tIndex)epxs_sv2_IV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)) ;
        }
        if ((tmpsv = hv_fetch((HV *)item, "curr_dom_tree", sizeof("curr_dom_tree") - 1, 0)) || overwrite) {
            obj -> xCurrDomTree = (tIndex)epxs_sv2_IV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)) ;
        }
        if ((tmpsv = hv_fetch((HV *)item, "source_dom_tree", sizeof("source_dom_tree") - 1, 0)) || overwrite) {
            obj -> xSourceDomTree = (tIndex)epxs_sv2_IV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)) ;
        }
        if ((tmpsv = hv_fetch((HV *)item, "syntax", sizeof("syntax") - 1, 0)) || overwrite) {
            obj -> pTokenTable = (struct tTokenTable *)epxs_sv2_Embperl__Syntax((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)) ;
        }
        if ((tmpsv = hv_fetch((HV *)item, "ifdobj", sizeof("ifdobj") - 1, 0)) || overwrite) {
            SV * tmpobj = ((SV *)epxs_sv2_SVPTR((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)));
            if (tmpobj)
                obj -> ifdobj = (SV *)SvREFCNT_inc(tmpobj);
            else
                obj -> ifdobj = NULL ;
        }
        if ((tmpsv = hv_fetch((HV *)item, "append_to_main_req", sizeof("append_to_main_req") - 1, 0)) || overwrite) {
            obj -> bAppendToMainReq = (bool)epxs_sv2_IV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)) ;
        }
        if ((tmpsv = hv_fetch((HV *)item, "prev", sizeof("prev") - 1, 0)) || overwrite) {
            obj -> pPrev = (struct tComponent *)epxs_sv2_Embperl__Component((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)) ;
        }
        if ((tmpsv = hv_fetch((HV *)item, "strict", sizeof("strict") - 1, 0)) || overwrite) {
            obj -> bStrict = (int)epxs_sv2_IV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)) ;
        }
        if ((tmpsv = hv_fetch((HV *)item, "import_stash", sizeof("import_stash") - 1, 0)) || overwrite) {
            HV * tmpobj = ((HV *)epxs_sv2_HVREF((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)));
            if (tmpobj)
                obj -> pImportStash = (HV *)SvREFCNT_inc(tmpobj);
            else
                obj -> pImportStash = NULL ;
        }
        if ((tmpsv = hv_fetch((HV *)item, "exports", sizeof("exports") - 1, 0)) || overwrite) {
            HV * tmpobj = ((HV *)epxs_sv2_HVREF((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)));
            if (tmpobj)
                obj -> pExportHash = (HV *)SvREFCNT_inc(tmpobj);
            else
                obj -> pExportHash = NULL ;
        }
        if ((tmpsv = hv_fetch((HV *)item, "curr_package", sizeof("curr_package") - 1, 0)) || overwrite) {
            char * tmpobj = ((char *)epxs_sv2_PV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)));
            if (tmpobj)
                obj -> sCurrPackage = (char *)ep_pstrdup(obj->pPool,tmpobj);
            else
                obj -> sCurrPackage = NULL ;
        }
        if ((tmpsv = hv_fetch((HV *)item, "eval_package", sizeof("eval_package") - 1, 0)) || overwrite) {
            char * tmpobj = ((char *)epxs_sv2_PV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)));
            if (tmpobj)
                obj -> sEvalPackage = (char *)ep_pstrdup(obj->pPool,tmpobj);
            else
                obj -> sEvalPackage = NULL ;
        }
        if ((tmpsv = hv_fetch((HV *)item, "main_sub", sizeof("main_sub") - 1, 0)) || overwrite) {
            char * tmpobj = ((char *)epxs_sv2_PV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)));
            if (tmpobj)
                obj -> sMainSub = (char *)ep_pstrdup(obj->pPool,tmpobj);
            else
                obj -> sMainSub = NULL ;
        }
        if ((tmpsv = hv_fetch((HV *)item, "prog_run", sizeof("prog_run") - 1, 0)) || overwrite) {
            char * tmpobj = ((char *)epxs_sv2_PV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)));
            if (tmpobj)
                obj -> pProgRun = (char *)ep_pstrdup(obj->pPool,tmpobj);
            else
                obj -> pProgRun = NULL ;
        }
        if ((tmpsv = hv_fetch((HV *)item, "prog_def", sizeof("prog_def") - 1, 0)) || overwrite) {
            char * tmpobj = ((char *)epxs_sv2_PV((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)));
            if (tmpobj)
                obj -> pProgDef = (char *)ep_pstrdup(obj->pPool,tmpobj);
            else
                obj -> pProgDef = NULL ;
        }
        if ((tmpsv = hv_fetch((HV *)item, "code", sizeof("code") - 1, 0)) || overwrite) {
            SV * tmpobj = ((SV *)epxs_sv2_SVPTR((tmpsv && *tmpsv?*tmpsv:&PL_sv_undef)));
            if (tmpobj)
                obj -> pCodeSV = (SV *)SvREFCNT_inc(tmpobj);
            else
                obj -> pCodeSV = NULL ;
        }
   ; }

    else
        croak ("initializer for Embperl::Component::new is not a hash or object reference") ;

} ;


MODULE = Embperl::Component    PACKAGE = Embperl::Component   PREFIX = embperl_

int
embperl_cleanup(c)
    Embperl::Component c
CODE:
    RETVAL = embperl_CleanupComponent(c);
OUTPUT:
    RETVAL


MODULE = Embperl::Component    PACKAGE = Embperl::Component   PREFIX = embperl_

int
embperl_run(c)
    Embperl::Component c
CODE:
    RETVAL = embperl_RunComponent(c);
OUTPUT:
    RETVAL


MODULE = Embperl::Component    PACKAGE = Embperl::Component 

Embperl::Component::Config
config(obj, val=NULL)
    Embperl::Component obj
    Embperl::Component::Config val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (Embperl__Component__Config) & obj->Config;
    if (items > 1) {
         croak ("Config is read only") ;
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component    PACKAGE = Embperl::Component 

Embperl::Component::Param
param(obj, val=NULL)
    Embperl::Component obj
    Embperl::Component::Param val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (Embperl__Component__Param) & obj->Param;
    if (items > 1) {
         croak ("Param is read only") ;
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component    PACKAGE = Embperl::Component 

bool
req_running(obj, val=0)
    Embperl::Component obj
    bool val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (bool)  obj->bReqRunning;

    if (items > 1) {
        obj->bReqRunning = (bool) val;
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component    PACKAGE = Embperl::Component 

bool
sub_req(obj, val=0)
    Embperl::Component obj
    bool val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (bool)  obj->bSubReq;

    if (items > 1) {
        obj->bSubReq = (bool) val;
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component    PACKAGE = Embperl::Component 

int
inside_sub(obj, val=0)
    Embperl::Component obj
    int val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (int)  obj->nInsideSub;

    if (items > 1) {
        obj->nInsideSub = (int) val;
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component    PACKAGE = Embperl::Component 

int
had_exit(obj, val=0)
    Embperl::Component obj
    int val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (int)  obj->bExit;

    if (items > 1) {
        obj->bExit = (int) val;
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component    PACKAGE = Embperl::Component 

int
path_ndx(obj, val=0)
    Embperl::Component obj
    int val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (int)  obj->nPathNdx;

    if (items > 1) {
        obj->nPathNdx = (int) val;
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component    PACKAGE = Embperl::Component 

char *
cwd(obj, val=NULL)
    Embperl::Component obj
    char * val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (char *)  obj->sCWD;

    if (items > 1) {
        obj->sCWD = (char *)ep_pstrdup(obj->pPool,val);
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component    PACKAGE = Embperl::Component 

bool
ep1_compat(obj, val=0)
    Embperl::Component obj
    bool val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (bool)  obj->bEP1Compat;

    if (items > 1) {
        obj->bEP1Compat = (bool) val;
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component    PACKAGE = Embperl::Component 

int
phase(obj, val=0)
    Embperl::Component obj
    int val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (int)  obj->nPhase;

    if (items > 1) {
        obj->nPhase = (int) val;
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component    PACKAGE = Embperl::Component 

char *
sourcefile(obj, val=NULL)
    Embperl::Component obj
    char * val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (char *)  obj->sSourcefile;

    if (items > 1) {
        obj->sSourcefile = (char *)ep_pstrdup(obj->pPool,val);
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component    PACKAGE = Embperl::Component 

char *
buf(obj, val=NULL)
    Embperl::Component obj
    char * val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (char *)  obj->pBuf;

    if (items > 1) {
        obj->pBuf = (char *)ep_pstrdup(obj->pPool,val);
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component    PACKAGE = Embperl::Component 

char *
end_pos(obj, val=NULL)
    Embperl::Component obj
    char * val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (char *)  obj->pEndPos;

    if (items > 1) {
        obj->pEndPos = (char *)ep_pstrdup(obj->pPool,val);
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component    PACKAGE = Embperl::Component 

char *
curr_pos(obj, val=NULL)
    Embperl::Component obj
    char * val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (char *)  obj->pCurrPos;

    if (items > 1) {
        obj->pCurrPos = (char *)ep_pstrdup(obj->pPool,val);
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component    PACKAGE = Embperl::Component 

int
sourceline(obj, val=0)
    Embperl::Component obj
    int val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (int)  obj->nSourceline;

    if (items > 1) {
        obj->nSourceline = (int) val;
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component    PACKAGE = Embperl::Component 

char *
sourceline_pos(obj, val=NULL)
    Embperl::Component obj
    char * val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (char *)  obj->pSourcelinePos;

    if (items > 1) {
        obj->pSourcelinePos = (char *)ep_pstrdup(obj->pPool,val);
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component    PACKAGE = Embperl::Component 

char *
line_no_curr_pos(obj, val=NULL)
    Embperl::Component obj
    char * val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (char *)  obj->pLineNoCurrPos;

    if (items > 1) {
        obj->pLineNoCurrPos = (char *)ep_pstrdup(obj->pPool,val);
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component    PACKAGE = Embperl::Component 

tNode
document(obj, val=0)
    Embperl::Component obj
    tNode val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (tNode)  obj->xDocument;

    if (items > 1) {
        obj->xDocument = (tNode) val;
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component    PACKAGE = Embperl::Component 

tNode
curr_node(obj, val=0)
    Embperl::Component obj
    tNode val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (tNode)  obj->xCurrNode;

    if (items > 1) {
        obj->xCurrNode = (tNode) val;
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component    PACKAGE = Embperl::Component 

tRepeatLevel
curr_repeat_level(obj, val=0)
    Embperl::Component obj
    tRepeatLevel val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (tRepeatLevel)  obj->nCurrRepeatLevel;

    if (items > 1) {
        obj->nCurrRepeatLevel = (tRepeatLevel) val;
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component    PACKAGE = Embperl::Component 

tIndex
curr_checkpoint(obj, val=0)
    Embperl::Component obj
    tIndex val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (tIndex)  obj->nCurrCheckpoint;

    if (items > 1) {
        obj->nCurrCheckpoint = (tIndex) val;
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component    PACKAGE = Embperl::Component 

tIndex
curr_dom_tree(obj, val=0)
    Embperl::Component obj
    tIndex val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (tIndex)  obj->xCurrDomTree;

    if (items > 1) {
        obj->xCurrDomTree = (tIndex) val;
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component    PACKAGE = Embperl::Component 

tIndex
source_dom_tree(obj, val=0)
    Embperl::Component obj
    tIndex val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (tIndex)  obj->xSourceDomTree;

    if (items > 1) {
        obj->xSourceDomTree = (tIndex) val;
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component    PACKAGE = Embperl::Component 

Embperl::Syntax
syntax(obj, val=NULL)
    Embperl::Component obj
    Embperl::Syntax val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (Embperl__Syntax)  obj->pTokenTable;

    if (items > 1) {
        obj->pTokenTable = (Embperl__Syntax) val;
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component    PACKAGE = Embperl::Component 

SV *
ifdobj(obj, val=NULL)
    Embperl::Component obj
    SV * val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (SV *)  obj->ifdobj;

    if (items > 1) {
        obj->ifdobj = (SV *)SvREFCNT_inc(val);
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component    PACKAGE = Embperl::Component 

bool
append_to_main_req(obj, val=0)
    Embperl::Component obj
    bool val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (bool)  obj->bAppendToMainReq;

    if (items > 1) {
        obj->bAppendToMainReq = (bool) val;
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component    PACKAGE = Embperl::Component 

Embperl::Component
prev(obj, val=NULL)
    Embperl::Component obj
    Embperl::Component val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (Embperl__Component)  obj->pPrev;

    if (items > 1) {
        obj->pPrev = (Embperl__Component) val;
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component    PACKAGE = Embperl::Component 

int
strict(obj, val=0)
    Embperl::Component obj
    int val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (int)  obj->bStrict;

    if (items > 1) {
        obj->bStrict = (int) val;
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component    PACKAGE = Embperl::Component 

HV *
import_stash(obj, val=NULL)
    Embperl::Component obj
    HV * val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (HV *)  obj->pImportStash;

    if (items > 1) {
        obj->pImportStash = (HV *)SvREFCNT_inc(val);
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component    PACKAGE = Embperl::Component 

HV *
exports(obj, val=NULL)
    Embperl::Component obj
    HV * val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (HV *)  obj->pExportHash;

    if (items > 1) {
        obj->pExportHash = (HV *)SvREFCNT_inc(val);
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component    PACKAGE = Embperl::Component 

char *
curr_package(obj, val=NULL)
    Embperl::Component obj
    char * val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (char *)  obj->sCurrPackage;

    if (items > 1) {
        obj->sCurrPackage = (char *)ep_pstrdup(obj->pPool,val);
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component    PACKAGE = Embperl::Component 

char *
eval_package(obj, val=NULL)
    Embperl::Component obj
    char * val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (char *)  obj->sEvalPackage;

    if (items > 1) {
        obj->sEvalPackage = (char *)ep_pstrdup(obj->pPool,val);
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component    PACKAGE = Embperl::Component 

char *
main_sub(obj, val=NULL)
    Embperl::Component obj
    char * val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (char *)  obj->sMainSub;

    if (items > 1) {
        obj->sMainSub = (char *)ep_pstrdup(obj->pPool,val);
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component    PACKAGE = Embperl::Component 

char *
prog_run(obj, val=NULL)
    Embperl::Component obj
    char * val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (char *)  obj->pProgRun;

    if (items > 1) {
        obj->pProgRun = (char *)ep_pstrdup(obj->pPool,val);
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component    PACKAGE = Embperl::Component 

char *
prog_def(obj, val=NULL)
    Embperl::Component obj
    char * val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (char *)  obj->pProgDef;

    if (items > 1) {
        obj->pProgDef = (char *)ep_pstrdup(obj->pPool,val);
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component    PACKAGE = Embperl::Component 

SV *
code(obj, val=NULL)
    Embperl::Component obj
    SV * val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (SV *)  obj->pCodeSV;

    if (items > 1) {
        obj->pCodeSV = (SV *)SvREFCNT_inc(val);
    }
  OUTPUT:
    RETVAL

MODULE = Embperl::Component    PACKAGE = Embperl::Component 



SV *
new (class,initializer=NULL)
    char * class
    SV * initializer 
PREINIT:
    SV * svobj ;
    Embperl__Component  cobj ;
    SV * tmpsv ;
CODE:
    epxs_Embperl__Component_create_obj(cobj,svobj,RETVAL,malloc(sizeof(*cobj))) ;

    if (initializer) {
        if (!SvROK(initializer) || !(tmpsv = SvRV(initializer))) 
            croak ("initializer for Embperl::Component::new is not a reference") ;

        if (SvTYPE(tmpsv) == SVt_PVHV || SvTYPE(tmpsv) == SVt_PVMG)  
            Embperl__Component_new_init (aTHX_ cobj, tmpsv, 0) ;
        else if (SvTYPE(tmpsv) == SVt_PVAV) {
            int i ;
            SvGROW(svobj, sizeof (*cobj) * av_len((AV *)tmpsv)) ;     
            for (i = 0; i <= av_len((AV *)tmpsv); i++) {
                SV * * itemrv = av_fetch((AV *)tmpsv, i, 0) ;
                SV * item ;
                if (!itemrv || !*itemrv || !SvROK(*itemrv) || !(item = SvRV(*itemrv))) 
                    croak ("array element of initializer for Embperl::Component::new is not a reference") ;
                Embperl__Component_new_init (aTHX_ &cobj[i], item, 1) ;
            }
        }
        else {
             croak ("initializer for Embperl::Component::new is not a hash/array/object reference") ;
        }
    }
OUTPUT:
    RETVAL 

MODULE = Embperl::Component    PACKAGE = Embperl::Component 



void
DESTROY (obj)
    Embperl::Component  obj 
CODE:
    Embperl__Component_destroy (aTHX_ obj) ;

PROTOTYPES: disabled

BOOT:
    items = items; /* -Wall */

