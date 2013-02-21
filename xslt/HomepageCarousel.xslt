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
    
	<xsl:if test="count($slideNodes//item[string(./carouselImage)!='']) &gt; 0">
		<div id="homepage-carousel" class="touchcarousel black-and-white">  
			<ul class="touchcarousel-container">
				<xsl:for-each select="$slideNodes//item[string(./carouselImage)!='']">
					<xsl:sort select="@id" data-type="number" order="ascending" />
					<xsl:variable name="media" select="umbraco.library:GetMedia(./carouselImage,false)" />
					<xsl:if test="$media[not(error)]">
						<li class="touchcarousel-item">
							<xsl:choose>
								<xsl:when test="string(./imageLink)!=''">
									<xsl:variable name="href" select="umbraco.library:NiceUrl(./imageLink)" />
									<a href="{$href}">
										<xsl:apply-templates select="$media" mode="media">
											<xsl:with-param name="imgGen">true</xsl:with-param>
											<xsl:with-param name="height">540</xsl:with-param>
											<xsl:with-param name="compress">100</xsl:with-param>
										</xsl:apply-templates>
										<xsl:if test="string(./overlayText)!=''">
											<span class="overlay-txt"><xsl:value-of select="./overlayText" /></span>
										</xsl:if>
									</a>
								</xsl:when>
								<xsl:otherwise>
									<xsl:apply-templates select="$media" mode="media">
										<xsl:with-param name="imgGen">true</xsl:with-param>
										<xsl:with-param name="height">540</xsl:with-param>
										<xsl:with-param name="compress">100</xsl:with-param>
									</xsl:apply-templates>
									<xsl:if test="string(./overlayText)!=''">
										<span class="overlay-txt"><xsl:value-of select="./overlayText" /></span>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</li>
					</xsl:if>
				</xsl:for-each>
			</ul>		
		</div>
		
		<script>
		<![CDATA[
			$(document).ready(function(){
				
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
					onAnimComplete: function() { console.log('complete',this.getCurrentId()); },
					onDragStart:null,
					onDragRelease: null
				});
				
			});
		]]>
		</script>
		
    </xsl:if>
    
</xsl:template>

<xsl:include href="_MediaHelperInclude.xslt" />
		
</xsl:stylesheet>