/*###################################################################################
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
#   $Id: eplibxslt.c,v 1.1.2.17 2002/02/25 11:20:28 richter Exp $
#
###################################################################################*/


#include "../ep.h"
#include "../epmacro.h"

#include <libxml/xmlmemory.h>
#include <libxml/debugXML.h>
#include <libxml/HTMLtree.h>
#include <libxml/xmlIO.h>
#include <libxml/DOCBparser.h>
#include <libxml/xinclude.h>
#include <libxml/catalog.h>
#include <libxslt/xsltconfig.h>
#include <libxslt/xslt.h>
#include <libxslt/xsltInternals.h>
#include <libxslt/transform.h>
#include <libxslt/xsltutils.h>

#ifdef WIN32
extern __declspec( dllimport ) int xmlLoadExtDtdDefaultValue;
#else
extern int xmlLoadExtDtdDefaultValue;
#endif

/* ------------------------------------------------------------------------ */
/*                                                                          */
/* iowrite                                                                  */
/*                                                                          */
/* output callback                                                          */
/*                                                                          */
/* ------------------------------------------------------------------------ */

static int  iowrite   (void *context,
                const char *buffer,
                int len)

    {
    return owrite ((tReq *)context, buffer, len) ;
    }


/* ------------------------------------------------------------------------ */
/*                                                                          */
/* embperl_LibXSLT_Text2Text                                                */
/*                                                                          */
/* Do an XSL transformation using LibXSLT. Input and Output is Text.        */
/* The stylesheet is directly read from disk                                */
/*                                                                          */
/* in   pReqParameter   Parameter for request                               */
/*          xsltparameter   Hash which is passed as parameters to libxslt   */
/*          xsltstylesheet  filename of stylsheet                           */
/*      pSource         XML source in memory                                */
/*                                                                          */
/* ------------------------------------------------------------------------ */



int embperl_LibXSLT_Text2Text   (/*in*/  tReq *	  r,
                                 /*in*/  HV *     pReqParameter,
                                 /*in*/  SV *     pSource)

    {
    epTHX_
    xsltStylesheetPtr cur = NULL;
    xmlDocPtr	    doc ;
    xmlDocPtr	    res;
    HE *	    pEntry ;
    HV *            pParam ;
    SV * *          ppSV ;
    char *	    pKey ;
    SV *            pValue ;
    STRLEN          len ;
    IV              l ;
    int		    n ;
    const char * *  pParamArray ;
    const char *    sStylesheet ;
    char *          p ;
    xmlOutputBufferPtr obuf ;

    sStylesheet = GetHashValueStr (aTHX_ pReqParameter, "xsltstylesheet", r -> Component.Config.sXsltstylesheet) ;
    if (!sStylesheet)
	{
	strncpy (r -> errdat1, "XSLT", sizeof (r -> errdat1)) ;
	strncpy (r -> errdat2, "No stylesheet given", sizeof (r -> errdat2)) ;
	return 9999 ;
	}

    ppSV = hv_fetch (pReqParameter, "xsltparameter", sizeof("xsltparameter") - 1, 0) ;
    if (ppSV && *ppSV)
	{
	if (!SvROK (*ppSV) || SvTYPE ((SV *)(pParam = (HV *)SvRV (*ppSV))) != SVt_PVHV)
	    {
	    strncpy (r -> errdat1, "XSLT", sizeof (r -> errdat1)) ;
	    sprintf (r -> errdat2, "%s", "xsltparameter") ;
	    return rcNotHashRef ;
	    }

	n = 0 ;
	hv_iterinit (pParam) ;
	while ((pEntry = hv_iternext (pParam)))
	    {
	    n++ ;
	    }
        
	if (!(pParamArray = _malloc(r, sizeof (const char *) * (n + 1) * 2)))
	    return rcOutOfMemory ;

	n = 0 ;
	hv_iterinit (pParam) ;
	while ((pEntry = hv_iternext (pParam)))
	    {
	    pKey     = hv_iterkey (pEntry, &l) ;
	    pValue   = hv_iterval (pParam, pEntry) ;
	    pParamArray[n++] = pKey ;
	    pParamArray[n++] = SvPV (pValue, len) ;
	    }
	pParamArray[n++] = NULL ;
	}
    else
	{
	pParamArray = NULL ;
	}

    xmlSubstituteEntitiesDefault(1);
    xmlLoadExtDtdDefaultValue = 1;
    xmlSetGenericErrorFunc (stderr, NULL) ;
    
    cur = xsltParseStylesheetFile(sStylesheet);
    p   = SvPV (pSource, len) ;
    doc = xmlParseMemory(p, len);
    res = xsltApplyStylesheet(cur, doc, pParamArray);

    
    obuf = xmlOutputBufferCreateIO (iowrite, NULL, r, NULL) ;
    
    xsltSaveResultTo(obuf, res, cur);

    xsltFreeStylesheet(cur);
    xmlFreeDoc(res);
    xmlFreeDoc(doc);

    xsltCleanupGlobals();
    xmlCleanupParser();

    return(0);
    }




