/*###################################################################################
#
#   Embperl - Copyright (c) 1997-2002 Gerald Richter / ecos gmbh   www.ecos.de
#
#   You may distribute under the terms of either the GNU General Public
#   License or the Artistic License, as specified in the Perl README file.
#   For use with Apache httpd and mod_perl, see also Apache copyright.
#
#   THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR
#   IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
#   WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
#
#   $Id: epapinit.c,v 1.1.2.30 2002/03/12 05:12:30 richter Exp $
#
###################################################################################*/


#include "ep.h"

#ifdef APACHE



/* define config prototypes */

static void embperl_ApacheInit (server_rec *s, pool *p) ;
static void embperl_ApacheInitCleanup (void * p) ;

#define EPCFG_STR EPCFG
#define EPCFG_INT EPCFG
#define EPCFG_BOOL EPCFG
#define EPCFG_CHAR EPCFG

#define EPCFG_CV EPCFG_SAVE
#define EPCFG_SV EPCFG_SAVE
#define EPCFG_HV EPCFG_SAVE
#define EPCFG_REGEX EPCFG_SAVE
#define EPCFG_AV(STRUCT,TYPE,NAME,CFGNAME,SEPARATOR) EPCFG_SAVE(STRUCT,TYPE,NAME,CFGNAME)

#define EPCFG_APP    
#define EPCFG_REQ   
#define EPCFG_COMPONENT   


#define EPCFG(STRUCT,TYPE,NAME,CFGNAME)   int  set_##STRUCT##NAME:1 ;
#define EPCFG_SAVE(STRUCT,TYPE,NAME,CFGNAME)  \
     int  set_##STRUCT##NAME:1 ; \
     char *  save_##STRUCT##NAME ; 

struct tApacheDirConfig
    {
    tPerlInterpreter * pPerlTHX ;                  /* pointer to Perl interpreter */
    tAppConfig       AppConfig ;
    tReqConfig       ReqConfig ;
    tComponentConfig ComponentConfig ;
    int              bUseEnv ;
    /* flags if config directive is given in context */
#include "epcfg.h"
    }  ;

#ifdef PERL_IMPLICIT_CONTEXT
#define epdcTHX_ pTHX = pDirCfg -> pPerlTHX ;
#else
#define epdcTHX_
#endif


#undef EPCFG_SAVE
#define EPCFG_SAVE EPCFG
#undef EPCFG 
#define EPCFG(STRUCT,TYPE,NAME,CFGNAME) \
    char * embperl_Apache_Config_##STRUCT##NAME (cmd_parms *cmd, tApacheDirConfig * pDirCfg, char *  arg) ;

#include "epcfg.h"

