<?xml version='1.0'?>

<!--
<!DOCTYPE xxx [
<!ENTITY % nbsp "&lt;![CDATA[&nbsp;]]&gt;" >
]>
-->

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


    <!-- - - - - Header 1 - - - - -->

    <xsl:template name="header1line">                         
     <xsl:param name="txt"></xsl:param>
      <table width="100%" border="0" cellspacing="0" cellpadding="6">
        <tr> 
          <td bgcolor="#fefcad" xxx="#faf208" xx="#93c4de"><font size="4" face="Verdana, Arial, Helvetica, sans-serif"><b>
            <font color="0" xx="#FFFFFF"><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                <xsl:value-of select="$txt"/>    
            </font></b></font></td>
        </tr>
        </table>
    </xsl:template>


    <!-- - - - - Get number - - - - -->
    
    <xsl:template match="sect1" mode="number"><xsl:number/></xsl:template>                         
    <xsl:template match="sect2" mode="number"><xsl:number level="any"/></xsl:template>                         

 
    <!-- - - - - Header Navigation - - - - -->

    <xsl:template name="headernav">                         
            <a name="top">
            <xsl:choose>
                <xsl:when test="not(pod/sect1)">
                    <xsl:variable name="nextpage">
                        <xsl:apply-templates select="following-sibling::sect1[para|verbatim|sect2][position()=1]" mode="number"/>
                    </xsl:variable>

                    <xsl:variable name="prevpage">
                        <xsl:apply-templates select="preceding-sibling::sect1[para|verbatim|sect2][position()=1]" mode="number"/>
                    </xsl:variable>
            
                    <table width="100%"><tr><td align="left" valign="top" width="35%">
                    <xsl:if test="$prevpage &gt; 0">
                        <xsl:choose>
                            <xsl:when test="$pageinname != 0">
                                <a href="{$basename}.{$prevpage}{$extension}">
                                    <font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                                        &lt;&lt; Prev: <xsl:value-of select="preceding-sibling::sect1[para|verbatim|sect2][position()=1]/title"/>
                                    </font>
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                <a href="{$basename}{$extension}?page={$prevpage}">
                                    <font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                                        &lt;&lt; Prev: <xsl:value-of select="preceding-sibling::sect1[para|verbatim|sect2][position()=1]/title"/>
                                    </font>
                                </a>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                    </td>
                    <td align="center"  valign="top" width="30%">
                    <xsl:element name="a">
                        <xsl:if test="$pageinname != 0">
                            <xsl:attribute name="href"><xsl:value-of select="$basename"/>.0<xsl:value-of select="$extension"/></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="$pageinname = 0">
                            <xsl:attribute name="href"><xsl:value-of select="$basename"/><xsl:value-of select="$extension"/>?page=0</xsl:attribute>
                        </xsl:if>
                        <font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                            [Content]
                        </font>
                    </xsl:element>
                    </td>
                    <td align="right" valign="top" width="35%">
                    <xsl:if test="following-sibling::sect1">
                        <xsl:element name="a">
                            <xsl:if test="$pageinname != 0">
                                <xsl:attribute name="href"><xsl:value-of select="$basename"/>.<xsl:value-of select="$nextpage"/><xsl:value-of select="$extension"/></xsl:attribute>
                            </xsl:if>
                            <xsl:if test="$pageinname = 0">
                                <xsl:attribute name="href"><xsl:value-of select="concat($basename,$extension)"/>?page=<xsl:value-of select="$nextpage"/></xsl:attribute>
                            </xsl:if>
                            <font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                                Next: <xsl:value-of select="following-sibling::sect1[para|verbatim|sect2]/title"/> &gt;&gt;
                            </font>
                        </xsl:element>
                    </xsl:if>
                    </td>
                    </tr></table>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="nextpage">
                        <xsl:apply-templates select="/pod/sect1[para|verbatim|sect2][position()=1]" mode="number"/>
                    </xsl:variable>
                    <table width="100%"><tr><td align="right">
                    <xsl:element name="a">
                        <xsl:if test="$pageinname != 0">
                            <xsl:attribute name="href"><xsl:value-of select="concat ($basename, '.', $nextpage, $extension)"/></xsl:attribute>
                        </xsl:if>
                        <xsl:if test="$pageinname = 0">
                            <xsl:attribute name="href"><xsl:value-of select="concat ($basename, $extension)"/>?page=<xsl:value-of select="$nextpage"/></xsl:attribute>
                        </xsl:if>
                        <font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                            Next: <xsl:value-of select="/pod/sect1[para|verbatim|sect2]/title"/> &gt;&gt;
                        </font>
                    </xsl:element>
                    </td>
                    </tr></table>
                </xsl:otherwise>
            </xsl:choose>
            </a>
    </xsl:template>

    <!-- - - - - Root - - - - -->

    <xsl:template match="/">                         
        <html>
            <head>
                <title><xsl:value-of select="pod/head/title"/></title>
            </head>
            <body>
                <xsl:choose>
                    <xsl:when test="$page = 0">
                        <xsl:call-template name="header1line">
                            <xsl:with-param name="txt">Content - <xsl:value-of select="/pod/head/title"/></xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="headernav"/>
                        <ul>              
                            <xsl:apply-templates select="/pod/sect1" mode="toc_short"/> 
                        </ul>              
                        <hr/>
                        <ul>              
                            <xsl:apply-templates select="/pod/sect1" mode="toc"/> 
                        </ul>              
                        <hr/>
                        <xsl:call-template name="headernav"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="/pod/sect1[position()=$page]"/> 
                    </xsl:otherwise>
                </xsl:choose>
            </body>
        </html>
    </xsl:template>

    <!-- - - - - table of content - - - - -->

    <xsl:template match="sect1" mode="toc_short">                         
        <xsl:if test="para|verbatim|sect2|list">
              <li><b>
              <xsl:element name="a">
                    <xsl:if test="$pageinname != 0">
                        <xsl:attribute name="href"><xsl:value-of select="$basename"/>.<xsl:number/><xsl:value-of select="$extension"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$pageinname = 0">
                        <xsl:attribute name="href"><xsl:value-of select="concat($basename,$extension)"/>?page=<xsl:number/></xsl:attribute>
                    </xsl:if>
              <font size="2" face="Verdana, Arial, Helvetica, sans-serif"><xsl:value-of select="title"/></font>
              </xsl:element>
              </b></li>
        </xsl:if>
    </xsl:template>

    <xsl:template match="sect1" mode="toc">                         
        <xsl:if test="para|verbatim|sect2|list">
            <xsl:variable name="pagehref">
                <xsl:if test="$pageinname != 0">
                    <xsl:value-of select="$basename"/>.<xsl:number/><xsl:value-of select="$extension"/>
                </xsl:if>
                <xsl:if test="$pageinname = 0">
                    <xsl:value-of select="concat($basename, $extension)"/>?page=<xsl:number/>
                </xsl:if>
            </xsl:variable>
            

            <li><b><a href="{$pagehref}"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><xsl:value-of select="title"/></font></a></b></li>
            <xsl:if test="sect2">
                <ul>
                    <xsl:apply-templates select="sect2" mode="toc1">
                        <xsl:with-param name="pagehref" select="$pagehref"/>
                    </xsl:apply-templates>
                </ul>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template match="sect2" mode="toc1">                         
        <xsl:param name="pagehref"></xsl:param>
          <li>
            <xsl:element name="a">
                <xsl:attribute name="href"><xsl:value-of select="$pagehref"/>#sect_<xsl:number level="any"/></xsl:attribute>
                <font size="1" face="Verdana, Arial, Helvetica, sans-serif"><xsl:value-of select="title"/></font>
            </xsl:element>
          </li>
    </xsl:template>


    <!-- - - - - content - - - - -->


    <xsl:template match="sect1">                         
          
        <xsl:call-template name="header1line">
            <xsl:with-param name="txt" select="title"/>
        </xsl:call-template>

        <xsl:call-template name="headernav"/>

        <xsl:if test="para|verbatim|sect2|list">
            <xsl:if test="sect2">
                <ul>
                    <xsl:apply-templates select="sect2" mode="toc1"/> 
                </ul><hr/>
            </xsl:if>
            <xsl:apply-templates select="*[name()!='title']"/> 
        </xsl:if>
        <hr/>
        <xsl:call-template name="headernav"/>
    </xsl:template>


    <xsl:template match="sect2">                         
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
            <td bgcolor="#eeeeee" width="80%">
            <br/><pre>
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

    <xsl:template name="link">
        <xsl:param name="txt"/>
        <xsl:param name="uri"/>
        <xsl:choose>
            <xsl:when test="contains($uri, '::')">
                <xsl:element name="a">
                    <xsl:attribute name="href">
                        <xsl:value-of select="translate($uri, ':', '/')"/>
                    </xsl:attribute>
                    <xsl:value-of select="$txt"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="starts-with($uri, 'http:')">
                <a href="{$uri}"><xsl:value-of select="$txt"/></a>
            </xsl:when>
            <xsl:when test="starts-with($uri, 'ftp:')">
                <a href="{$uri}"><xsl:value-of select="$txt"/></a>
            </xsl:when>
            <xsl:otherwise>
                
                <xsl:variable name="page">
                    <xsl:apply-templates select="//sect1[title=$uri]" mode="number"/>     
                </xsl:variable>

                <xsl:choose>
                    <xsl:when test="$page!=''">
                        <a href="?{$page}"><xsl:value-of select="$txt"/></a>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="page">
                            <xsl:apply-templates select="//sect1[sect2/title=$uri]" mode="number"/>     
                        </xsl:variable>
                        <xsl:variable name="sect">
                            <xsl:apply-templates select="//sect2[title=$uri]" mode="number"/>     
                        </xsl:variable>

                        <xsl:choose>
                            <xsl:when test="$page!=''">
                                <a href="?page={$page}#sect_{$sect}"><xsl:value-of select="$txt"/></a>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$txt"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>



    <xsl:template match="xlink">                         
            <xsl:choose>
                <xsl:when test="@uri">
                    <xsl:call-template name="link">
                        <xsl:with-param name="uri" select="@uri"/>
                        <xsl:with-param name="txt" select="."/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="link">
                        <xsl:with-param name="uri" select="."/>
                        <xsl:with-param name="txt" select="."/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
                 
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