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
		
<xsl:variable name="homeNode" select="$currentPage/ancestor-or-self::Homepage[@isDoc]" />
<xsl:variable name="timeout" select="$homeNode/timeout[not(@isDoc)]" />
<xsl:variable name="speed" select="$homeNode/transitionSpeed[not(@isDoc)]" />
<xsl:variable name="itemWidth" select="number(338)" />
		
<xsl:template match="/">
	
	<ul class="touchcarousel-container">
	<li class="touchcarousel-item" id="article-slide">
		<article class="no-img">
			<header>
				<h1><xsl:value-of select="($currentPage/pageHeading[not(&empty;)]|$currentPage/@nodeName)[last()]" /></h1>
			</header>
			<div class="img-holder">&nbsp;</div>
			<xsl:variable name="completeDate">
				<xsl:choose>
					<xsl:when test="$currentPage/completionDate[not(&empty;)]">
						<xsl:apply-templates select="$currentPage/completionDate" mode="monthYear" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="$currentPage/@createDate" mode="monthYear" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<time datetime="{($currentPage/completionDate[not(&empty;)]|$currentPage/@createDate)[last()]}">
				<xsl:if test="string($completeDate)!=''">
					<p><span>Date: </span><xsl:value-of select="$completeDate" /></p>
				</xsl:if>
			</time>
		
			<div class="text-holder">
				<xsl:if test="$currentPage/type[not(&empty;)]">
				<div class="type">
					<p><span>Type: </span>
						<xsl:apply-templates select="$currentPage/type" mode="multipicker" />
					</p>
				</div>
				</xsl:if>
			
				<xsl:choose>
					<xsl:when test="$currentPage/bodyText[not(&empty;)]">
						<xsl:apply-templates select="$currentPage/bodyText" mode="WYSIWYG" />
					</xsl:when>
					<xsl:otherwise>
						<p><xsl:value-of select="umbraco.library:ReplaceLineBreaks($currentPage/metaDescription)" disable-output-escaping="yes" /></p>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</article>
	</li>

	<xsl:if test="$currentPage/pageMedia//mediaItem[1]/Image[not(&empty;)]">	
		<xsl:for-each select="$currentPage/pageMedia//mediaItem/Image[not(&empty;)]">
			<li class="touchcarousel-item">
			<xsl:apply-templates select=".">
				<xsl:with-param name="imgGen">true</xsl:with-param>
				<xsl:with-param name="height">540</xsl:with-param>
				<xsl:with-param name="compress">100</xsl:with-param>
			</xsl:apply-templates>
			</li>
		</xsl:for-each>
	</xsl:if>
		
		<xsl:if test="$currentPage/pageMedia//mediaItem[1]/Folder/@id[not(&empty;)]">
			<xsl:apply-templates select="$currentPage/pageMedia//mediaItem[1]/Folder/@id" mode="folder">
				<xsl:with-param name="imgGen">true</xsl:with-param>
				<xsl:with-param name="height">540</xsl:with-param>
				<xsl:with-param name="compress">100</xsl:with-param>
				<xsl:with-param name="isSlide">true</xsl:with-param>
			</xsl:apply-templates>
		</xsl:if>
		
	</ul>
		
	<script>
	<![CDATA[
	$(document).ready(function(){
		var devideWidth = window.screen.width;
		if (devideWidth > 359) {
			var timeout = ]]><xsl:value-of select="$timeout" /><![CDATA[,
			speed = ]]><xsl:value-of select="$speed" /><![CDATA[,
			width = ]]><xsl:value-of select="$itemWidth" /><![CDATA[;

		$('#singleNode-carousel').touchCarousel({
			itemsPerPage: 1,
			//itemsPerMove: 1,
			snapToItems: false,
			pagingNav: false,
			pagingNavControls: false,
			autoplay: false, 
			autoplayDelay: timeout,	
			autoplayStopAtAction: true,
			scrollbar: false,
			scrollbarAutoHide: true,
			scrollbarTheme: "dark",
			transitionSpeed: speed,
			directionNav: true,
			directionNavAutoHide: false,		
			loopItems: true,            // Loop items (don't disable arrows on last slide and allow autoplay to loop)
			keyboardNav: true,
			dragUsingMouse: true,
			scrollToLast: true,         // Last item ends at start of carousel wrapper
			itemFallbackWidth: width,
			baseMouseFriction: 0.0012,  // Container friction on desktop (higher friction - slower speed)
			baseTouchFriction: 0.0008,  // Container friction on mobile
			lockAxis: true,             // Allow dragging only on one direction
			useWebkit3d: true,
			onAnimStart: null,
			onAnimComplete: null,
			onDragStart:null,
			onDragRelease: null
		});
		}				
	});
	]]>
	</script>
</xsl:template>
		
<!-- :: Helper Templates :: -->
<xsl:template match="* | @*" mode="monthYear">
	<xsl:value-of select="umbraco.library:FormatDateTime(.,'MMMM yyyy')" />
</xsl:template>
<xsl:template match="ProjectType">
	<xsl:param name="nodeIds" />
	
	<xsl:variable name="procedingNodeIds">
		<xsl:for-each select="./preceding-sibling::ProjectType">
			<xsl:value-of select="@id" />
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="hasProcedingNodes">
		<xsl:for-each select="msxsl:node-set($nodeIds)/nodeId">
			<xsl:if test="contains($procedingNodeIds,.)"><xsl:text>true</xsl:text></xsl:if>
		</xsl:for-each>
	</xsl:variable>
	
	<xsl:if test="contains($hasProcedingNodes,'true')">
		<xsl:text>, </xsl:text>
	</xsl:if>
	<a href="/work/?type={Exslt.ExsltStrings:lowercase(normalize-space(@nodeName))}"><xsl:value-of select="@nodeName" /></a>
</xsl:template>
	
<!-- :: Includes :: -->	
<xsl:include href="_WYSIWYG.xslt" />
<xsl:include href="_MediaHelper.xslt" />
<xsl:include href="_MultiPickerHelper.xslt" />
</xsl:stylesheet>