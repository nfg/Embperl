
MODULE = Embperl      PACKAGE = Embperl     PREFIX = embperl_

PROTOTYPES: ENABLE



# /* ---- Helper ----- */



int
embperl_Multiplicity()
CODE:
#ifdef MULTIPLICITY
    RETVAL = 1 ;
#else
    RETVAL = 0 ;
#endif
OUTPUT:
    RETVAL




#if defined (__GNUC__) && defined (__i386__)

void
embperl_dbgbreak()
CODE:
    __asm__ ("int   $0x03\n") ;

#endif



char *
embperl_GVFile(gv)
    SV * gv
CODE:
    RETVAL = "" ;
#ifdef GvFILE
    if (gv && SvTYPE(gv) == SVt_PVGV && GvGP (gv))
	{
	/*
	char * name = GvFILE (gv) ;
	if (name)
	    RETVAL = name ;
        */
        /* workaround for not working GvFILE in Perl 5.6.1+ with threads */
	if(GvIMPORTED(gv))
            RETVAL = "i" ;
        else
            RETVAL = "" ;
       
        }
#else
    if (gv && SvTYPE(gv) == SVt_PVGV && GvGP (gv))
	{
	GV * fgv = GvFILEGV(gv) ;
	if (fgv && SvTYPE(fgv) == SVt_PVGV)
	    {
	    char * name = GvNAME (fgv) ;
	    if (name)
		RETVAL = name ;
	    }
	}
#endif
OUTPUT:
    RETVAL



#if 0
tReq *
embperl_CurrReq()
CODE:        
    RETVAL = CurrReq ;
OUTPUT:
    RETVAL
 
#endif


double
Clock()
CODE:
#ifdef CLOCKS_PER_SEC
        RETVAL = clock () * 1000 / CLOCKS_PER_SEC / 1000.0 ;
#else
        RETVAL = clock () ;
#endif        
OUTPUT:
    RETVAL




void
embperl_logerror(code, sText, pApacheReqSV=NULL)
    int    code
    char * sText
    SV * pApacheReqSV
PREINIT:
    tReq * r = CurrReq ;
    int  bRestore = 0 ;
#ifdef APACHE
    SV * pSaveApacheReqSV ;
    request_rec * pSaveApacheReq ;
#endif
CODE:
#ifdef APACHE
    if (pApacheReqSV && r -> pApacheReq == NULL)
        {
        bRestore = 1 ;
        pSaveApacheReqSV = r -> pApacheReqSV ;
        pSaveApacheReq = r -> pApacheReq ;
        if (SvROK (pApacheReqSV))
            r -> pApacheReq = (request_rec *)SvIV((SV*)SvRV(pApacheReqSV));
        else
            r -> pApacheReq = NULL ;
        r -> pApacheReqSV = pApacheReqSV ;
        }
#endif
     strncpy (r->errdat1, sText, sizeof (r->errdat1) - 1) ;
     LogError (r,code) ;
#ifdef APACHE
    if (bRestore)
        {
        r -> pApacheReqSV  = pSaveApacheReqSV  ;
        r -> pApacheReq = pSaveApacheReq   ;
        }
#endif



void
embperl_log(sText)
    char * sText
INIT:
    tReq * r = CurrReq ;
CODE:
    lwrite (r->pApp,sText, strlen (sText)) ;


void
embperl_output(sText)
    SV * sText
INIT:
    STRLEN l ;
    tReq * r = CurrReq ;
CODE:
	{
	char * p = SvPV (sText, l) ;
        /*if Node_self(DomTree_self (r -> Component.xCurrDomTree), r -> Component.xCurrNode) -> nType == ntypDocumentFraq)
            Node_appendChild (DomTree_self (r -> Component.xCurrDomTree), r -> Component.xCurrNode, r -> Component.nCurrRepeatLevel, ntypCDATA, 0, p, l, 0, 0, NULL) ; 
                else*/
        r -> Component.xCurrNode = Node_insertAfter_CDATA (r->pApp, p, l, (r -> Component.nCurrEscMode & 3)== 3?1 + (r -> Component.nCurrEscMode & 4):r -> Component.nCurrEscMode, DomTree_self (r -> Component.xCurrDomTree), r -> Component.xCurrNode, r -> Component.nCurrRepeatLevel) ; 
        
        }