/*! Provider that reads compiles LibXSLT stylesheet */

typedef struct tProviderLibXSLTXSL
    {
    tProvider           Provider ;
    } tProviderLibXSLTXSL ;


/* ------------------------------------------------------------------------ */
/*                                                                          */
/* ProviderLibXSLTXSL_New      					            */
/*                                                                          */
/*! 
*   \_en
*   Creates a new LibXSLT stylesheet provider and fills it with data from the hash pParam
*   The resulting provider is put into the cache structure
*   
*   @param  r               Embperl request record
*   @param  pItem           CacheItem which holds the output of the provider
*   @param  pProviderClass  Provider class record
*   @param  pProviderParam  Parameter Hash of this Providers
*                               stylesheet  filename or provider for the
*                                           stylesheet 
*   @param  pParam          All Parameters 
*   @param  nParamIndex       If pParam is an AV, this parameter gives the index into the Array
*   @return                 error code
*   \endif                                                                       
*
*   \_de									   
*   Erzeugt einen neue Provider für LibXSLT Stylesheets. Der ein Zeiger
*   auf den resultierenden Provider wird in die Cachestrutr eingefügt
*   
*   @param  r               Embperl request record
*   @param  pItem           CacheItem welches die Ausgabe des Providers 
*                           speichert
*   @param  pProviderClass  Provider class record
*   @param  pProviderParam  Parameter Hash dieses Providers
*                               stylesheet  dateiname oder provider für das
*                                           stylesheet 
*   @param  pParam          Parameter insgesamt
*   @param  nParamIndex       Wenn pParam ein AV ist, gibt dieser Parameter den Index an
*   @return                 Fehlercode
*   \endif                                                                       
*                                                                          
* ------------------------------------------------------------------------ */

static int ProviderLibXSLTXSL_New (/*in*/ req *              r,
                          /*in*/ tCacheItem *       pItem,
                          /*in*/ tProviderClass *   pProviderClass,
                             /*in*/ HV *               pProviderParam,
                             /*in*/ SV *               pParam,
                             /*in*/ IV                 nParamIndex)


    {
    int                 rc ;
    
    if ((rc = Provider_NewDependOne (r, sizeof(tProviderLibXSLTXSL), "stylesheet", pItem, pProviderClass, pProviderParam, pParam, nParamIndex)) != ok)
        return rc ;

    return ok ;
    }

/* ------------------------------------------------------------------------ */
/*                                                                          */
/* ProviderLibXSLTXSL_AppendKey    					            */
/*                                                                          */
/*! 
*   \_en
*   Append it's key to the keystring. If it depends on anything it must 
*   call Cache_AppendKey for any dependency.
*   
*   @param  r               Embperl request record
*   @param  pProviderClass  Provider class record
*   @param  pProviderParam  Parameter Hash of this Providers
*                               stylesheet  filename or provider for the
*                                           stylesheet 
*   @param  pParam          All Parameters 
*   @param  nParamIndex       If pParam is an AV, this parameter gives the index into the Array
*   @param  pKey            Key to which string should be appended
*   @return                 error code
*   \endif                                                                       
*
*   \_de									   
*   Hängt ein eigenen Schlüssel an den Schlüsselstring an. Wenn irgednwelche
*   Abhänigkeiten bestehen, muß Cache_AppendKey für alle Abhänigkeiten aufgerufen 
*   werden.
*   
*   @param  r               Embperl request record
*   @param  pProviderClass  Provider class record
*   @param  pProviderParam  Parameter Hash dieses Providers
*                               stylesheet  dateiname oder provider für das
*                                           stylesheet 
*   @param  pParam          Parameter insgesamt
*   @param  nParamIndex       Wenn pParam ein AV ist, gibt dieser Parameter den Index an
*   @param  pKey            Schlüssel zu welchem hinzugefügt wird
*   @return                 Fehlercode
*   \endif                                                                       
*                                                                          
* ------------------------------------------------------------------------ */

