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
	<xsl:variable name="speed" select="$currentPage/transitionSpeed[not(@isDoc)]" />
	<xsl:variable name="itemWidth" select="number($currentPage/slideItemWidth[not(@isDoc)])" />
	
	<xsl:variable name="cleanWidth">
		<xsl:choose>
			<xsl:when test="string($itemWidth) = '' or string($itemWidth) = 'NaN' or $itemWidth &lt; 100 or $itemWidth &gt; 960">
				<xsl:value-of select="number(500)" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$itemWidth" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
    
	<xsl:if test="count($slideNodes//nodeId[string(.)!='']) &gt; 0">
		<div id="homepage-carousel" class="touchcarousel black-and-white">  
			<ul class="touchcarousel-container">
				<xsl:for-each select="$slideNodes//nodeId[string(.)!='']">
					<xsl:variable name="media" select="umbraco.library:GetXmlNodeById(.)" />
					<xsl:if test="$media[not(error)] and string($media//umbracoFile)!=''">
						<li class="touchcarousel-item">
							<xsl:apply-templates select="$media//Image" mode="media">
								<xsl:with-param name="imgGen">true</xsl:with-param>
								<xsl:with-param name="height">540</xsl:with-param>
								<xsl:with-param name="compress">100</xsl:with-param>
							</xsl:apply-templates>
							<xsl:if test="string($media/slideHeading)!='' or string($media/slideContent)!=''">
								<div class="mask">
									<xsl:choose>
										<xsl:when test="string($media/slideHeading)!=''">
											<h2><xsl:value-of select="$media/slideHeading" /></h2>
										</xsl:when>
										<xsl:otherwise>
											<h2><xsl:value-of select="umbraco.library:Replace($media/slideMedia//Image/@nodeName,'_',' ')" /></h2>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:if test="string($media/slideContent)!=''">
										<p><xsl:value-of select="umbraco.library:ReplaceLineBreaks($media/slideContent)" disable-output-escaping="yes" /></p>
									</xsl:if>
									<xsl:if test="string($media/slideLink//url)!=''">
										<a href="{$media/slideLink//url}" data-title="{$media/slideLink//link-title}" class="peek">
											<xsl:if test="string($media/slideLink//new-window)!='False'"><xsl:attribute name="target">_blank</xsl:attribute></xsl:if>
											View details
										</a>
									</xsl:if>
								</div>
							</xsl:if>
						</li>
					</xsl:if>
				</xsl:for-each>
			</ul>		
		</div>
		
		<script>
		<![CDATA[
			$(document).ready(function(){
				var cssWidth = document.documentElement.clientWidth;
   				var devideWidth = window.screen.width;
				if (devideWidth > 359) {
					var timeout = ]]><xsl:value-of select="$timeout" /><![CDATA[,
						speed = ]]><xsl:value-of select="$speed" /><![CDATA[,
						width = ]]><xsl:value-of select="$cleanWidth" /><![CDATA[,
						autoPlay = (]]><xsl:value-of select="$autoPlay" /><![CDATA[ == 1) ? true : false;
					
					$('#homepage-carousel').touchCarousel({
						itemsPerPage: 1,
						//itemsPerMove: 1,
						snapToItems: false,
						pagingNav: false,
						pagingNavControls: false,
						autoplay: autoPlay, 
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

<xsl:include href="_MediaHelperInclude.xslt" />
		
</xsl:stylesheet>