/* define config data structure */
#undef EPCFG
#undef EPCFG_SAVE
#define EPCFG_SAVE EPCFG
#define EPCFG(STRUCT,TYPE,NAME,CFGNAME) \
    { "EMBPERL_"#CFGNAME,   embperl_Apache_Config_##STRUCT##NAME,   NULL, RSRC_CONF | OR_OPTIONS, TAKE1, "" },

static char * embperl_Apache_Config_useenv (cmd_parms *cmd, tApacheDirConfig * pDirCfg, bool arg) ;
static void *embperl_create_dir_config(pool *p, char *d) ;
static void *embperl_create_server_config(pool *p, server_rec *s) ;
static void *embperl_merge_dir_config (pool *p, void *basev, void *addv) ;

static const command_rec embperl_cmds[] =
{
#include "epcfg.h"
    
    {"EMBPERL_USEENV", embperl_Apache_Config_useenv, NULL, RSRC_CONF, FLAG, ""},
    {NULL}
};






/* static module MODULE_VAR_EXPORT embperl_module = { */
static module embperl_module = {
    STANDARD_MODULE_STUFF,
    embperl_ApacheInit,         /* initializer */
    embperl_create_dir_config,  /* dir config creater */
    embperl_merge_dir_config,   /* dir merger --- default is to override */
    embperl_create_server_config, /* server config */
    embperl_merge_dir_config,   /* merge server configs */
    embperl_cmds,               /* command table */
    NULL,                       /* handlers */
    NULL,                       /* filename translation */
    NULL,                       /* check_user_id */
    NULL,                       /* check auth */
    NULL,                       /* check access */
    NULL,                       /* type_checker */
    NULL,			/* fixups */
    NULL,                       /* logger */
    NULL,                       /* header parser */
    NULL,                       /* child_init */
    NULL,                       /* child_exit */
    NULL                        /* post read-request */
};






void embperl_ApacheAddModule ()

    {
    if (!ap_find_linked_module("embperl.c"))
        {
	embperl_module.name = "embperl.c" ;
        ap_add_module (&embperl_module) ;
        }
    }


static void embperl_ApacheInit (server_rec *s, pool *p)

    {
    int    rc ;
    pool * subpool = ap_make_sub_pool(p);
    dTHX ;
    
    ap_register_cleanup(subpool, NULL, embperl_ApacheInitCleanup, embperl_ApacheInitCleanup);
    ap_add_version_component ("Embperl/"VERSION) ;

    if ((rc = embperl_Init (aTHX_ NULL, NULL, s)) != ok)
        {
        fprintf ((FILE *)stderr, "Initialization of Embperl failed (#%d)\n", rc) ;
        }
    }

static void embperl_ApacheInitCleanup (void * p)

    {
    module * m ;
    /* make sure embperl module is removed before mod_perl in case mod_perl is loaded dynamicly*/
    if (m = ap_find_linked_module("mod_perl.c"))
        if (m -> dynamic_load_handle)
            ap_remove_module (&embperl_module) ; 
    }



static void *embperl_create_dir_config(pool *p, char *d)
    {
    tApacheDirConfig *cfg = (tApacheDirConfig *) ap_pcalloc(p, sizeof(tApacheDirConfig));

    embperl_DefaultReqConfig (&cfg -> ReqConfig) ;
    embperl_DefaultAppConfig (&cfg -> AppConfig) ;
    embperl_DefaultComponentConfig (&cfg -> ComponentConfig) ;
    cfg -> bUseEnv = -1 ; 

    return cfg;
    }



static void *embperl_create_server_config(pool *p, server_rec *s)
    {
    tApacheDirConfig *cfg = (tApacheDirConfig *) ap_pcalloc(p, sizeof(tApacheDirConfig));

    embperl_DefaultReqConfig (&cfg -> ReqConfig) ;
    embperl_DefaultAppConfig (&cfg -> AppConfig) ;
    embperl_DefaultComponentConfig (&cfg -> ComponentConfig) ;
    cfg -> bUseEnv = -1 ; 

    return cfg;
    }


#define EPCFG_APP    
#define EPCFG_REQ   
#define EPCFG_COMPONENT   

#undef EPCFG_STR
#undef EPCFG_INT
#undef EPCFG_BOOL
#undef EPCFG_CHAR
#undef EPCFG_CV
#undef EPCFG_SV
#undef EPCFG_HV
#undef EPCFG_AV
#undef EPCFG_REGEX

#define EPCFG_STR EPCFG
#define EPCFG_INT EPCFG
#define EPCFG_BOOL EPCFG
#define EPCFG_CHAR EPCFG

#define EPCFG_CV EPCFG_SAVE
#define EPCFG_SV EPCFG_SAVE
#define EPCFG_HV EPCFG_SAVE
#define EPCFG_REGEX EPCFG_SAVE
#define EPCFG_AV(STRUCT,TYPE,NAME,CFGNAME,SEPARATOR) EPCFG_SAVE(STRUCT,TYPE,NAME,CFGNAME)

#undef EPCFG
#define EPCFG(STRUCT,TYPE,NAME,CFGNAME)  \
    if (add -> set_##STRUCT##NAME) \
        { \
        mrg -> set_##STRUCT##NAME = 1 ; \
        mrg -> STRUCT.NAME = add -> STRUCT.NAME ; \
        }

#undef EPCFG_SAVE
#define EPCFG_SAVE(STRUCT,TYPE,NAME,CFGNAME)  \
    if (add -> set_##STRUCT##NAME) \
        { \
        mrg -> set_##STRUCT##NAME = 1 ; \
        mrg -> STRUCT.NAME = add -> STRUCT.NAME ; \
        mrg -> save_##STRUCT##NAME = add -> save_##STRUCT##NAME ; \
        }



static void *embperl_merge_dir_config (pool *p, void *basev, void *addv)
    {
    tApacheDirConfig *mrg = (tApacheDirConfig *)ap_palloc (p, sizeof(tApacheDirConfig));
    tApacheDirConfig *base = (tApacheDirConfig *)basev;
    tApacheDirConfig *add = (tApacheDirConfig *)addv;

    memcpy (mrg, base, sizeof (*mrg)) ;

#include "epcfg.h" 

    if (add -> bUseEnv >= 0)
        base -> bUseEnv = add -> bUseEnv ;

    return mrg ;
    }





static char * embperl_Apache_Config_useenv (cmd_parms *cmd, tApacheDirConfig * pDirCfg, bool arg)
    { \
    pDirCfg -> bUseEnv = arg ; 
    return NULL; \
    } 


int embperl_GetApacheConfig (/*in*/ tThreadData * pThread,
                            /*in*/  request_rec * r,
                            /*in*/  server_rec * s,
                            /*out*/ tApacheDirConfig * * ppConfig)

    {
    *ppConfig = NULL ;
    if (embperl_module.module_index >= 0)
        {
        if(r && r->per_dir_config)
            {
            *ppConfig = (tApacheDirConfig *) get_module_config(r->per_dir_config, &embperl_module);
            }
        else if(s && s->lookup_defaults) /*s->module_config)*/
            {
            *ppConfig = (tApacheDirConfig *) get_module_config(s->lookup_defaults /*s->module_config*/, &embperl_module);
            }
        }
    return ok ;
    }

char * embperl_GetApacheAppName (/*in*/ tApacheDirConfig * pDirCfg)


    {
    return pDirCfg?pDirCfg -> AppConfig.sAppName:"Embperl" ;
    }


/* --- functions for converting string to Perl structures --- */

#undef EPCFG_STR
#undef EPCFG_INT
#undef EPCFG_BOOL
#undef EPCFG_CHAR
#define EPCFG_STR EPCFG
#define EPCFG_INT EPCFG
#define EPCFG_BOOL EPCFG
#define EPCFG_CHAR EPCFG
#undef EPCFG
#define EPCFG(STRUCT,TYPE,NAME,CFGNAME) 


#undef EPCFG_SV
#define EPCFG_SV(STRUCT,TYPE,NAME,CFGNAME) \
    if (pDirCfg -> save_##STRUCT##NAME && !pDirCfg -> STRUCT.NAME) \
        pDirCfg -> STRUCT.NAME = newSVpv((char *)pDirCfg -> save_##STRUCT##NAME, 0) ; 


#undef EPCFG_CV
#define EPCFG_CV(STRUCT,TYPE,NAME,CFGNAME) \
    if (pDirCfg -> save_##STRUCT##NAME && !pDirCfg -> STRUCT.NAME) \
        { \
        int rc ;\
        if ((rc = EvalConfig (pApp, sv_2mortal(newSVpv(pDirCfg -> save_##STRUCT##NAME, 0)), 0, NULL, "Configuration: EMBPERL_"#CFGNAME, &pDirCfg -> STRUCT.NAME)) != ok) \
            LogError (pReq, rc) ; \
            return rc ; \
        }


#undef EPCFG_AV
#define EPCFG_AV(STRUCT,TYPE,NAME,CFGNAME,SEPARATOR) \
    if (pDirCfg -> save_##STRUCT##NAME && !pDirCfg -> STRUCT.NAME) \
        { \
        pDirCfg -> STRUCT.NAME = embperl_String2AV(pApp, pDirCfg -> save_##STRUCT##NAME, SEPARATOR) ;\
        tainted = 0 ; \
        } 

  
#undef EPCFG_HV
#define EPCFG_HV(STRUCT,TYPE,NAME,CFGNAME) \
    if (pDirCfg -> save_##STRUCT##NAME && !pDirCfg -> STRUCT.NAME) \
        { \
        pDirCfg -> STRUCT.NAME = embperl_String2HV(pApp, pDirCfg -> save_##STRUCT##NAME, ' ', NULL) ;\
        tainted = 0 ; \
        } 
    

#undef EPCFG_REGEX
#define EPCFG_REGEX(STRUCT,TYPE,NAME,CFGNAME) \
    if (pDirCfg -> save_##STRUCT##NAME && !pDirCfg -> STRUCT.NAME) \
        { \
        int rc ; \
        if ((rc = EvalRegEx (pApp, pDirCfg -> save_##STRUCT##NAME, "Configuration: EMBPERL_"#CFGNAME, &pDirCfg -> STRUCT.NAME)) != ok) \
            return rc ; \
        tainted = 0 ; \
        } 



int embperl_GetApacheAppConfig (/*in*/ tThreadData * pThread,
                                /*in*/ tMemPool    * pPool,
                                /*in*/ tApacheDirConfig * pDirCfg,
                                /*out*/ tAppConfig * pConfig)


    {
    eptTHX_
    tApp * pApp = NULL ;
    if(pDirCfg)
        {
#define EPCFG_APP    
#undef EPCFG_REQ   
#undef EPCFG_COMPONENT   

#include "epcfg.h"         
        
        memcpy (&pConfig -> pPool + 1, &pDirCfg -> AppConfig.pPool + 1, sizeof (*pConfig) - ((tUInt8 *)(&pConfig -> pPool) - (tUInt8 *)pConfig) - sizeof (pConfig -> pPool)) ;
        pConfig -> bDebug = pDirCfg -> ComponentConfig.bDebug ;
        if (pConfig -> pSessionArgs)
            SvREFCNT_inc(pConfig -> pSessionArgs);
        if (pConfig -> pSessionClasses)
            SvREFCNT_inc(pConfig -> pSessionClasses);
        if (pConfig -> pObjectAddpathAV)
            SvREFCNT_inc(pConfig -> pObjectAddpathAV);
        
        if (pDirCfg -> bUseEnv)
             embperl_GetCGIAppConfig (pThread, pPool, pConfig, 1, 0, 0) ;
        }
    else
        embperl_DefaultAppConfig (pConfig) ;

    return ok ;
    }


int embperl_GetApacheReqConfig (/*in*/ tApp *        pApp,
                                /*in*/ tMemPool    * pPool,
                                /*in*/ tApacheDirConfig * pDirCfg,
                                /*out*/ tReqConfig * pConfig)


    {
#define a pApp
    epaTHX_
#undef a

    if(pDirCfg)
        {
#undef EPCFG_APP    
#define EPCFG_REQ   
#undef EPCFG_COMPONENT   

#include "epcfg.h"         

        memcpy (&pConfig -> pPool + 1, &pDirCfg -> ReqConfig.pPool + 1, sizeof (*pConfig) - ((tUInt8 *)(&pConfig -> pPool) - (tUInt8 *)pConfig) - sizeof (pConfig -> pPool)) ;
        pConfig -> bDebug = pDirCfg -> ComponentConfig.bDebug ;
        pConfig -> bOptions = pDirCfg -> ComponentConfig.bOptions ;
        if (pConfig -> pAllow)
            SvREFCNT_inc(pConfig -> pAllow);
        if (pConfig -> pPathAV)
            SvREFCNT_inc(pConfig -> pPathAV);
        
        if (pDirCfg -> bUseEnv)
             embperl_GetCGIReqConfig (pApp, pPool, pConfig, 1, 0, 0) ;
        }
    else
        embperl_DefaultReqConfig (pConfig) ;
    pConfig -> bOptions |= optSendHttpHeader ;

    return ok ;
    }

int embperl_GetApacheComponentConfig (/*in*/ tReq * pReq,
                                /*in*/ tMemPool    * pPool,
                                /*in*/ tApacheDirConfig * pDirCfg,
                                /*out*/ tComponentConfig * pConfig)


    {

    if(pDirCfg)
        {
    #define r pReq
        epTHX_
    #undef r
        tApp * pApp = pReq -> pApp ;

#undef EPCFG_APP    
#undef EPCFG_REQ   
#define EPCFG_COMPONENT   

#include "epcfg.h"         

        memcpy (&pConfig -> pPool + 1, &pDirCfg -> ComponentConfig.pPool + 1, sizeof (*pConfig) - ((tUInt8 *)(&pConfig -> pPool) - (tUInt8 *)pConfig) - sizeof (pConfig -> pPool)) ;
        if (pConfig -> pExpiredFunc)
            SvREFCNT_inc(pConfig -> pExpiredFunc);
        if (pConfig -> pCacheKeyFunc)
            SvREFCNT_inc(pConfig -> pCacheKeyFunc);
        if (pConfig -> pRecipe)
            SvREFCNT_inc(pConfig -> pRecipe);

        if (pDirCfg -> bUseEnv)
             embperl_GetCGIComponentConfig (pReq, pPool, pConfig, 1, 0, 0) ;
        }
    else
        embperl_DefaultComponentConfig (pConfig) ;

    return ok ;
    }

struct addcookie
    {
    tApp * pApp ;
    tReqParam * pParam ;
    } ;

static int embperl_AddCookie (/*in*/ void * s, const char * pKey, const char * pValue)

    {
    tApp * a = ((struct addcookie *)s) -> pApp ;
    epaTHX_ 
    HV *   pHV ;
        
    if (!(pHV = ((struct addcookie *)s) -> pParam -> pCookies))    
        pHV = ((struct addcookie *)s) -> pParam -> pCookies = newHV () ;

    embperl_String2HV(a, pValue, ';', pHV) ;

    return 1 ;
    }


int embperl_GetApacheReqParam  (/*in*/  tApp        * pApp,
                                /*in*/ tMemPool    * pPool,
                                /*in*/  request_rec * r,
                                /*out*/ tReqParam * pParam)


    {
    tApp * a = pApp ;
    epaTHX_
    char * p ;
    struct addcookie s = { a, pParam} ;

    pParam -> sFilename    = r -> filename ;
    pParam -> sUnparsedUri = r -> unparsed_uri ;
    pParam -> sUri         = r -> uri ;
    pParam -> sPathInfo    = r -> path_info ;
    pParam -> sQueryInfo   = r -> args ;  
    if (p = ep_pstrdup (pPool, ap_table_get (r -> headers_in, "Accept-Language")))
        {
        while (isspace(*p))
            p++ ;
        pParam -> sLanguage = p ;
        while (isalpha(*p))
            p++ ;
        *p = '\0' ;
        }

    ap_table_do (embperl_AddCookie, &s, r -> headers_in, "Cookie", NULL) ;
    
    return ok ;
    }




/* --- functions for apache config cmds --- */


#undef EPCFG
#undef EPCFG_INT
#define EPCFG_INT(STRUCT,TYPE,NAME,CFGNAME) \
char * embperl_Apache_Config_##STRUCT##NAME (cmd_parms *cmd, tApacheDirConfig * pDirCfg, char * arg) \
    { \
    pDirCfg -> STRUCT.NAME = (TYPE)strtol(arg, NULL, 0) ; \
    pDirCfg -> set_##STRUCT##NAME = 1 ; \
    return NULL; \
    } 

#undef EPCFG_BOOL
#define EPCFG_BOOL(STRUCT,TYPE,NAME,CFGNAME) \
char * embperl_Apache_Config_##STRUCT##NAME (cmd_parms *cmd, tApacheDirConfig * pDirCfg, char * arg) \
    { \
    pDirCfg -> STRUCT.NAME = (TYPE)arg ; \
    pDirCfg -> set_##STRUCT##NAME = 1 ; \
    return NULL; \
    } 


#undef EPCFG_STR
#define EPCFG_STR(STRUCT,TYPE,NAME,CFGNAME) \
char * embperl_Apache_Config_##STRUCT##NAME (cmd_parms *cmd, tApacheDirConfig * pDirCfg, char* arg) \
    { \
    pool * p = cmd -> pool ;    \
    pDirCfg -> STRUCT.NAME = ap_pstrdup(p, arg) ; \
    pDirCfg -> set_##STRUCT##NAME = 1 ; \
    return NULL; \
    } 

#undef EPCFG_CHAR
#define EPCFG_CHAR(STRUCT,TYPE,NAME,CFGNAME) \
char * embperl_Apache_Config_##STRUCT##NAME (cmd_parms *cmd, tApacheDirConfig * pDirCfg, char * arg) \
    { \
    pDirCfg -> STRUCT.NAME = (TYPE)arg[0] ; \
    pDirCfg -> set_##STRUCT##NAME = 1 ; \
    return NULL; \
    } 

#undef EPCFG_CV
#undef EPCFG_SV
#undef EPCFG_HV
#undef EPCFG_AV
#undef EPCFG_REGEX
#define EPCFG_CV EPCFG_SAVE
#define EPCFG_SV EPCFG_SAVE
#define EPCFG_HV EPCFG_SAVE
#define EPCFG_REGEX EPCFG_SAVE
#define EPCFG_AV(STRUCT,TYPE,NAME,CFGNAME,SEPARATOR) EPCFG_SAVE(STRUCT,TYPE,NAME,CFGNAME)

#undef EPCFG_SAVE
#define EPCFG_SAVE(STRUCT,TYPE,NAME,CFGNAME) \
char * embperl_Apache_Config_##STRUCT##NAME (cmd_parms *cmd, tApacheDirConfig * pDirCfg, char* arg) \
    { \
    pDirCfg -> save_##STRUCT##NAME = ap_pstrdup(cmd -> pool, arg) ; \
    pDirCfg -> set_##STRUCT##NAME = 1 ; \
    return NULL ; \
    } 

#define EPCFG_APP    
#define EPCFG_REQ   
#define EPCFG_COMPONENT   


#include "epcfg.h"

#endif