int
embperl_getlineno()
INIT:
    tReq * r = CurrReq ;
CODE:
    RETVAL = GetLineNo (r) ;
OUTPUT:
    RETVAL


void
embperl_flushlog()
CODE:
    FlushLog (CurrApp) ;


char *
embperl_Sourcefile()
INIT:
    tReq * r = CurrReq ;
CODE:
    RETVAL = r -> Component.sSourcefile ;
OUTPUT:
    RETVAL



void
embperl_exit()
CODE:
    /* from mod_perl's perl_util.c */
    struct ufuncs umg;
	sv_magic(ERRSV, Nullsv, 'U', (char*) &umg, sizeof(umg));

	ENTER;
	SAVESPTR(diehook);
	diehook = Nullsv; 
	croak("");
	LEAVE; /* we don't get this far, but croak() will rewind */

	sv_unmagic(ERRSV, 'U');



void 
embperl_ClearSymtab(sPackage,bDebug)
    char * sPackage
    int	    bDebug
CODE:
    ClearSymtab (CurrReq, sPackage, bDebug) ;


################################################################################

MODULE = Embperl      PACKAGE = Embperl::Req     PREFIX = embperl_


#if 0
SV *
embperl_ExportHash(r)
    tReq * r
CODE:
    RETVAL = RETVAL ; /* avoid warning */
    if (r -> Buf.pFile && r -> Buf.pFile -> pExportHash)
	{
        ST(0) = newRV_inc((SV *)r -> Buf.pFile -> pExportHash) ;
	if (SvREFCNT(ST(0))) sv_2mortal(ST(0));
	}
    else
        ST(0) = &sv_undef ;


char *
embperl_Sourcefile(r)
    tReq * r
CODE:
    if (r -> Buf.pFile)
        RETVAL = r -> Buf.pFile -> sSourcefile ;
    else
        RETVAL = NULL;
OUTPUT:
    RETVAL

char *
embperl_Path(r,sPath=NULL)
    tReq * r
    char * sPath
CODE:
    RETVAL = NULL;
    if (r -> pConf)
        {
        if (sPath)
            {
            if (r -> pConf -> sPath)
                free (r -> pConf -> sPath) ;
            r -> pConf -> sPath = sstrdup (sPath) ;
            }
        if (r -> pConf -> sPath)
            RETVAL = r -> pConf -> sPath ;
        }
OUTPUT:
    RETVAL


int
embperl_PathNdx(r,nNdx=-1)
    tReq * r
    int    nNdx
CODE:
    if (nNdx >= 0)
        r -> nPathNdx = nNdx ;
    RETVAL = r -> nPathNdx ;
OUTPUT:
    RETVAL


char *
embperl_ReqFilename(r)
    tReq * r
CODE:
    if (r -> pConf && r -> pConf -> sReqFilename)
        RETVAL = r -> pConf -> sReqFilename ;
    else
        RETVAL = NULL;
OUTPUT:
    RETVAL

int
embperl_Debug(r)
    tReq * r
CODE:
    RETVAL = r -> bDebug ;
OUTPUT:
    RETVAL

SV *
embperl_ApacheReq(r,...)
    tReq * r
CODE:
    RETVAL = RETVAL ; /* avoid warning */
#ifdef APACHE
    ST(0) = r -> pApacheReqSV ;
    SvREFCNT_inc(ST(0)) ;
    sv_2mortal(ST(0));
#else
    ST(0) = &sv_undef ;
#endif
#ifdef APACHE
    if (items > 1)
        {
        if (SvROK (ST(1)))
            r -> pApacheReq = (request_rec *)SvIV((SV*)SvRV(ST(1)));
        else
            r -> pApacheReq = NULL ;
        r -> pApacheReqSV = ST(1) ;
        }
#endif



SV *
embperl_ErrArray(r)
    tReq * r
