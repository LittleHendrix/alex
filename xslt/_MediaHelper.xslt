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
  xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" xmlns:umbraco.contour="urn:umbraco.contour" 
  exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets umbraco.contour ">


<xsl:output method="html" indent="yes" omit-xml-declaration="yes"/>

  <!-- Umbraco Media Id -->
  <!-- Accepting param from Media Picker -->
  <xsl:template match="*" mode="media">
	<xsl:variable name="mediaNode" select="&GetMedia;" />
	<xsl:apply-templates select="$mediaNode[not(error)]" />
  </xsl:template>
    
  <!-- Image file  -->
  <!-- e.g. Accepting param from DAMP Picker -->
  <xsl:template match="Image">  
    <xsl:param name="imgGen" />
    <xsl:param name="width" />
    <xsl:param name="height" />
    <xsl:param name="compress" select="number(80)" />
    <xsl:param name="altImg" />
    <xsl:variable name="alt" select="umbraco.library:Replace(umbraco.library:Replace(umbraco.library:Replace(@nodeName,'_',' '),'-',' '),'.jpg','')" />
	
    <xsl:choose>
      <xsl:when test="msxsl:node-set($imgGen)[not(&empty;)]">
		<img>
			<xsl:attribute name="src">
				<xsl:text>/ImageGen.ashx?image=</xsl:text><xsl:value-of select="umbracoFile" />
				<xsl:if test="msxsl:node-set($width)[not(&empty;)]"><xsl:text>&amp;width=</xsl:text><xsl:value-of select="$width" /></xsl:if>
				<xsl:if test="msxsl:node-set($height)[not(&empty;)]"><xsl:text>&amp;height=</xsl:text><xsl:value-of select="$height" /></xsl:if>
				<xsl:if test="msxsl:node-set($altImg)[not(&empty;)]"><xsl:text>&amp;altImage=</xsl:text><xsl:value-of select="$altImg" /></xsl:if>
				<xsl:text>&amp;compression=</xsl:text><xsl:value-of select="$compress" />
				<xsl:text>&amp;constrain=true</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="alt"><xsl:value-of select="$alt" /></xsl:attribute>
			<xsl:attribute name="width"><xsl:value-of select="msxsl:node-set($width)[not(&empty;)]|umbracoWidth" /></xsl:attribute>
		  	<xsl:attribute name="height"><xsl:value-of select="msxsl:node-set($height)[not(&empty;)]|umbracoHeight" /></xsl:attribute>
		</img>
      </xsl:when>
      <xsl:otherwise>
        <img>
			<xsl:attribute name="src"><xsl:value-of select="umbracoFile" /></xsl:attribute>
			<xsl:attribute name="alt"><xsl:value-of select="$alt" /></xsl:attribute>
			<xsl:attribute name="width"><xsl:value-of select="msxsl:node-set($width)[not(&empty;)]|umbracoWidth" /></xsl:attribute>
		  	<xsl:attribute name="height"><xsl:value-of select="msxsl:node-set($height)[not(&empty;)]|umbracoHeight" /></xsl:attribute>
		</img>
      </xsl:otherwise>
    </xsl:choose>
	
  </xsl:template>

  <!-- Video file -->
  <!-- Accepting param from DAMP Picker -->
  <!-- if passing param from Media Picker, call "umbraco.library:GetMedia()" first --> 
  <xsl:template match="Video" mode="media">
    <xsl:param name="uniqueId" />
    <xsl:param name="width" />
    <xsl:param name="height" />
    
    <xsl:variable name="posterImage">
      <xsl:choose>
        <xsl:when test="string(posterImage)!=''">
          <xsl:value-of select="umbraco.library:GetMedia(posterImage, false)/umbracoFile" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'/css/images/placeholder-lrg.png'" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
	  
	<xsl:variable name="videoSrc">
		<xsl:choose>
			<xsl:when test="string(youTubeVideoId)!=''">
				<xsl:value-of select="youTubeVideoId" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="umbracoFile" />
		  	</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	  
    <div id="player{$uniqueId}" class="video-loader">
      <img>
        <xsl:attribute name = "src"><xsl:text>/ImageGen.ashx?image=</xsl:text><xsl:value-of select="$posterImage" /><xsl:text>&amp;compression=80&amp;constrain=true</xsl:text></xsl:attribute>
        <xsl:attribute name = "alt"><xsl:value-of select="@nodeName" /></xsl:attribute>     
      </img>
    </div>
	  
	<xsl:variable name="vWidth">
		<xsl:choose>
			<xsl:when test="string($width)!=''">
				<xsl:value-of select="$width" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="number(560)" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="vHeight">
		<xsl:choose>
			<xsl:when test="string($height)!=''">
				<xsl:value-of select="$height" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="number(315)" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	  
    <script><![CDATA[window.jwplayer || document.write('<script src="/scripts/jwplayer/jwplayer.js"><\/script>')]]></script>
    <script>
    <![CDATA[
	   jwplayer('player]]><xsl:value-of select="$uniqueId" /><![CDATA[').setup({
		   file: ']]><xsl:choose><xsl:when test="string(youTubeVideoId)!=''"><xsl:text>http://www.youtube.com/watch?v=</xsl:text><xsl:value-of select="$videoSrc" /></xsl:when><xsl:otherwise><xsl:value-of select="$videoSrc" /></xsl:otherwise></xsl:choose><![CDATA[']]><xsl:if test="string($posterImage)!=''"><![CDATA[, 
		   image: ']]><xsl:value-of select="$posterImage" /><![CDATA[']]></xsl:if><![CDATA[,
		   title: ']]><xsl:value-of select="@nodeName" /><![CDATA[',
		   controls: 'true',
		   width: ']]><xsl:value-of select="$vWidth" /><![CDATA[',
		   height: ']]><xsl:value-of select="$vHeight" /><![CDATA[',
		   stretching: 'fill',
		   autostart: 'false',
		   fallback: 'true',
		   mute: 'false',
		   primary: 'html5',
		   repeat: 'false'
	   });
    ]]>
    </script>
  </xsl:template>
  
  <!-- PDF file, render link -->
  <!-- Accepting param from DAMP Picker -->
  <!-- if passing param from Media Picker, call "umbraco.library:GetMedia()" first --> 
  <xsl:template match="File[umbracoExtension = 'pdf']" mode="media">
    <xsl:variable name="size">
      <xsl:choose>
        <xsl:when test="round(umbracoBytes div 1024) &lt; 1">
          <xsl:value-of select="umbracoBytes" /> Bytes
        </xsl:when>
        <xsl:when test="round(umbracoBytes div 1048576) &lt; 1">
          <xsl:value-of select="format-number((umbracoBytes div 1024), '0.0')" /> Kb
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="format-number((@FileSizeDisplay div 1048576), '0.00')" /> Mb
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <a href="{umbracoFile}" type="application/pdf">
      <xsl:text>Download PDF</xsl:text>
      <xsl:value-of select="$size" />
    </a>
  </xsl:template>
  
  <xsl:template match="*[&empty;]" mode="media" />
    
</xsl:stylesheet>