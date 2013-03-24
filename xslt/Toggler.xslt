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

	<xsl:variable name="workNode" select="$currentPage/ancestor-or-self::Homepage[@isDoc]/Portfolio" />
	<xsl:variable name="qry" select="umbraco.library:RequestQueryString('display')" />

	<xsl:if test="$currentPage/@id = $workNode/@id">
		<div class="list-toggler">
			<a href="{&NiceUrl;($workNode/@id)}?display=list" data-title="display in list" id="list" class="toggler list">
				<xsl:if test="string($qry)='list' or string($qry)=''"><xsl:attribute name="class">toggler list active</xsl:attribute></xsl:if>
				List</a>
			<a href="{&NiceUrl;($workNode/@id)}?display=tile" data-title="display in tile" id="tile" class="toggler tile">
				<xsl:if test="string($qry)='tile'"><xsl:attribute name="class">toggler tile active</xsl:attribute></xsl:if>
				Tile</a>
		</div>
	</xsl:if>

</xsl:template>

</xsl:stylesheet>