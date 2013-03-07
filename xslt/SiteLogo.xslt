<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ 
<!ENTITY % entities SYSTEM "entities.ent">
    %entities;
]>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" xmlns:uTube.XSLT="urn:uTube.XSLT" xmlns:google.maps="urn:google.maps" 
	exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets uTube.XSLT google.maps ">


<xsl:output method="html" omit-xml-declaration="yes"/>

<xsl:param name="currentPage"/>

<xsl:template match="/">

	<xsl:variable name="homepage" select="$currentPage/ancestor-or-self::Homepage" />
	<xsl:variable name="siteName">
		<xsl:choose>
			<xsl:when test="string($homepage/siteName[not(@isDoc)])!=''">
				<xsl:value-of select="$homepage/siteName[not(@isDoc)]" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'Alex Allan'" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:choose>
		<xsl:when test="$currentPage/@id = $homepage/@id">
			<h1><a href="/" id="logo"><xsl:value-of select="$siteName" /></a></h1>
		</xsl:when>
		<xsl:otherwise>
			<a href="/" id="logo"><xsl:value-of select="$siteName" /></a>
		</xsl:otherwise>
	</xsl:choose>

</xsl:template>

</xsl:stylesheet>