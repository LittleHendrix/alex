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


<xsl:output method="html" omit-xml-declaration="yes" />

<xsl:param name="currentPage"/>
	
	<xsl:variable name="homeNode" select="$currentPage/ancestor-or-self::Homepage[@isDoc]" />
		
<xsl:template match="/">

		<nav>
		<xsl:for-each select="$homeNode/*[not(&hidden;)]">
			<xsl:if test="@id[not(&empty;)]">
				<a href="{&NiceUrl;(@id)}">
					<xsl:if test="$currentPage/ancestor-or-self::*[not(&hidden;)]/@id = @id">
						<!-- we're under the item - you can do your own styling here -->
						<xsl:attribute name="class">selected</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="@nodeName"/>
				</a>
			</xsl:if>
		</xsl:for-each>
		</nav>

</xsl:template>

</xsl:stylesheet>