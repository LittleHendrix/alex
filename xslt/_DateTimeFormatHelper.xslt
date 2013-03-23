<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ 
<!ENTITY % entities SYSTEM "entities.ent">
    %entities;
]>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" xmlns:TagsLib="urn:TagsLib" xmlns:uTube.XSLT="urn:uTube.XSLT" xmlns:ucomponents.xml="urn:ucomponents.xml" xmlns:ucomponents.cms="urn:ucomponents.cms" xmlns:UCommentLibrary="urn:UCommentLibrary" xmlns:google.maps="urn:google.maps" 
	exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets TagsLib uTube.XSLT ucomponents.xml ucomponents.cms UCommentLibrary google.maps ">


<xsl:output method="html" omit-xml-declaration="yes"/>

<xsl:param name="currentPage"/>

<xsl:template match="/">
	
	<xsl:variable name="dateField" select="/macro/dateField" />
	<xsl:variable name="dateFormat" select="normalize-space(Exslt.ExsltStrings:lowercase(/macro/dateFormat))" />

	<xsl:variable name="endings" select="umbraco.library:Split('st,nd,rd,th,th,th,th,th,th,th,th,th,th,th,th,th,th,th,th,th,st,nd,rd,th,th,th,th,th,th,th,st',',')"/>


	<xsl:variable name="dte" select="($dateField[not(&empty;)]|@createDate)[last()]" />
	
	<xsl:choose>
		<xsl:when test="string($dateFormat)='umblong'">
			<xsl:value-of select="umbraco.library:LongDate($dte, 1, ' ')"/>
		</xsl:when>
		<xsl:when test="string($dateFormat)='monthyear'">
			<xsl:value-of select="umbraco.library:FormatDateTime($dte,'MMMM yyyy')" />
		</xsl:when>
		<xsl:when test="string($dateFormat)='currentyear'">
			<xsl:value-of select="umbraco.library:FormatDateTime(umbraco.library:CurrentDate(), 'yyyy')" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="concat(umbraco.library:FormatDateTime($dte,'ddd, d'),msxsl:node-set($endings)//value[number(substring($dte,9,2))]/text(),umbraco.library:FormatDateTime(.,' MMMM yyyy - H:mmtt'))"/>
		</xsl:otherwise>
	</xsl:choose>

</xsl:template>

</xsl:stylesheet>