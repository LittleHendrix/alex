<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" xmlns:uTube.XSLT="urn:uTube.XSLT" xmlns:google.maps="urn:google.maps" 
	exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets uTube.XSLT google.maps ">


<xsl:output method="html" omit-xml-declaration="yes"/>

<xsl:param name="currentPage"/>

<xsl:template match="/">

    <xsl:variable name="slideNodes" select="$currentPage/homepageCarousel[not(@isDoc)]" />
	<xsl:variable name="autoPlay" select="$currentPage/autoPlay[not(@isDoc)]" />
	<xsl:variable name="timeout" select="$currentPage/timeout[not(@isDoc)]" />
    
	<xsl:if test="count($slideNodes//item[string(./carouselImage)!='']) &gt; 0">
		<div id="homepage-carousel" class="touchcarousel black-and-white">  
			<ul class="touchcarousel-container">
				<xsl:for-each select="$slideNodes//item[string(./carouselImage)!='']">
					<xsl:variable name="media" select="umbraco.library:GetMedia(./carouselImage,false)" />
					<xsl:if test="$media[not(error)]">
						<li class="touchcarousel-item">
							<img src="{$media/umbracoFile}" alt="{$media/@nodeName}" width="{$media/umbracoWidth}" height="{$media/umbracoHeight}" />
						</li>
					</xsl:if>
				</xsl:for-each>
			</ul>		
		</div>
    </xsl:if>
    
</xsl:template>

</xsl:stylesheet>