static int ProviderLibXSLTXSL_AppendKey (/*in*/ req *              r,
                                   /*in*/ tProviderClass *   pProviderClass,
                                      /*in*/ HV *               pProviderParam,
                                      /*in*/ SV *               pParam,
                                      /*in*/ IV                 nParamIndex,
                                   /*i/o*/ SV *              pKey)
    {
    epTHX_
    int          rc ;

    if ((rc = Cache_AppendKey (r, pProviderParam, "stylesheet", pParam, nParamIndex, pKey)) != ok)
        return rc;

    sv_catpv (pKey, "*libxslt-compile-xsl") ;
    return ok ;
    }



/* ------------------------------------------------------------------------ */
/*                                                                          */
/* ProviderLibXSLTXSL_GetContentPtr  				            */
/*                                                                          */
/*! 
*   \_en
*   Get the whole content from the provider. 
*   This gets the stylesheet and compiles it
*   
*   @param  r               Embperl request record
*   @param  pProvider       The provider record
*   @param  pData           Returns the content
*   @param  bUseCache       Set if the content should not recomputed
*   @return                 error code
*   \endif                                                                       
*
*   \_de									   
*   Holt den gesamt Inhalt vom Provider.
*   Die Funktion holt sich das Stylesheet und kompiliert es
*   
*   @param  r               Embperl request record
*   @param  pProvider       The provider record
*   @param  pData           Liefert den Inhalt
*   @param  bUseCache       Gesetzt wenn der Inhalt nicht neu berechnet werden soll
*   @return                 Fehlercode
*   \endif                                                                       
*                                                                          
* ------------------------------------------------------------------------ */



static int ProviderLibXSLTXSL_GetContentPtr     (/*in*/ req *            r,
                                        /*in*/ tProvider *      pProvider,
                                        /*in*/ void * *         pData,
                                        /*in*/ bool             bUseCache)

    {
    epTHX_
    int    rc ;
    char * p ;
    STRLEN len ;
    SV *   pSource ;
    xsltStylesheetPtr cur ;
    xmlDocPtr	    doc ;

    tCacheItem * pFileCache = Cache_GetDependency(r, pProvider -> pCache, 0) ;
    if ((rc = Cache_GetContentSV (r, pFileCache, &pSource, bUseCache)) != ok)
        return rc ;
        
    if (!bUseCache)
        {
        p   = SvPV (pSource, len) ;

        if (p == NULL || len == 0)
	    {
	    strncpy (r -> errdat1, "LibXSLT XML stylesheet", sizeof (r -> errdat1)) ;
	    return rcMissingInput ;
	    }

        if ((doc = xmlParseMemory(p, len)) == NULL)
      	    {
	    Cache_ReleaseContent (r, pFileCache) ;
            strncpy (r -> errdat1, "XSL parse", sizeof (r -> errdat1)) ;
	    return rcLibXSLTError ;
	    }
        ;
	    
        if ((cur = xsltParseStylesheetDoc(doc)) == NULL)
      	    {
            xmlFreeDoc(doc) ;
	    Cache_ReleaseContent (r, pFileCache) ;
            strncpy (r -> errdat1, "XSL compile", sizeof (r -> errdat1)) ;
	    return rcLibXSLTError ;
	    }
    
        *pData = (void *)cur ;
        }

    return ok ;
    }

/* ------------------------------------------------------------------------ */
/*                                                                          */
/* ProviderLibXSLTXSL_FreeContent 		                            */
/*                                                                          */
/*! 
*   \_en
*   Free the cached data
*   
*   @param  r               Embperl request record
*   @param  pProvider       The provider record
*   @return                 error code
*   \endif                                                                       
*
*   \_de									   
*   Gibt die gecachten Daten frei
*   
*   @param  r               Embperl request record
*   @param  pProvider       The provider record
*   @return                 Fehlercode
*   \endif                                                                       
*                                                                          
* ------------------------------------------------------------------------ */



static int ProviderLibXSLTXSL_FreeContent(/*in*/ req *             r,
                                 /*in*/ tCacheItem * pItem)

    {
    xsltStylesheetPtr  pCompiledStylesheet ;
    
    pCompiledStylesheet = (xsltStylesheetPtr)pItem -> pData ;
    if (pCompiledStylesheet)
        xsltFreeStylesheet(pCompiledStylesheet) ;


    return ok ;
    }

/* ------------------------------------------------------------------------ */

