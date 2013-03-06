<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ 
<!ENTITY nbsp "&#x00A0;"> 
<!ENTITY hidden "umbracoNaviHide = 1">
<!ENTITY empty "not(normalize-space())">
<!ENTITY NiceUrl "umbraco.library:NiceUrl">
]>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" xmlns:uTube.XSLT="urn:uTube.XSLT" xmlns:google.maps="urn:google.maps" 
	exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets uTube.XSLT google.maps ">

<xsl:output method="html" indent="yes" omit-xml-declaration="yes"/>

<xsl:param name="currentPage"/>

<xsl:variable name="homeNode" select="$currentPage/ancestor-or-self::Homepage[@isDoc]" />
<xsl:variable name="timeout" select="$homeNode/timeout[not(@isDoc)]" />
<xsl:variable name="speed" select="$homeNode/transitionSpeed[not(@isDoc)]" />
<xsl:variable name="itemWidth" select="number(338)" />
		
<xsl:template match="/">
	<xsl:if test="count($currentPage/*[@isDoc and not(&hidden;)]) &gt; 0">
		<ul class="touchcarousel-container">
			<xsl:apply-templates select="$currentPage/*[@isDoc and not(&hidden;)]">					
			<xsl:sort select="(eventEndDate[normalize-space()]|eventStartDate[normalize-space()]|postDate[normalize-space()]|@createDate)[last()]" data-type="number" order="descending" />
			</xsl:apply-templates>
		</ul>
		
	<script>
	<![CDATA[
	$(document).ready(function(){
		var devideWidth = window.screen.width;
		if (devideWidth > 359) {
			var timeout = ]]><xsl:value-of select="$timeout" /><![CDATA[,
			speed = ]]><xsl:value-of select="$speed" /><![CDATA[,
			width = ]]><xsl:value-of select="$itemWidth" /><![CDATA[;

		$('#content-carousel').touchCarousel({
			itemsPerPage: 1,
			//itemsPerMove: 1,
			snapToItems: false,
			pagingNav: false,
			pagingNavControls: false,
			autoplay: false, 
			autoplayDelay: timeout,	
			autoplayStopAtAction: true,
			scrollbar: true,
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
		
	</xsl:if>
</xsl:template>
		
<xsl:template match="Event">
	
	<li class="touchcarousel-item">
		<section>
			<header><h1><xsl:value-of select="pageHeading[not(&empty;)]|metaTitle[not(&empty;)]|@nodeName " /></h1></header>
			
			<xsl:if test="pageMedia//mediaItem[1]/Image[not(&empty;)]">
				<div class="img-holder">
					<xsl:apply-templates select="pageMedia//mediaItem[1]">
						<xsl:with-param name="imgGen" select="true" />
						<xsl:with-param name="width" select="338" />
						<xsl:with-param name="compress" select="80" />
					</xsl:apply-templates>
				</div>
			</xsl:if>
			
			<time datetime="{(eventStartDate[not(&empty;)]|eventEndDate[not(&empty;)]|@createDate)[last()]}">
				<xsl:choose>
					<xsl:when test="oneDayEvent[text()='1']">
						<p><xsl:apply-templates select="(eventStartDate[not(&empty;)]|eventEndDate[not(&empty;)]|@createDate)[last()]" mode="longDate" /></p>
					</xsl:when>
					<xsl:otherwise>
						<p><span>Debut: </span><xsl:apply-templates select="(eventStartDate[not(&empty;)]|@createDate)[last()]" mode="longDate" /></p>
						<p><span>Finale: </span><xsl:apply-templates select="(eventEndDate[not(&empty;)]|eventStartDate[not(&empty;)]|@createDate)[last()]" mode="longDate" /></p>
					</xsl:otherwise>
				</xsl:choose>
			</time>
			
			<div class="text-holder">
				<xsl:call-template name="firstWords">
					<xsl:with-param name="TextData" select="bodyText[not(&empty;)]|metaDescription" />
					<xsl:with-param name="WordCount" select="50" />
					<xsl:with-param name="Ellipsis" select="'...'" />
				</xsl:call-template>
			<p><a href="{&NiceUrl;(@id)}">Read more</a></p>
			</div>
		</section>
	</li>

</xsl:template>
 
<xsl:template name="for.loop">
 
	<xsl:param name="i"/>
	<xsl:param name="count"/>
	<xsl:param name="page"/>
	
	<xsl:if test="$i &lt;= $count">
	 
		<xsl:if test="$page != $i">
			<a href="{umbraco.library:NiceUrl($currentPage/@id)}?page={$i - 1}">
				<xsl:value-of select="$i" />
			</a>
		</xsl:if>
		 
		<xsl:if test="$page = $i">
			<xsl:value-of select="$i" />
		</xsl:if>
	 
	</xsl:if>
	
	<xsl:if test="$i &lt;= $count">
		<xsl:call-template name="for.loop">
			<xsl:with-param name="i">
				<xsl:value-of select="$i + 1"/>
			</xsl:with-param>
			<xsl:with-param name="count">
				<xsl:value-of select="$count"/>
			</xsl:with-param>
			<xsl:with-param name="page">
				<xsl:value-of select="$page"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:if>
</xsl:template>

<!-- :: Helper Templates :: -->
		
<xsl:template match="* | @*" mode="longDate">
	<xsl:value-of select="umbraco.library:FormatDateTime(.,'dddd, dd MMMM - H:mm')" />
</xsl:template>
		
<!-- :: Includes :: -->		
<xsl:include href="_FirstWords.xslt" />
<xsl:include href="_MediaHelper.xslt" />
		
</xsl:stylesheet>