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
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" xmlns:uTube.XSLT="urn:uTube.XSLT" xmlns:google.maps="urn:google.maps" 
	exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets uTube.XSLT google.maps ">


<xsl:output method="html" omit-xml-declaration="yes"/>

<xsl:param name="currentPage"/>

<xsl:template match="/">
	
	<xsl:apply-templates select="$currentPage" />

</xsl:template>		

<xsl:template match="Event">	
	
	<xsl:variable name="hasMediaFolder">
		<xsl:choose>
			<xsl:when test="pageMedia//mediaItem[1]/Folder/@id[not(&empty;)]">
				<xsl:value-of select="pageMedia//mediaItem[1]/Folder/@id" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="''" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>	
	
	<xsl:variable name="startDate">
		<xsl:choose>
			<xsl:when test="eventStartDate[not(&empty;)]">
				<xsl:apply-templates select="eventStartDate" mode="longDate" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="@createDate" mode="longDate" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="endDate">
		<xsl:choose>
			<xsl:when test="eventEndDate[not(&empty;)]">
				<xsl:apply-templates select="eventEndDate" mode="longDate" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$startDate" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<article>
		<xsl:if test="string(pageMedia//mediaItem[1]/Image)='' and string($hasMediaFolder)=''">
			<xsl:attribute name="class">no-img</xsl:attribute>
		</xsl:if>
		<header>
			<h1><xsl:value-of select="(pageHeading[not(&empty;)]|@nodeName)[last()]" /></h1>
		</header>
		<div class="img-holder">
			<xsl:if test="pageMedia//mediaItem[1]/Image[not(&empty;)]">
				<xsl:apply-templates select="pageMedia//mediaItem[1]/Image">
					<xsl:with-param name="imgGen">true</xsl:with-param>
					<xsl:with-param name="width">338</xsl:with-param>
					<xsl:with-param name="compress">100</xsl:with-param>
					<xsl:with-param name="allowUmbMeasure">false</xsl:with-param>
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="pageMedia//mediaItem[1]/Folder/@id[not(&empty;)]">
				<xsl:apply-templates select="pageMedia//mediaItem[1]/Folder/@id" mode="folder">
					<xsl:with-param name="getFirstItem">true</xsl:with-param>
					<xsl:with-param name="imgGen">true</xsl:with-param>
					<xsl:with-param name="width">338</xsl:with-param>
					<xsl:with-param name="compress">100</xsl:with-param>
					<xsl:with-param name="allowUmbMeasure">false</xsl:with-param>
				</xsl:apply-templates>
			</xsl:if>
			<xsl:comment>&nbsp;</xsl:comment>
		</div>
		<time datetime="{$startDate}">
			<xsl:choose>
				<xsl:when test="oneDayEvent[text()='1'] or $startDate = $endDate">
					<p><xsl:value-of select="$endDate" /></p>
				</xsl:when>
				<xsl:otherwise>
					<p><span>Debut: </span><xsl:value-of select="$startDate" /></p>
					<p><span>Finale: </span><xsl:value-of select="$endDate" /></p>
				</xsl:otherwise>
			</xsl:choose>
		</time>
		<div class="text-holder">
			<xsl:choose>
				<xsl:when test="bodyText[not(&empty;)]">
					<xsl:apply-templates select="bodyText" mode="WYSIWYG" />
				</xsl:when>
				<xsl:otherwise>
					<p><xsl:value-of select="umbraco.library:ReplaceLineBreaks(metaDescription)" disable-output-escaping="yes" /></p>
				</xsl:otherwise>
			</xsl:choose>
			
			<p id="ical_export">
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="umbraco.library:NiceUrl($currentPage/@id)" /><xsl:text>?altTemplate=iCalExport</xsl:text>
					</xsl:attribute>
					Add to calendar (iCal)
				</a>
			</p>
			
			<div class="thumbs">
			<xsl:apply-templates select="pageMedia//mediaItem/Image">
				<xsl:with-param name="imgGen">true</xsl:with-param>
				<xsl:with-param name="width">140</xsl:with-param>
				<xsl:with-param name="compress">100</xsl:with-param>
				<xsl:with-param name="allowUmbMeasure">false</xsl:with-param>
				<xsl:with-param name="getCrop">true</xsl:with-param>
			</xsl:apply-templates>
			
			<xsl:if test="string($hasMediaFolder)!=''">
				<xsl:apply-templates select="pageMedia//mediaItem[1]/Folder/@id" mode="folder">
					<xsl:with-param name="imgGen">true</xsl:with-param>
					<xsl:with-param name="width">140</xsl:with-param>
					<xsl:with-param name="compress">100</xsl:with-param>
					<xsl:with-param name="allowUmbMeasure">false</xsl:with-param>
					<xsl:with-param name="getCrop">true</xsl:with-param>
				</xsl:apply-templates>
			</xsl:if>
			</div>
			
		</div>
	</article>

</xsl:template>
<!-- :: Helper Templates :: -->

<xsl:template match="* | @*" mode="longDate">
	<xsl:variable name="endings" select="umbraco.library:Split('st,nd,rd,th,th,th,th,th,th,th,th,th,th,th,th,th,th,th,th,th,st,nd,rd,th,th,th,th,th,th,th,st',',')"/>
	<xsl:variable name="pos" select="number(substring(.,9,2))" />
	<!--
	<xsl:value-of select="umbraco.library:FormatDateTime(.,'ddd, dd MMMM yyyy - H:mmtt')" />
	-->
	<xsl:value-of select="concat(umbraco.library:FormatDateTime(.,'ddd, d'),msxsl:node-set($endings)//value[$pos],umbraco.library:FormatDateTime(.,' MMMM yyyy - H:mmtt'))"/>
</xsl:template>
		
<!-- :: Includes :: -->	
<xsl:include href="_FirstWords.xslt" />
<xsl:include href="_MediaHelper.xslt" />
<xsl:include href="_WYSIWYG.xslt" />
</xsl:stylesheet>