static tProviderClass ProviderClassLibXSLTXSL = 
    {   
    "text/*", 
    &ProviderLibXSLTXSL_New, 
    &ProviderLibXSLTXSL_AppendKey, 
    NULL,
    NULL,
    &ProviderLibXSLTXSL_GetContentPtr,
    NULL,
    &ProviderLibXSLTXSL_FreeContent,
    NULL,
    } ;



/*! Provider that reads compiles LibXSLT xml source */

typedef struct tProviderLibXSLTXML
    {
    tProvider           Provider ;
    } tProviderLibXSLTXML ;


/* ------------------------------------------------------------------------ */
/*                                                                          */
/* ProviderLibXSLTXML_New      					            */
/*                                                                          */
/*! 
*   \_en
*   Creates a new LibXSLT xml source provider and fills it with data from the hash pParam
*   The resulting provider is put into the cache structure
*   
*   @param  r               Embperl request record
*   @param  pItem           CacheItem which holds the output of the provider
*   @param  pProviderClass  Provider class record
*   @param  pProviderParam  Parameter Hash of this Providers
*   @param  pParam          All Parameters 
*   @param  nParamIndex       If pParam is an AV, this parameter gives the index into the Array
*   @return                 error code
*   \endif                                                                       
*
*   \_de									   
*   Erzeugt einen neue Provider für LibXSLT XML Quellen. Der ein Zeiger
*   auf den resultierenden Provider wird in die Cachestrutr eingefügt
*   
*   @param  r               Embperl request record
*   @param  pItem           CacheItem welches die Ausgabe des Providers 
*                           speichert
*   @param  pProviderClass  Provider class record
*   @param  pProviderParam  Parameter Hash dieses Providers
*   @param  pParam          Parameter insgesamt
*   @param  nParamIndex       Wenn pParam ein AV ist, gibt dieser Parameter den Index an
*   @return                 Fehlercode
*   \endif                                                                       
*                                                                          
* ------------------------------------------------------------------------ */

static int ProviderLibXSLTXML_New (/*in*/ req *              r,
                          /*in*/ tCacheItem *       pItem,
                          /*in*/ tProviderClass *   pProviderClass,
                             /*in*/ HV *               pProviderParam,
                             /*in*/ SV *               pParam,
                             /*in*/ IV                 nParamIndex)


    {
    int                 rc ;
    
    if ((rc = Provider_NewDependOne (r, sizeof(tProviderLibXSLTXML), "source", pItem, pProviderClass, pProviderParam, pParam, nParamIndex)) != ok)
        return rc ;

    return ok ;
    }

/* ------------------------------------------------------------------------ */
/*                                                                          */
/* ProviderFile_AppendKey    					            */
/*                                                                          */
/*! 
*   \_en
*   Append it's key to the keystring. If it depends on anything it must 
*   call Cache_AppendKey for any dependency.
*   
*   @param  r               Embperl request record
*   @param  pProviderClass  Provider class record
*   @param  pProviderParam  Parameter Hash of this Providers
*   @param  pParam          All Parameters 
*   @param  nParamIndex       If pParam is an AV, this parameter gives the index into the Array
*   @param  pKey            Key to which string should be appended
*   @return                 error code
*   \endif                                                                       
*
*   \_de									   
*   Hängt ein eigenen Schlüssel an den Schlüsselstring an. Wenn irgednwelche
*   Abhänigkeiten bestehen, muß Cache_AppendKey für alle Abhänigkeiten aufgerufen 
*   werden.
*   
*   @param  r               Embperl request record
*   @param  pProviderClass  Provider class record
*   @param  pProviderParam  Parameter Hash dieses Providers
*   @param  pParam          Parameter insgesamt
*   @param  nParamIndex       Wenn pParam ein AV ist, gibt dieser Parameter den Index an
*   @param  pKey            Schlüssel zu welchem hinzugefügt wird
*   @return                 Fehlercode
*   \endif                                                                       
*                                                                          
* ------------------------------------------------------------------------ */

static int ProviderLibXSLTXML_AppendKey (/*in*/ req *              r,
                                   /*in*/ tProviderClass *   pProviderClass,
                                      /*in*/ HV *               pProviderParam,
                                      /*in*/ SV *               pParam,
                                      /*in*/ IV                 nParamIndex,
                                   /*i/o*/ SV *              pKey)
    {
    epTHX_
    int          rc ;

    if ((rc = Cache_AppendKey (r, pProviderParam, "source", pParam, nParamIndex, pKey)) != ok)
        return rc;

    sv_catpv (pKey, "*libxslt-parse-xml") ;
    return ok ;
    }


