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
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" xmlns:uTube.XSLT="urn:uTube.XSLT" xmlns:ucomponents.xml="urn:ucomponents.xml" xmlns:google.maps="urn:google.maps" 
	exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets uTube.XSLT ucomponents.xml google.maps ">


<xsl:output method="html" indent="yes" omit-xml-declaration="yes"/>
	
<xsl:template match="Event">
	
	<li class="touchcarousel-item">
		<section>
			<xsl:if test="string(pageMedia//mediaItem[1]/Image)=''">
				<xsl:attribute name="class">no-img</xsl:attribute>
			</xsl:if>
			<header><h1><xsl:value-of select="pageHeading[not(&empty;)]|metaTitle[not(&empty;)]|@nodeName " /></h1></header>

			<div class="img-holder">
				<xsl:if test="pageMedia//mediaItem[1]/Image[not(&empty;)]">
					<xsl:apply-templates select="pageMedia//mediaItem[1]/Image">
						<xsl:with-param name="imgGen">true</xsl:with-param>
						<xsl:with-param name="width">338</xsl:with-param>
						<xsl:with-param name="compress">100</xsl:with-param>
						<xsl:with-param name="allowUmbMeasure">false</xsl:with-param>
					</xsl:apply-templates>
				</xsl:if>
			</div>
			
			<xsl:variable name="startDate">
				<xsl:choose>
					<xsl:when test="eventStartDate[not(&empty;)]">
						<xsl:apply-templates select="eventStartDate" mode="longDate" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="@createDate" mode="longDate" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="endDate">
				<xsl:choose>
					<xsl:when test="eventEndDate[not(&empty;)]">
						<xsl:apply-templates select="eventEndDate" mode="longDate" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$startDate" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<time datetime="{(eventStartDate[not(&empty;)]|eventEndDate[not(&empty;)]|@createDate)[last()]}">
				<xsl:choose>
					<xsl:when test="oneDayEvent[text()='1'] or $startDate = $endDate">
						<p><xsl:value-of select="$endDate" /></p>
					</xsl:when>
					<xsl:otherwise>
						<p><span>Debut: </span><xsl:value-of select="$startDate" /></p>
						<p><span>Finale: </span><xsl:value-of select="$endDate" /></p>
					</xsl:otherwise>
				</xsl:choose>
			</time>
			
			<div class="text-holder">
				<xsl:call-template name="firstWords">
					<xsl:with-param name="TextData" select="bodyText[not(&empty;)]|metaDescription" />
					<xsl:with-param name="WordCount" select="50" />
					<xsl:with-param name="Ellipsis" select="'...'" />
				</xsl:call-template>
			<p><a href="{&NiceUrl;(@id)}" class="more">Read more</a></p>
			</div>
		</section>
	</li>

</xsl:template>
		
<xsl:template match="BlogPost">
	
	<li class="touchcarousel-item">
		<section>
			<xsl:if test="string(pageMedia//mediaItem[1]/Image)=''">
				<xsl:attribute name="class">no-img</xsl:attribute>
			</xsl:if>
			<header><h1><xsl:value-of select="pageHeading[not(&empty;)]|metaTitle[not(&empty;)]|@nodeName " /></h1></header>

			<div class="img-holder">
				<xsl:if test="pageMedia//mediaItem[1]/Image[not(&empty;)]">
					<xsl:apply-templates select="pageMedia//mediaItem[1]/Image">
						<xsl:with-param name="imgGen">true</xsl:with-param>
						<xsl:with-param name="width">338</xsl:with-param>
						<xsl:with-param name="compress">100</xsl:with-param>
						<xsl:with-param name="allowUmbMeasure">false</xsl:with-param>
					</xsl:apply-templates>
				</xsl:if>
			</div>
			
			<xsl:variable name="postDate">
				<xsl:choose>
					<xsl:when test="postDate[not(&empty;)]">
						<xsl:apply-templates select="postDate" mode="longDate" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="@createDate" mode="longDate" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<time datetime="{(postDate[not(&empty;)]|@createDate)[last()]}">
				<p><span>Post on: </span><xsl:value-of select="$postDate" /></p>
			</time>
			
			<div class="text-holder">
				<xsl:call-template name="firstWords">
					<xsl:with-param name="TextData" select="bodyText[not(&empty;)]|metaDescription" />
					<xsl:with-param name="WordCount" select="50" />
					<xsl:with-param name="Ellipsis" select="'...'" />
				</xsl:call-template>
			<p><a href="{&NiceUrl;(@id)}" class="more">Read more</a></p>
			</div>
		</section>
	</li>

</xsl:template>	
		
<xsl:template match="Project">
	
	<li class="touchcarousel-item">
		<section>
			<xsl:if test="string(pageMedia//mediaItem[1]/Image)=''">
				<xsl:attribute name="class">no-img</xsl:attribute>
			</xsl:if>
			<header><h1><xsl:value-of select="pageHeading[not(&empty;)]|metaTitle[not(&empty;)]|@nodeName " /></h1></header>

			<div class="img-holder">
				<xsl:if test="pageMedia//mediaItem[1]/Image[not(&empty;)]">
					<xsl:apply-templates select="pageMedia//mediaItem[1]/Image">
						<xsl:with-param name="imgGen">true</xsl:with-param>
						<xsl:with-param name="width">338</xsl:with-param>
						<xsl:with-param name="compress">100</xsl:with-param>
						<xsl:with-param name="allowUmbMeasure">false</xsl:with-param>
					</xsl:apply-templates>
				</xsl:if>
			</div>
			
			<xsl:variable name="commenceDate">
				<xsl:choose>
					<xsl:when test="commencementDate[not(&empty;)]">
						<xsl:apply-templates select="commencementDate" mode="longDate" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="@createDate" mode="longDate" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="completeDate">
				<xsl:choose>
					<xsl:when test="completionDate[not(&empty;)]">
						<xsl:apply-templates select="completionDate" mode="longDate" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$commenceDate" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<time datetime="{(commencementDate[not(&empty;)]|completionDate[not(&empty;)]|@createDate)[last()]}">
				<xsl:choose>
					<xsl:when test="$commenceDate = $completeDate">
						<p><span>Completed: </span><xsl:value-of select="$completeDate" /></p>
					</xsl:when>
					<xsl:otherwise>
						<p><span>Started: </span><xsl:value-of select="$commenceDate" /></p>
						<p><span>Completed: </span><xsl:value-of select="$completeDate" /></p>
					</xsl:otherwise>
				</xsl:choose>
			</time>
			
			<div class="text-holder">
				<xsl:call-template name="firstWords">
					<xsl:with-param name="TextData" select="bodyText[not(&empty;)]|metaDescription" />
					<xsl:with-param name="WordCount" select="50" />
					<xsl:with-param name="Ellipsis" select="'...'" />
				</xsl:call-template>
			<p><a href="{&NiceUrl;(@id)}" class="more">Read more</a></p>
			</div>
		</section>
	</li>

</xsl:template>

<!-- :: Helper Templates :: -->
<xsl:template match="* | @*" mode="longDate">
	<xsl:value-of select="umbraco.library:FormatDateTime(.,'ddd, dd MMMM yyyy - hh:mm tt')" />
</xsl:template>
		
<!-- :: Includes :: -->		
<xsl:include href="_FirstWords.xslt" />
<xsl:include href="_MediaHelper.xslt" />

</xsl:stylesheet>