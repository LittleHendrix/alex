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
				<xsl:for-each select="$slideNodes//nodeId[not(&empty;)]">
					<xsl:variable name="media" select="umbraco.library:GetXmlNodeById(.)" />
					<xsl:if test="$media[not(error)] and $media//umbracoFile[not(&empty;)]">
						<li class="touchcarousel-item">
							<xsl:if test="media/slideHeading[not(&empty;)] or $media/slideContent[not(&empty;)] or $media/slideLink//url[not(&empty;)]">
								<xsl:attribute name="class">touchcarousel-item has-overlay</xsl:attribute>
							</xsl:if>
							<xsl:apply-templates select="$media//Image">
								<xsl:with-param name="imgGen">true</xsl:with-param>
								<xsl:with-param name="height">540</xsl:with-param>
								<xsl:with-param name="compress">100</xsl:with-param>
							</xsl:apply-templates>
							<xsl:if test="$media/slideHeading[not(&empty;)] or $media/slideContent[not(&empty;)] or $media/slideLink//url[not(&empty;)]">
								<div class="mask">
									<xsl:choose>
										<xsl:when test="$media/slideLink//url[not(&empty;)]">
											<h2><a href="{$media/slideLink//url}" data-title="{$media/slideLink//link-title}">
												<xsl:if test="string($media/slideLink//new-window)!='False'"><xsl:attribute name="target">_blank</xsl:attribute></xsl:if>
												<xsl:value-of select="$media/slideHeading[not(&empty;)]|$media/@nodeName" />
												</a>
											</h2>
										</xsl:when>
										<xsl:otherwise>
											<h2><xsl:value-of select="$media/slideHeading[not(&empty;)]|$media/@nodeName" /></h2>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:if test="$media/slideContent[not(&empty;)]">
										<p><xsl:value-of select="umbraco.library:ReplaceLineBreaks($media/slideContent)" disable-output-escaping="yes" /></p>
									</xsl:if>
									<xsl:if test="$media/slideLink//url[not(&empty;)]">
										<xsl:variable name="linkType">
											<xsl:choose>
												<xsl:when test="$media/slideLink//node-id[not(&empty;)]">
													<xsl:variable name="node" select="umbraco.library:GetXmlNodeById($media/slideLink//node-id)" />
													<xsl:choose>
														<xsl:when test="$node[not(error)]">
															<xsl:variable name="nodeType" select="local-name($node)" />
															<xsl:choose>
																<xsl:when test="string($nodeType)='Project'">
																	<xsl:value-of select="'proj'" />
																</xsl:when>
																<xsl:when test="string($nodeType)='Event'">
																	<xsl:value-of select="'evt'" />
																</xsl:when>
															</xsl:choose>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="''" />
														</xsl:otherwise>
													</xsl:choose>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="''" />
												</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
										<a href="{$media/slideLink//url}" data-title="{$media/slideLink//link-title}" class="peek {$linkType}">
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
		
    </xsl:if>
    
</xsl:template>

<xsl:include href="_MediaHelper.xslt" />
		
</xsl:stylesheet>