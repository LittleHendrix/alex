<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ 
<!ENTITY % entities SYSTEM "entities.ent">
    %entities;
]>
<xsl:stylesheet 
        version="1.0" 
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
        xmlns:msxml="urn:schemas-microsoft-com:xslt" 
        xmlns:multi="urn:multi-com:xslt"
        xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" 
        exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets multi">
<xsl:output method="text" omit-xml-declaration="yes"/>


<msxml:script language="CSharp" implements-prefix="multi">
<msxml:assembly name="System.Web" />
<msxml:using namespace="System.Web" />
 
<![CDATA[
public void changeOutPut(String ContentType, String FileName) {
        HttpContext.Current.Response.ContentType = ContentType;
        HttpContext.Current.Response.AddHeader("content-disposition", "attachment;filename=" + FileName);
}
]]>

</msxml:script>
          
<xsl:param name="currentPage"/>
          
<xsl:template match="/">  
<xsl:variable name="start" select="umbraco.library:FormatDateTime($currentPage/eventStartDate, 'yyyyMMddTHHmm')" />
<xsl:variable name="end">
<xsl:choose><xsl:when test="number(umbraco.library:FormatDateTime($currentPage/eventStartDate, 'yyyyMMddHHmm')) &gt; number(umbraco.library:FormatDateTime($currentPage/eventEndDate, 'yyyyMMddHHmm'))"><xsl:value-of select="$start" /></xsl:when><xsl:otherwise><xsl:value-of select="umbraco.library:FormatDateTime($currentPage/eventEndDate, 'yyyyMMddTHHmm')" /></xsl:otherwise></xsl:choose></xsl:variable>
<xsl:text>BEGIN:VCALENDAR</xsl:text><xsl:text>&#xa;</xsl:text>
<xsl:text>VERSION:1.0</xsl:text><xsl:text>&#xa;</xsl:text>
<xsl:text>BEGIN:VEVENT</xsl:text><xsl:text>&#xa;</xsl:text>
<xsl:text>DTSTART:</xsl:text><xsl:value-of select="$start"/><xsl:text>00z&#xa;</xsl:text>
<xsl:text>DTEND:</xsl:text><xsl:value-of select="$end"/><xsl:text>00z&#xa;</xsl:text>
<xsl:text>LOCATION:</xsl:text><xsl:value-of select="$currentPage/iCalLocation" /><xsl:text>&#xa;</xsl:text>
<xsl:text>DESCRIPTION:</xsl:text><xsl:call-template name="newLines"><xsl:with-param name="contentToChange" select="$currentPage/bodyText" /></xsl:call-template><xsl:if test="string($currentPage/eventLocation) != ''"><xsl:variable name="mapData" select="umbraco.library:Split($currentPage/eventLocation,',')" /><xsl:variable name="mapLat" select="$mapData/value[position() = 1]" /><xsl:variable name="mapLong" select="$mapData/value[position() = 2]" /><xsl:variable name="mapZoom" select="$mapData/value[position() = 3]" /><xsl:text>\nView location on Google Map:\nhttp://maps.googleapis.com/maps/api/staticmap?zoom=17&amp;size=800x600&amp;markers=color:0xad1e25%7Clabel:H%7C</xsl:text><xsl:value-of select="$mapLat" />,<xsl:value-of select="$mapLong" /><xsl:text>&amp;key=AIzaSyAMaPZajy2bHYsLqcfZ_q-wbqYztpzWI00&amp;sensor=false</xsl:text></xsl:if><xsl:text>&#xa;</xsl:text>
<xsl:text>SUMMARY:Alex Allan: </xsl:text><xsl:value-of select="$currentPage/@nodeName" /><xsl:text>&#xa;</xsl:text>
<xsl:text>PRIORITY:3</xsl:text><xsl:text>&#xa;</xsl:text>
<xsl:text>END:VEVENT</xsl:text><xsl:text>&#xa;</xsl:text>
<xsl:text>END:VCALENDAR</xsl:text><xsl:text>&#xa;</xsl:text>
<xsl:value-of select="multi:changeOutPut('text/calendar','EventExport.ics')" />
</xsl:template>


<xsl:template name="newLines"><xsl:param name="contentToChange" /><xsl:value-of select='umbraco.library:Replace($contentToChange, "&#xd;&#xa;", "\n")'/></xsl:template>

</xsl:stylesheet>