/* ------------------------------------------------------------------------ */
/*                                                                          */
/* ProviderLibXSLTXML_GetContentPtr  				            */
/*                                                                          */
/*! 
*   \_en
*   Get the whole content from the provider. 
*   This gets the stylesheet and compiles it
*   
*   @param  r               Embperl request record
*   @param  pProvider       The provider record
*   @param  pData           Returns the content
*   @param  bUseCache       Set if the content should not recomputed
*   @return                 error code
*   \endif                                                                       
*
*   \_de									   
*   Holt den gesamt Inhalt vom Provider.
*   Die Funktion holt sich das Stylesheet und kompiliert es
*   
*   @param  r               Embperl request record
*   @param  pProvider       The provider record
*   @param  pData           Liefert den Inhalt
*   @param  bUseCache       Gesetzt wenn der Inhalt nicht neu berechnet werden soll
*   @return                 Fehlercode
*   \endif                                                                       
*                                                                          
* ------------------------------------------------------------------------ */



static int ProviderLibXSLTXML_GetContentPtr     (/*in*/ req *            r,
                                        /*in*/ tProvider *      pProvider,
                                        /*in*/ void * *         pData,
                                            /*in*/ bool                bUseCache)

    {
    epTHX_
    int    rc ;
    char * p ;
    STRLEN len ;
    SV *   pSource ;
    xmlDocPtr	    doc ;

    tCacheItem * pFileCache = Cache_GetDependency(r, pProvider -> pCache, 0) ;
    if ((rc = Cache_GetContentSV (r, pFileCache, &pSource, bUseCache)) != ok)
        return rc ;
        
    if (!bUseCache)
        {
        p   = SvPV (pSource, len) ;

        if (p == NULL || len == 0)
	    {
	    strncpy (r -> errdat1, "LibXSLT XML source", sizeof (r -> errdat1)) ;
	    return rcMissingInput ;
	    }

        if ((doc = xmlParseMemory(p, len)) == NULL)
      	    {
	    Cache_ReleaseContent (r, pFileCache) ;
            strncpy (r -> errdat1, "XML parse", sizeof (r -> errdat1)) ;
	    return rcLibXSLTError ;
	    }

        *pData = (void *)doc ;
        }

    return ok ;
    }

/* ------------------------------------------------------------------------ */
/*                                                                          */
/* ProviderLibXSLTXML_FreeContent 		                            */
/*                                                                          */
/*! 
*   \_en
*   Free the cached data
*   
*   @param  r               Embperl request record
*   @param  pProvider       The provider record
*   @return                 error code
*   \endif                                                                       
*
*   \_de									   
*   Gibt die gecachten Daten frei
*   
*   @param  r               Embperl request record
*   @param  pProvider       The provider record
*   @return                 Fehlercode
*   \endif                                                                       
*                                                                          
* ------------------------------------------------------------------------ */



static int ProviderLibXSLTXML_FreeContent(/*in*/ req *             r,
                                 /*in*/ tCacheItem * pItem)

    {
    if (pItem -> pData)
	{
	xmlFreeDoc((xmlDocPtr)pItem -> pData) ;
	}
    return ok ;
    }

/* ------------------------------------------------------------------------ */

static tProviderClass ProviderClassLibXSLTXML = 
    {   
    "text/*", 
    &ProviderLibXSLTXML_New, 
    &ProviderLibXSLTXML_AppendKey, 
    NULL,
    NULL,
    &ProviderLibXSLTXML_GetContentPtr,
    NULL,
    &ProviderLibXSLTXML_FreeContent,
    NULL,
    } ;




/*! Provider that reads compiles LibXSLT stylesheet */

typedef struct tProviderLibXSLT
    {
    tProvider           Provider ;
    SV *                pOutputSV ;
    const char * *      pParamArray ;
    } tProviderLibXSLT ;

/* ------------------------------------------------------------------------ */
/*                                                                          */
/* ProviderLibXSLT_iowrite                                                  */
/*                                                                          */
/* output callback                                                          */
/*                                                                          */
/* ------------------------------------------------------------------------ */

struct iowrite
    {
    tProviderLibXSLT  * pProvider ;
    tReq * pReq ;
    } ;

