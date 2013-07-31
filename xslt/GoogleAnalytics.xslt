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

	<xsl:variable name="trackingCode" select="$currentPage/ancestor-or-self::root/AdminSettings[@isDoc]/googleAnalytics" />
	
	<xsl:value-of select="$trackingCode" disable-output-escaping="yes" />
	
</xsl:template>

</xsl:stylesheet>