<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" xmlns:uTube.XSLT="urn:uTube.XSLT" xmlns:google.maps="urn:google.maps" 
	exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets uTube.XSLT google.maps ">


<xsl:output method="html" omit-xml-declaration="yes"/>

<xsl:template match="Event">
	<xsl:variable name="evtHeading">
		<xsl:choose>
			<xsl:when test="string(pageHeading)!=''">
				<xsl:value-of select="pageHeading" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="@nodeName" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="evtDescription">
		<xsl:choose>
			<xsl:when test="string(bodyText)!=''">
				<xsl:value-of select="bodyText" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>&lt;p&gt;</xsl:text><xsl:value-of select="umbraco.library:ReplaceLineBreaks(metaDescription)" /><xsl:text>&lt;/p&gt;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="startDate">
		<xsl:choose>
			<xsl:when test="string(eventStartDate)!=''">
				<xsl:value-of select="umbraco.library:FormatDateTime(eventStartDate,'dddd, dd MMMM - H:mm')" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="umbraco.library:FormatDateTime(@updateDate,'dddd, dd MMMM - H:mm')" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="endDate">
		<xsl:choose>
			<xsl:when test="string(eventEndDate)!=''">
				<xsl:value-of select="umbraco.library:FormatDateTime(eventEndDate,'dddd, dd MMMM - H:mm')" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$startDate" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<article>
		<header>
			<h1><xsl:value-of select="$evtHeading" /></h1>
		</header>
		<div class="event-details">
			<xsl:choose>
				<xsl:when test="string(oneDayEvent)!='1'">
					<p><span>Debut: </span><xsl:value-of select="$startDate" /></p>
					<p><span>Finale: </span><xsl:value-of select="$endDate" /></p>
				</xsl:when>
				<xsl:otherwise>
					<p><xsl:value-of select="$startDate" /></p>
				</xsl:otherwise>
			</xsl:choose>
		</div>
		<div class="event-description">
			<xsl:value-of select="$evtDescription" disable-output-escaping="yes" />
		</div>
	</article>

</xsl:template>

</xsl:stylesheet>