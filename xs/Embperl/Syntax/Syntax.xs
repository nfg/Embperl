
/*
 * *********** WARNING **************
 * This file generated by Embperl::WrapXS/2.0.0
 * Any changes made here will be lost
 * ***********************************
 * 1. /opt/perlt5.8.7/lib/site_perl/5.8.7/ExtUtils/XSBuilder/WrapXS.pm:52
 * 2. /opt/perlt5.8.7/lib/site_perl/5.8.7/ExtUtils/XSBuilder/WrapXS.pm:2068
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

MODULE = Embperl::Syntax    PACKAGE = Embperl::Syntax 

const char *
name(obj, val=NULL)
    Embperl::Syntax obj
    const char * val
  PREINIT:
    /*nada*/

  CODE:
    RETVAL = (const char *)  obj->sName;

    if (items > 1) {
        obj->sName = (const char *) val;
    }
  OUTPUT:
    RETVAL

PROTOTYPES: disabled

BOOT:
    items = items; /* -Wall */

