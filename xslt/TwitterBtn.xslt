<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ 
<!ENTITY % entities SYSTEM "entities.ent">
    %entities;
]>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" xmlns:TagsLib="urn:TagsLib" xmlns:ucomponents.xml="urn:ucomponents.xml" xmlns:ucomponents.cms="urn:ucomponents.cms" xmlns:google.maps="urn:google.maps" 
	exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets TagsLib ucomponents.xml ucomponents.cms google.maps ">


<xsl:output method="html" omit-xml-declaration="yes"/>

<xsl:param name="currentPage"/>

<xsl:template match="/">
	
	<xsl:variable name="twAccount" select="$currentPage/ancestor-or-self::Homepage/twitter[not(@isDoc)]" />
	<xsl:variable name="url" select="concat('http://',umbraco.library:RequestServerVariables('HTTP_HOST'))" />
	<xsl:variable name="hashTag" select="normalize-space($currentPage/twitterHashTag[not(@isDoc)])" />
	
<a href="http://developers.google.com/analytics" class="twitter-share-button" data-lang="en" data-url="{$url}{&NiceUrl;($currentPage/@id)}">
	<xsl:if test="string($twAccount)!=''"><xsl:attribute name="data-related"><xsl:value-of select="$twAccount" /></xsl:attribute></xsl:if>
	<xsl:if test="string($hashTag)!=''">
		<xsl:attribute name="data-hashtags"><xsl:value-of select="$hashTag" /></xsl:attribute>
		<xsl:attribute name="class">twitter-hashtag-button</xsl:attribute>
	</xsl:if>
	Tweet<xsl:if test="string($hashTag)!=''"><xsl:value-of select="concat(' #',$hashTag)" /></xsl:if></a>
  
	<script type="text/javascript" charset="utf-8"><![CDATA[
    window.twttr = (function (d,s,id) {
      var t, js, fjs = d.getElementsByTagName(s)[0];
      if (d.getElementById(id)) return; js=d.createElement(s); js.id=id;
      js.src="//platform.twitter.com/widgets.js"; fjs.parentNode.insertBefore(js, fjs);
      return window.twttr || (t = { _e: [], ready: function(f){ t._e.push(f) } });
    }(document, "script", "twitter-wjs"));
  ]]></script>

</xsl:template>

</xsl:stylesheet>