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
#   $Id: epdefault.c,v 1.3 2003/03/30 18:57:02 richter Exp $
#
###################################################################################*/



/*---------------------------------------------------------------------------
* embperl_DefaultAppConfig
*/
/*!
*
* \_en									   
* initialze Config defaults
* \endif                                                                       
*
* \_de									   
* Initialisiert Config Defaults
* \endif                                                                       
*                                                                          
* ------------------------------------------------------------------------ */


static void embperl_DefaultAppConfig (/*in*/ tAppConfig  *pCfg) 

    {
    pCfg -> sAppName    = "Embperl" ;
    pCfg -> sCookieName = "EMBPERL_UID" ;
    pCfg -> sSessionHandlerClass = "Apache::SessionX" ;
#ifdef WIN32
    pCfg -> sLog        = "\\embperl.log" ;
#else
    pCfg -> sLog        = "/tmp/embperl.log" ;
#endif
    pCfg -> bDebug      = dbgStd ;
    pCfg -> nMailErrorsResetTime = 60 ;
    pCfg -> nMailErrorsResendTime = 60 * 15 ;
    }



    
/*---------------------------------------------------------------------------
* embperl_DefaultReqConfig
*/
/*!
*
* \_en									   
* initialze ReqConfig defaults
* \endif                                                                       
*
* \_de									   
* Initialisiert ReqConfig Defaults
* \endif                                                                       
*                                                                          
* ------------------------------------------------------------------------ */


static void embperl_DefaultReqConfig (/*in*/ tReqConfig  *pCfg) 

    {
    pCfg -> cMultFieldSep = '\t' ;
    pCfg -> nSessionMode = smodeUDatCookie ;
    }



/*---------------------------------------------------------------------------
* embperl_DefaultComponentConfig
*/
/*!
*
* \_en									   
* initialze Config defaults
* \endif                                                                       
*
* \_de									   
* Initialisiert Config Defaults
* \endif                                                                       
*                                                                          
* ------------------------------------------------------------------------ */


static void embperl_DefaultComponentConfig (/*in*/ tComponentConfig  *pCfg) 

    {
    pCfg -> bDebug = dbgStd ;
    /* pCfg -> bOptions = optRawInput | optAllFormData ; */
    pCfg -> nEscMode = escStd ;
    pCfg -> bCacheKeyOptions = ckoptDefault ;
    pCfg -> sSyntax = "Embperl" ;
    pCfg -> sInputCharset = "iso-8859-1" ;
#ifdef LIBXSLT
    pCfg -> sXsltproc = "libxslt" ;
#else
#ifdef XALAN
    pCfg -> sXsltproc = "xalan" ;
#endif
#endif
    }
