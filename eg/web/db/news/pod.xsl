<?xml version='1.0'?>


<!DOCTYPE stylesheet [
<!-- <!ENTITY nbsp "<xsl:text disable-output-escaping=&quot;yes&quot;>&amp;nbsp;</xsl:text>"> -->
<!ENTITY space "<xsl:text> </xsl:text>">
<!ENTITY cr "<xsl:text>
</xsl:text>">
]>


<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:pod="http://axkit.org/ns/2000/pod2xml"
                xmlns="http://www.w3.org/TR/xhtml1/strict">


    <xsl:output method="html" indent="yes" encoding="iso-8859-1"/>

    <xsl:variable name="imagepath">/eg/images</xsl:variable>
    <xsl:variable name="newswidth">152</xsl:variable>

    <xsl:param name="page" select="0"/>
    <xsl:param name="basename">default</xsl:param>
    <xsl:param name="extension">html???</xsl:param> <!-- select="'htm'"/> -->
    <xsl:param name="pageinname">0</xsl:param>


    <!-- - - - - Title - - - - -->

    <xsl:template name="titleline">                         
     <xsl:param name="txt"></xsl:param>
      <table width="100%" border="0" cellspacing="0" cellpadding="6">
        <tr> 
          <td bgcolor="#fefcad"><b>
            <font size="4" face="Verdana, Arial, Helvetica, sans-serif">
            <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                <xsl:value-of select="$txt"/>    
            </font></b></td>
        </tr>
        </table>
    </xsl:template>

    <!-- - - - - Header 1 - - - - -->

    <xsl:template name="header1line">                         
     <xsl:param name="txt"></xsl:param>
      <table width="100%" border="0" cellspacing="0" cellpadding="6">
        <tr> 
          <td bgcolor="#D2E9F5"><b>
            <font color="0" xx="#FFFFFF"><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                <xsl:value-of select="$txt"/>    
            </font></b></td>
        </tr>
        </table>
    </xsl:template>



    <!-- - - - - Root - - - - -->

    <xsl:template match="/">                         
        <html>
            <head>
                <title><xsl:value-of select="pod/head/title"/></title>
            </head>
            <body>
                <xsl:call-template name="titleline">
                    <xsl:with-param name="txt" select="pod/head/title"/>
                </xsl:call-template>
                <xsl:apply-templates select="/pod/sect1"/> 
            </body>
        </html>
    </xsl:template>


    <!-- - - - - content - - - - -->


    <xsl:template match="sect1">                         
          
        <xsl:call-template name="header1line">
            <xsl:with-param name="txt" select="title"/>
        </xsl:call-template>

        <xsl:if test="para|verbatim|sect2">
            <xsl:apply-templates select="*[name()!='title']"/> 
        </xsl:if>
    </xsl:template>


    <xsl:template match="sect2">                         
        <xsl:if test="para|verbatim|sect3">
            <br/>
            <xsl:element name="a">
                <xsl:attribute name="name">sect_<xsl:number level="any"/></xsl:attribute>
              <table width="100%" border="0" cellspacing="0" cellpadding="6">
                <tr bgcolor="#D2E9F5"> 
                  <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>
                    <font color="0"><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                        <xsl:value-of select="title"/>    
                    </font></b></font></td>
                   <td align="right"><a href="#top"><font size="1">top</font></a></td> 
                </tr>
                </table>
            </xsl:element>
        <xsl:apply-templates select="*[name()!='title']"/> 
        </xsl:if>
    </xsl:template>


    <!-- - - - - list - - - - -->

    <xsl:template match="list">                         
        <table border="0" cellspacing="3" cellpadding="0">
               <xsl:apply-templates mode="item"/> 
        </table>
    </xsl:template>



    <xsl:template match="item" mode="item">                         
        <tr>
            <td>
                    <img src="{$imagepath}/but.gif"/>
            </td>
            <td>
                    <xsl:apply-templates select="itemtext"/>
            </td>
        </tr>
        <tr>
            <td>
                    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>     
            </td>
            <td>
                    <xsl:apply-templates select="*[name()!='itemtext']"/>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                    <img src="{$imagepath}/transp.gif" height="4"/>
            </td>
        </tr>
    </xsl:template>


    <xsl:template match="list" mode="item">                         
        <tr>
            <td>
                    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>     
            </td>
            <td>
                <table border="0" cellspacing="3" cellpadding="0">
                       <xsl:apply-templates mode="item"/> 
                </table>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="itemtext">                         
            <p><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b><xsl:apply-templates/></b></font></p>
    </xsl:template>


    <!-- - - - - code - - - - -->

    <!--
    <xsl:template match="verbatim">                         
        <xsl:if test="not(preceding-sibling::node()[position() = 2][name()='verbatim'])">       
            <table width="100%" cellpadding="10"><tr>
            <td width="10%"><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></td>
            <td bgcolor="#eeeeee">
            <pre><xsl:value-of select="."/>
            
            <xsl:apply-templates select="following-sibling::node()[position() &lt; 3][name()='verbatim']" mode="verbatim"/>
            </pre>
            </td>
            <td width="10%"><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></td>
            </tr></table>
        </xsl:if>
    </xsl:template>

    <xsl:template  match="verbatim" mode="verbatim">                         
            <xsl:value-of select="."/>
            <xsl:apply-templates select="following-sibling::node()[position() &lt; 3][name()='verbatim']" mode="verbatim"/>
    </xsl:template>
    -->

    <xsl:template match="verbatim">                         
            <table width="100%" cellpadding="3" cellspacing="0"><tr>
            <td width="10%"><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></td>
            <td bgcolor="#eeeeee">
            <pre>
            <xsl:apply-templates/>
            </pre>
            </td>
            <td width="10%"><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></td>
            </tr></table>
    </xsl:template>

    <xsl:template  match="verbatim" mode="verbatim">                         
            <xsl:value-of select="."/>
            <xsl:apply-templates select="following-sibling::node()[position() &lt; 3][name()='verbatim']" mode="verbatim"/>
    </xsl:template>

    <!-- - - - - link - - - - -->

    <xsl:template match="xlink">                         
            <xsl:element name="a">
                <xsl:attribute name="href">
                    <xsl:value-of select="@uri"/>
                </xsl:attribute>
                <xsl:value-of select="."/>
            </xsl:element>
    </xsl:template>

    <xsl:template match="para">                         
            <p><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><xsl:apply-templates/></font></p>
    </xsl:template>

    <!-- - - - - text - - - - -->

    <xsl:template match="emphasis">                         
        <i><xsl:value-of select="."/></i>
    </xsl:template>

    <xsl:template match="strong">                         
        <b><xsl:value-of select="."/></b>
    </xsl:template>


</xsl:stylesheet> 