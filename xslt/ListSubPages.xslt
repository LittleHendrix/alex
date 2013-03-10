<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ 
<!ENTITY % entities SYSTEM "entities.ent">
    %entities;
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
<xsl:variable name="nodeTypeId" select="/macro/nodeType" />
		
<xsl:variable name="nodeTypeAlias" select="local-name($currentPage/*[@isDoc and @nodeType = $nodeTypeId])" />
		
<xsl:template match="/">
	
	<xsl:if test="count($currentPage/*[@isDoc and name()=$nodeTypeAlias and not(&hidden;)]) &gt; 0">
		<ul class="touchcarousel-container">
			<xsl:choose>
				<xsl:when test="$nodeTypeAlias = 'Event'">
					<xsl:apply-templates select="$currentPage/Event[@isDoc and not(&hidden;)]">						
						<xsl:sort select="umbraco.library:FormatDateTime(eventEndDate[not(&empty;)],'yyyyMMddHmm')" data-type="number" order="descending" />				
						<xsl:sort select="umbraco.library:FormatDateTime(eventStartDate[not(&empty;)],'yyyyMMddHmm')" data-type="number" order="descending" />
						<xsl:sort select="umbraco.library:FormatDateTime(@createDate,'yyyyMMddHmm')" data-type="number" order="descending" />
					</xsl:apply-templates>
				</xsl:when>
				<xsl:when test="$nodeTypeAlias = 'BlogPost'">
					<xsl:apply-templates select="$currentPage/BlogPost[@isDoc and not(&hidden;)]">					
						<xsl:sort select="umbraco.library:FormatDateTime(postDate[not(&empty;)],'yyyyMMddHmm')" data-type="number" order="descending" />
						<xsl:sort select="umbraco.library:FormatDateTime(@createDate,'yyyyMMddHmm')" data-type="number" order="descending" />
					</xsl:apply-templates>
				</xsl:when>
				<xsl:when test="$nodeTypeAlias = 'Project'">
					<xsl:apply-templates select="$currentPage/Project[@isDoc and not(&hidden;)]">					
						<xsl:sort select="umbraco.library:FormatDateTime(completionDate[not(&empty;)],'yyyyMMddHmm')" data-type="number" order="descending" />
						<xsl:sort select="umbraco.library:FormatDateTime(@createDate,'yyyyMMddHmm')" data-type="number" order="descending" />
					</xsl:apply-templates>
				</xsl:when>
				<xsl:otherwise>
					<li class="touchcarousel-item">
						<section class="no-img">
							<header><h1><xsl:value-of select="$currentPage/pageHeading[not(&empty;)]|$currentPage/@nodeName" /></h1></header>
				
							<div class="img-holder">
								<xsl:comment>&nbsp;</xsl:comment>
							</div>
							
							<time datetime="{$currentPage/@createDate}">
								<p><span>Status: </span> 404... :-(</p>
							</time>
							
							<div class="text-holder">
								<p>Sorry, nothing has been published in the <strong>"<xsl:value-of select="$currentPage/@nodeName" />"</strong> section yet. Please come back soon for updates.</p>
							</div>
						</section>
					</li>
				</xsl:otherwise>
			</xsl:choose>
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
			loopItems: false,            // Loop items (don't disable arrows on last slide and allow autoplay to loop)
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
<!-- :: Includes :: -->		
<xsl:include href="_SingleNode.xslt" />
		
</xsl:stylesheet>