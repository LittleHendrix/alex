<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
  version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:msxml="urn:schemas-microsoft-com:xslt"
  xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" xmlns:umbraco.contour="urn:umbraco.contour" 
  exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets umbraco.contour ">


<xsl:output method="html" omit-xml-declaration="yes"/>

<xsl:template name="firstWords">
  <xsl:param name="TextData"/>
  <xsl:param name="WordCount"/>
  <xsl:param name="Ellipsis"/>
  <xsl:choose>
    <xsl:when test="$WordCount &gt; 1 and
        (string-length(substring-before($TextData, ' ')) &gt; 0 or
        string-length(substring-before($TextData, '  ')) &gt; 0)">
      <xsl:value-of select="concat(substring-before($TextData, ' '), ' ')" disable-output-escaping="yes"/>
      <xsl:call-template name="firstWords">
        <xsl:with-param name="TextData" select="substring-after($TextData, ' ')"/>
        <xsl:with-param name="WordCount" select="$WordCount - 1"/>
        <xsl:with-param name="Ellipsis" select="$Ellipsis"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="(string-length(substring-before($TextData, ' ')) &gt; 0 or
        string-length(substring-before($TextData, '  ')) &gt; 0)">
      <xsl:value-of select="concat(substring-before($TextData, ' '), $Ellipsis)" disable-output-escaping="yes"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$TextData" disable-output-escaping="yes"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>