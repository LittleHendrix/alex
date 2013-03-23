<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ 
<!ENTITY % entities SYSTEM "entities.ent">
    %entities;
]>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" xmlns:TagsLib="urn:TagsLib" xmlns:uTube.XSLT="urn:uTube.XSLT" xmlns:ucomponents.xml="urn:ucomponents.xml" xmlns:ucomponents.cms="urn:ucomponents.cms" xmlns:UCommentLibrary="urn:UCommentLibrary" xmlns:google.maps="urn:google.maps" 
	exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets TagsLib uTube.XSLT ucomponents.xml ucomponents.cms UCommentLibrary google.maps ">


<xsl:output method="html" omit-xml-declaration="yes"/>

<xsl:param name="currentPage"/>

<xsl:template match="/">

	<xsl:variable name="homeNode" select="$currentPage/ancestor-or-self::Homepage[@isDoc]"/>
	<xsl:variable name="twitter" select="$homeNode/twitter" />
	<xsl:variable name="facebook" select="$homeNode/facebook" />
	<xsl:variable name="footerLinks" select="$homeNode/footerLinks" />

	<xsl:if test="string($twitter)!='' or string($facebook)!='' or string($footerLinks)!=''">
		<div class="social">
			<p>Follow me on <xsl:if test="string($twitter)!=''"><a href="https://twitter.com/{$twitter}" target="_blank">Twitter</a></xsl:if>
				<xsl:if test="string($facebook)!=''"> &amp; <a href="{$facebook}" target="_blank">Facebook</a></xsl:if>
			</p>
			<p class="footer-links"><xsl:for-each select="$footerLinks//url-picker[not(&empty;)]">
					<xsl:apply-templates select="." />
				</xsl:for-each>
			</p>
		</div>
	</xsl:if>
		
</xsl:template>
		
<xsl:template match="url-picker">
	<xsl:if test="url[not(&empty;)]">
		<xsl:variable name="title">
			<xsl:choose>
			<xsl:when test="link-title[not(&empty;)]">
				<xsl:value-of select="link-title" />
			</xsl:when>
			<xsl:when test="node-id[not(&empty;)]">
				<xsl:variable name="node" select="umbraco.library:GetXmlNodeById(node-id)" />
				<xsl:choose>
					<xsl:when test="$node[not(error)]">
						<xsl:value-of select="$node/@nodeName" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="''" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="url" />
			</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="./preceding-sibling::*"><xsl:text> \ </xsl:text></xsl:if>
		<a href="{url}">
			<xsl:if test="string(new-window)='True'"><xsl:attribute name="target">_blank</xsl:attribute></xsl:if>
			<xsl:value-of select="$title" /></a>
	</xsl:if>
</xsl:template>
		
</xsl:stylesheet>