CODE:
    RETVAL = newRV_inc((SV *)r -> pErrArray) ;
OUTPUT:
    RETVAL



SV *
embperl_FormArray(r)
    tReq * r
CODE:
    RETVAL = newRV_inc((SV *)r -> pFormArray) ;
OUTPUT:
    RETVAL


SV *
embperl_FormHash(r)
    tReq * r
CODE:
    RETVAL = newRV_inc((SV *)r -> pFormHash) ;
OUTPUT:
    RETVAL



SV *
embperl_EnvHash(r)
    tReq * r
CODE:
    RETVAL = newRV_inc((SV *)r -> pEnvHash) ;
OUTPUT:
    RETVAL




long
embperl_LogFileStartPos(r)
    tReq * r
CODE:
    RETVAL = r -> nLogFileStartPos ;
OUTPUT:
    RETVAL





char *
embperl_VirtLogURI(r)
    tReq * r
CODE:
    if (r -> pConf)
        RETVAL = r -> pConf -> sVirtLogURI ;
    else
        RETVAL = NULL ;
OUTPUT:
    RETVAL




char *
embperl_CookieName(r)
    tReq * r
CODE:
    if (r -> pConf)
        RETVAL = r -> pConf -> sCookieName ;
    else
        RETVAL = NULL ;
OUTPUT:
    RETVAL


int
embperl_SessionMgnt(r,...)
    tReq * r
CODE:
    RETVAL = r -> nSessionMgnt ;
    if (items > 1)
        r -> nSessionMgnt = (int)SvIV(ST(1)) ;
OUTPUT:
    RETVAL


int
embperl_SubReq(r)
    tReq * r
CODE:
    RETVAL = r -> bSubReq ;
OUTPUT:
    RETVAL

int
embperl_IsFormHashSetup(r)
    tReq * r
CODE:
    RETVAL = r -> bIsFormHashSetup ;
OUTPUT:
    RETVAL

int
embperl_IsImport(r)
    tReq * r
CODE:
    RETVAL = r -> pImportStash?1:0 ;
OUTPUT:
    RETVAL


SV *
embperl_ReqParameter(r)
    tReq * r
CODE:
    RETVAL = NULL;
    if (r -> pConf)
        {
        if (r -> pConf -> pReqParameter)
            RETVAL = newRV_inc((SV *)r -> pConf -> pReqParameter) ;
        }
OUTPUT:
    RETVAL


SV *
embperl_Application(r,app=NULL)
    tReq * r
    SV * app 
ALIAS:
    HTML::Embperl::Req::app = 1
    HTML::Embperl::Req::application = 2
CODE:
    RETVAL = r -> pApplication ;
    if (items > 1)
        {
        r -> pApplication = app ;
        SvREFCNT_inc (app) ;
        }
    else if (RETVAL)
        SvREFCNT_inc (RETVAL) ;
OUTPUT:
    RETVAL



int
embperl_Error(r,...)
    tReq * r
CODE:
    RETVAL = r -> bError ;
    if (items > 1)
        r -> bError = (int)SvIV(ST(1)) ;
OUTPUT:
    RETVAL


int
embperl_ProcessBlock(r,nBlockStart,nBlockSize,nBlockNo)
    tReq * r
    int     nBlockStart
    int     nBlockSize
    int     nBlockNo
CODE:
    RETVAL = ProcessBlock(r,nBlockStart,nBlockSize,nBlockNo) ;
OUTPUT:
    RETVAL


int
embperl_ProcessSub(r,pFile,nBlockStart,nBlockNo)
    tReq * r
    IV      pFile
    int     nBlockStart
    int     nBlockNo
CODE:
    RETVAL = ProcessSub(r,(tFile *)pFile, nBlockStart, nBlockNo) ;
OUTPUT:
    RETVAL


void
embperl_logevalerr(r,sText)
    tReq * r
    char * sText
PREINIT:
    int l ;
CODE:
     l = strlen (sText) ;
     while (l > 0 && isspace(sText[l-1]))
        sText[--l] = '\0' ;

     strncpy (r -> errdat1, sText, sizeof (r -> errdat1) - 1) ;
     LogError (r, rcEvalErr) ;