static  int  ProviderLibXSLT_iowrite   (void *context,
						     const char *buffer,
						     int len)

    {
    tReq * r = ((struct iowrite *)context) -> pReq ;
    epTHX_ 
    
    sv_catpvn (((struct iowrite *)context) -> pProvider -> pOutputSV, (char *)buffer, len) ;
    return len ;
    }


/* ------------------------------------------------------------------------ */
/*                                                                          */
/* ProviderLibXSLT_New      					            */
/*                                                                          */
/*! 
*   \_en
*   Creates a new LibXSLT provider and fills it with data from the hash pParam
*   The resulting provider is put into the cache structure
*   
*   @param  r               Embperl request record
*   @param  pItem           CacheItem which holds the output of the provider
*   @param  pProviderClass  Provider class record
*   @param  pProviderParam  Parameter Hash of this Providers
*                               stylesheet  filename or provider for the
*                                           stylesheet 
*   @param  pParam          All Parameters 
*   @param  nParamIndex       If pParam is an AV, this parameter gives the index into the Array
*   @return                 error code
*   \endif                                                                       
*
*   \_de									   
*   Erzeugt einen neue Provider für LibXSLT.  Der ein Zeiger
*   auf den resultierenden Provider wird in die Cachestrutr eingefügt
*   
*   @param  r               Embperl request record
*   @param  pItem           CacheItem welches die Ausgabe des Providers 
*                           speichert
*   @param  pProviderClass  Provider class record
*   @param  pProviderParam  Parameter Hash dieses Providers
*                               stylesheet  dateiname oder provider für das
*                                           stylesheet 
*   @param  pParam          Parameter insgesamt
*   @param  nParamIndex       Wenn pParam ein AV ist, gibt dieser Parameter den Index an
*   @return                 Fehlercode
*   \endif                                                                       
*                                                                          
* ------------------------------------------------------------------------ */

int ProviderLibXSLT_New (/*in*/ req *              r,
                          /*in*/ tCacheItem *       pItem,
                          /*in*/ tProviderClass *   pProviderClass,
                             /*in*/ HV *               pProviderParam,
                             /*in*/ SV *               pParam,
                             /*in*/ IV                 nParamIndex)


    {
    int                 rc ;
    
    if ((rc = Provider_NewDependOne (r, sizeof(tProviderLibXSLT), "source", pItem, pProviderClass, pProviderParam, pParam, nParamIndex)) != ok)
        return rc ;

    if ((rc = Provider_AddDependOne (r, pItem -> pProvider, "stylesheet", pItem, pProviderClass, pProviderParam, NULL, 0)) != ok)
        return rc ;

    return ok ;
    }

/* ------------------------------------------------------------------------ */
/*                                                                          */
/* ProviderFile_AppendKey    					            */
/*                                                                          */
/*! 
*   \_en
*   Append it's key to the keystring. If it depends on anything it must 
*   call Cache_AppendKey for any dependency.
*   
*   @param  r               Embperl request record
*   @param  pProviderClass  Provider class record
*   @param  pProviderParam  Parameter Hash of this Providers
*                               stylesheet  filename or provider for the
*                                           stylesheet 
*   @param  pParam          All Parameters 
*   @param  nParamIndex       If pParam is an AV, this parameter gives the index into the Array
*   @param  pKey            Key to which string should be appended
*   @return                 error code
*   \endif                                                                       
*
*   \_de									   
*   Hängt ein eigenen Schlüssel an den Schlüsselstring an. Wenn irgednwelche
*   Abhänigkeiten bestehen, muß Cache_AppendKey für alle Abhänigkeiten aufgerufen 
*   werden.
*   
*   @param  r               Embperl request record
*   @param  pProviderClass  Provider class record
*   @param  pProviderParam  Parameter Hash dieses Providers
*                               stylesheet  dateiname oder provider für das
*                                           stylesheet 
*   @param  pParam          Parameter insgesamt
*   @param  nParamIndex       Wenn pParam ein AV ist, gibt dieser Parameter den Index an
*   @param  pKey            Schlüssel zu welchem hinzugefügt wird
*   @return                 Fehlercode
*   \endif                                                                       
*                                                                          
* ------------------------------------------------------------------------ */

static int ProviderLibXSLT_AppendKey (/*in*/ req *              r,
                                   /*in*/ tProviderClass *   pProviderClass,
                                      /*in*/ HV *               pProviderParam,
                                      /*in*/ SV *               pParam,
                                      /*in*/ IV                 nParamIndex,
                                   /*i/o*/ SV *              pKey)
    {
    epTHX_
    int          rc ;

    if ((rc = Cache_AppendKey (r, pProviderParam, "source", pParam, nParamIndex, pKey)) != ok)
        return rc;

    if ((rc = Cache_AppendKey (r, pProviderParam, "stylesheet", NULL, 0, pKey)) != ok)
        return rc;

    sv_catpv (pKey, "*libxslt") ;
    return ok ;
    }


