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

	<div id="fb-root"></div>
	<script><![CDATA[
		(function(d, s, id) {
	  var js, fjs = d.getElementsByTagName(s)[0];
	  if (d.getElementById(id)) return;
	  js = d.createElement(s); js.id = id;
	js.src = "//connect.facebook.net/en_GB/all.js#xfbml=1&amp;appId=]]><xsl:value-of select="umbraco.library:RenderMacroContent('&lt;?UMBRACO_MACRO macroAlias=&quot;FbAppId&quot; &gt;&lt;/?UMBRACO_MACRO&gt;',$currentPage/@id)" disable-output-escaping="yes" /><![CDATA[";
	  fjs.parentNode.insertBefore(js, fjs);
	}(document, 'script', 'facebook-jssdk'));
	]]></script>

</xsl:template>

</xsl:stylesheet>