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
#   $Id: eppublic.h,v 1.1.2.10 2002/03/02 19:55:46 richter Exp $
#
###################################################################################*/


int embperl_Init        (pTHX_
                         SV *          pApacheSrvSV,
                         SV *          pPerlParam,
                         server_rec *  ap_s) ;

int     embperl_InitRequest ( pTHX_     
                              SV *             pApacheReqSV,
                              SV *             pPerlParam,
                              tReq * *         ppReq) ;

int     embperl_InitRequestComponent ( pTHX_     
                              SV *             pApacheReqSV,
                              SV *             pPerlParam,
                              tReq * *         ppReq) ;

int     embperl_RunRequest (tReq * r) ;
int     embperl_CleanupRequest (tReq *  r) ;

int     embperl_ExecuteRequest  (pTHX_
                                 SV *             pApacheReqSV,
                                 SV *             pPerlParam) ;
int     embperl_SetupComponent  (tReq *                 r,
                                SV *                   pPerlParam,
                                tComponent * *         ppComponent) ;
int     embperl_RunComponent(tComponent *          c) ;

int     embperl_CleanupComponent  (tComponent *          c) ;

int     embperl_ExecuteComponent(tReq *           r,
                                 SV *             pPerlParam) ;


const char * embperl_GetText (tReq *       r, 
                        const char * sMsgId) ;



#define ERRDATLEN 1024

#ifdef WIN32
#define pid_t int
#endif