/* ------------------------------------------------------------------------ */
/*                                                                          */
/* ProviderLibXSLT_UpdateParam   				            */
/*                                                                          */
/*! 
*   \_en
*   Update the parameter of the provider
*   
*   @param  r               Embperl request record
*   @param  pProvider       Provider record
*   @param  pParam          Parameter Hash
*                               param        hash with parameter 
*   @param  pKey            Key to which string should be appended
*   @return                 error code
*   \endif                                                                       
*
*   \_de									   
*   Aktualisiert die Parameter des Providers
*   
*   @param  r               Embperl request record
*   @param  pProvider       Provider record
*   @param  pParam          Parameter Hash
*                               param        hash mit parametern 
*   @param  pKey            Schlüssel zu welchem hinzugefügt wird
*   @return                 Fehlercode
*   \endif                                                                       
*                                                                          
* ------------------------------------------------------------------------ */

static int ProviderLibXSLT_UpdateParam(/*in*/ req *              r,
                                   /*in*/ tProvider *        pProvider,
                                   /*in*/ HV *               pParam)
    {
    epTHX_
    int		    rc ;
    HV *	    pParamHV ;
    HE *	    pEntry ;
    char *	    pKey ;
    SV *            pValue ;
    STRLEN          len ;
    IV		    l ;
    int		    n ;
    const char * *  pParamArray ;
    
    if ((rc = GetHashValueHREF  (r, pParam, "param", &pParamHV)) != ok)
        {
        pParamHV = r -> Component.Param.pXsltParam ;
        }

    if (((tProviderLibXSLT *)pProvider) -> pParamArray)
	{
	free ((void *)(((tProviderLibXSLT *)pProvider) -> pParamArray)) ;
	((tProviderLibXSLT *)pProvider) -> pParamArray = NULL ;
	}

    if (pParamHV)
	{
	n = hv_iterinit (pParamHV) ;
	lprintf (r -> pApp, "libxslt param number %d\n", n) ;
	if (!(pParamArray = malloc(sizeof (const char *) * (n + 1) * 2)))
	    return rcOutOfMemory ;

	lprintf (r -> pApp, "libxslt param number %d\n", n) ;
	n = 0 ;
	while ((pEntry = hv_iternext (pParamHV)))
	    {
	lprintf (r -> pApp, "libxslt param 2 number %d\n", n) ;
	    pKey     = hv_iterkey (pEntry, &l) ;
	lprintf (r -> pApp, "libxslt param 3 number %d\n", n) ;
	    pValue   = hv_iterval (pParamHV, pEntry) ;
	lprintf (r -> pApp, "libxslt param 4 number %d\n", n) ;
	    pParamArray[n++] = pKey ;
	lprintf (r -> pApp, "libxslt param 5 number %d\n", n) ;
	    pParamArray[n++] = SvPV (pValue, len) ;
	lprintf (r -> pApp, "libxslt param 6 number %d\n", n) ;
	    lprintf (r -> pApp, "libxslt param input %s = %s\n", pParamArray[n-2], pParamArray[n-1]) ;
	    }
	pParamArray[n++] = NULL ;
	lprintf (r -> pApp, "libxslt param 99 number %d\n", n) ;
	((tProviderLibXSLT *)pProvider) -> pParamArray = pParamArray ;
	}
    return ok ;
    }


/* ------------------------------------------------------------------------ */
/*                                                                          */
/* ProviderLibXSLT_GetContentSV	  				            */
/*                                                                          */
/*! 
*   \_en
*   Get the whole content from the provider. 
*   This gets the stylesheet and compiles it
*   
*   @param  r               Embperl request record
*   @param  pProvider       The provider record
*   @param  pData           Returns the content
*   @param  bUseCache       Set if the content should not recomputed
*   @return                 error code
*   \endif                                                                       
*
*   \_de									   
*   Holt den gesamt Inhalt vom Provider.
*   Die Funktion holt sich das Stylesheet und kompiliert es
*   
*   @param  r               Embperl request record
*   @param  pProvider       The provider record
*   @param  pData           Liefert den Inhalt
*   @param  bUseCache       Gesetzt wenn der Inhalt nicht neu berechnet werden soll
*   @return                 Fehlercode
*   \endif                                                                       
*                                                                          
* ------------------------------------------------------------------------ */