#endif

void
embperl_logerror(r,code, sText,pApacheReqSV=NULL)
    tReq * r
    int    code
    char * sText
    SV * pApacheReqSV
PREINIT:
    int  bRestore = 0 ;
#ifdef APACHE
    SV * pSaveApacheReqSV ;
    request_rec * pSaveApacheReq ;
#endif
CODE:
#ifdef APACHE
    if (pApacheReqSV && r -> pApacheReq == NULL)
        {
        bRestore = 1 ;
        pSaveApacheReqSV = r -> pApacheReqSV ;
        pSaveApacheReq = r -> pApacheReq ;
        if (SvROK (pApacheReqSV))
            r -> pApacheReq = (request_rec *)SvIV((SV*)SvRV(pApacheReqSV));
        else
            r -> pApacheReq = NULL ;
        r -> pApacheReqSV = pApacheReqSV ;
        }
#endif
     strncpy (r->errdat1, sText, sizeof (r->errdat1) - 1) ;
     LogError (r,code) ;
#ifdef APACHE
    if (bRestore)
        {
        r -> pApacheReqSV  = pSaveApacheReqSV  ;
        r -> pApacheReq = pSaveApacheReq   ;
        }
#endif


#if 0
int
embperl_getloghandle(r)
    tReq * r
CODE:
    RETVAL = GetLogHandle(r) ;
OUTPUT:
    RETVAL


long
embperl_getlogfilepos(r)
    tReq * r
CODE:
    OpenLog (r, "", 2) ;
    RETVAL = GetLogFilePos(r) ;
OUTPUT:
    RETVAL

#endif

void
embperl_output(r,sText)
    tReq * r
    char * sText
CODE:
    OutputToHtml (r,sText) ;


void
embperl_log(r,sText)
    tReq * r
    char * sText
CODE:
    lwrite (r->pApp, sText, strlen (sText)) ;

void
embperl_flushlog(r)
    tReq * r
CODE:
    FlushLog (r->pApp) ;



int
embperl_getlineno(r)
    tReq * r
CODE:
    RETVAL = GetLineNo (r) ;
OUTPUT:
    RETVAL


void
log_svs(r,sText)
    tReq * r
    char * sText
CODE:
    lprintf (r->pApp,"[%d]MEM:  %s: SVs: %d OBJs: %d\n", r->pThread->nPid, sText, sv_count, sv_objcount) ;

SV *
embperl_Escape(r, str, mode)
    tReq * r
    char *   str = NO_INIT 
    int      mode
PREINIT:
    STRLEN len ;
CODE:
    str = SvPV(ST(1),len) ;
    RETVAL = Escape(r, str, len, mode, NULL, 0) ; 
OUTPUT:
    RETVAL

 


#if 0


char *
embperl_SyntaxName(r)
    tReq * r
CODE:
    if (r && r -> pTokenTable && r -> pTokenTable -> sName)
        RETVAL = (char *)r -> pTokenTable -> sName ;
    else
        RETVAL = "" ;
OUTPUT:
    RETVAL               
 

void
embperl_Syntax(r, pSyntaxObj)
    tReq * r
    tTokenTable *    pSyntaxObj ;
CODE:
    r -> pTokenTable = pSyntaxObj ;

SV *
embperl_Code(r,...)
    tReq * r
CODE:
    RETVAL = r -> pCodeSV ;
    if (items > 1)
        {
        if (r -> pCodeSV)
            SvREFCNT_dec (r -> pCodeSV) ;
        r -> pCodeSV = ST(1) ;
        SvREFCNT_inc (r -> pCodeSV) ;
        }
    ST(0) = RETVAL;
    /*if (RETVAL != &sv_undef)
        sv_2mortal(ST(0));*/

#endif

INCLUDE: Cmd.xs

INCLUDE: DOM.xs

INCLUDE: Syntax.xs



# Reset Module, so we get the correct boot function

MODULE = HTML::Embperl      PACKAGE = HTML::Embperl     PREFIX = embperl_