static int ProviderLibXSLT_GetContentSV    (/*in*/ req *            r,
                                            /*in*/ tProvider *      pProvider,
                                            /*in*/ SV * *           pData,
                                            /*in*/ bool             bUseCache)

    {
    epTHX_
    int    rc ;
    xsltStylesheetPtr cur ;
    xmlDocPtr	    doc ;
    xmlDocPtr	    res;
    xmlOutputBufferPtr obuf ;
    struct iowrite iowrite ;
    
    tCacheItem * pSrcCache = Cache_GetDependency(r, pProvider -> pCache, 0) ;
    tCacheItem * pXSLCache = Cache_GetDependency(r, pProvider -> pCache, 1) ;

    if ((rc = Cache_GetContentPtr  (r, pSrcCache, (void * *)&doc, bUseCache)) != ok)
        return rc ;

    if ((rc = Cache_GetContentPtr (r, pXSLCache, (void * *)&cur, bUseCache)) != ok)
        return rc ;

    if (!bUseCache)
        {
        if (((tProviderLibXSLT *)pProvider) -> pOutputSV)
            SvREFCNT_dec (((tProviderLibXSLT *)pProvider) -> pOutputSV) ;

        ((tProviderLibXSLT *)pProvider) -> pOutputSV = newSVpv("", 0) ;

        res = xsltApplyStylesheet(cur, doc, ((tProviderLibXSLT *)pProvider) -> pParamArray);
        if(res == NULL)
	    {
	    strncpy (r -> errdat1, "XSLT", sizeof (r -> errdat1)) ;
	    return rcLibXSLTError ;
	    }
    
        iowrite.pProvider = (tProviderLibXSLT *)pProvider ;
        iowrite.pReq = r ;

        obuf = xmlOutputBufferCreateIO (ProviderLibXSLT_iowrite, NULL, &iowrite, NULL) ;
    
        xsltSaveResultTo(obuf, res, cur);

        xmlFreeDoc(res);
        xmlOutputBufferClose (obuf) ;

        *pData = ((tProviderLibXSLT *)pProvider) -> pOutputSV ;
        SvREFCNT_inc(*pData) ;
        }

    return ok ;
    }

/* ------------------------------------------------------------------------ */
/*                                                                          */
/* ProviderLibXSLT_FreeContent 		                            */
/*                                                                          */
/*! 
*   \_en
*   Free the cached data
*   
*   @param  r               Embperl request record
*   @param  pProvider       The provider record
*   @return                 error code
*   \endif                                                                       
*
*   \_de									   
*   Gibt die gecachten Daten frei
*   
*   @param  r               Embperl request record
*   @param  pProvider       The provider record
*   @return                 Fehlercode
*   \endif                                                                       
*                                                                          
* ------------------------------------------------------------------------ */



static int ProviderLibXSLT_FreeContent(/*in*/ req *             r,
                                 /*in*/ tCacheItem * pItem)

    {
    epTHX_
    tProviderLibXSLT * pProvider = ((tProviderLibXSLT *)pItem -> pProvider) ;
    
    if (pProvider -> pOutputSV)
	{
	SvREFCNT_dec (pProvider -> pOutputSV) ;
	pProvider -> pOutputSV = NULL ;
	}
    
    /*
    if (pProvider -> pParamArray)
	{
	free (pProvider -> pParamArray) ;
	pProvider -> pParamArray = NULL ;
	}
    */
    return ok ;
    }

/* ------------------------------------------------------------------------ */

static tProviderClass ProviderClassLibXSLT = 
    {   
    "text/*", 
    &ProviderLibXSLT_New, 
    &ProviderLibXSLT_AppendKey, 
    &ProviderLibXSLT_UpdateParam, 
    &ProviderLibXSLT_GetContentSV,
    NULL,
    NULL,
    &ProviderLibXSLT_FreeContent,
    NULL,
    } ;



/* ------------------------------------------------------------------------ */

int embperl_LibXSLT_Init ()
    {
    Cache_AddProviderClass ("libxslt-compile-xsl", &ProviderClassLibXSLTXSL) ;
    Cache_AddProviderClass ("libxslt-parse-xml", &ProviderClassLibXSLTXML) ;
    Cache_AddProviderClass ("libxslt", &ProviderClassLibXSLT) ;

    return ok ;
    }



