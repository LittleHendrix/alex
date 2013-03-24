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
	xmlns:UCommentLibrary="urn:UCommentLibrary"
	xmlns:TagsLib="urn:TagsLib"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" xmlns:uTube.XSLT="urn:uTube.XSLT" xmlns:ucomponents.xml="urn:ucomponents.xml" xmlns:google.maps="urn:google.maps" 
	exclude-result-prefixes="msxml umbraco.library UCommentLibrary TagsLib Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets uTube.XSLT ucomponents.xml google.maps ">


<xsl:output method="html" indent="yes" omit-xml-declaration="yes"/>
	
	
<xsl:template match="Event">
	
	<xsl:variable name="hasMediaFolder">
		<xsl:choose>
			<xsl:when test="pageMedia//mediaItem[1]/Folder/@id[not(&empty;)]">
				<xsl:value-of select="pageMedia//mediaItem[1]/Folder/@id" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="''" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>	
	
	<li class="touchcarousel-item">
		<article>
			<xsl:if test="string(pageMedia//mediaItem[1]/Image)='' and string($hasMediaFolder)=''">
				<xsl:attribute name="class">no-img</xsl:attribute>
			</xsl:if>
			
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
			
			<xsl:variable name="pastEvt">
				<xsl:choose>
					<xsl:when test="eventEndDate[not(&empty;)]">
						<xsl:value-of select="not(umbraco.library:DateGreaterThanOrEqualToday(eventEndDate))" />
					</xsl:when>
					<xsl:when test="eventStartDate[not(&empty;)]">
						<xsl:value-of select="not(umbraco.library:DateGreaterThanOrEqualToday(eventStartDate))" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="not(umbraco.library:DateGreaterThanOrEqualToday(@createDate))" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<header><h1><a>
				<xsl:attribute name="href"><xsl:value-of select="&NiceUrl;(@id)" />
				<xsl:if test="string($pastEvt)='true'"><xsl:text>?alttemplate=EventPast&amp;pastEvent=true</xsl:text></xsl:if>
				</xsl:attribute>
				<xsl:value-of select="umbraco.library:TruncateString((pageHeading[not(&empty;)]|@nodeName)[last()],24,'...')" /></a></h1></header>

			<div class="img-holder">
				<xsl:if test="pageMedia//mediaItem[1]/Image[not(&empty;)]">
					<xsl:apply-templates select="pageMedia//mediaItem[1]/Image">
						<xsl:with-param name="imgGen">true</xsl:with-param>
						<xsl:with-param name="width">338</xsl:with-param>
						<xsl:with-param name="compress">100</xsl:with-param>
						<xsl:with-param name="allowUmbMeasure">false</xsl:with-param>
					</xsl:apply-templates>
				</xsl:if>
				<xsl:if test="pageMedia//mediaItem[1]/Folder/@id[not(&empty;)]">
					<xsl:apply-templates select="pageMedia//mediaItem[1]/Folder/@id" mode="folder">
						<xsl:with-param name="getFirstItem">true</xsl:with-param>
						<xsl:with-param name="imgGen">true</xsl:with-param>
						<xsl:with-param name="width">338</xsl:with-param>
						<xsl:with-param name="compress">100</xsl:with-param>
						<xsl:with-param name="allowUmbMeasure">false</xsl:with-param>
					</xsl:apply-templates>
				</xsl:if>
			</div>
			
			<time class="meta" datetime="{(eventStartDate[not(&empty;)]|eventEndDate[not(&empty;)]|@createDate)[last()]}">
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
				<xsl:if test="iCalLocation[not(&empty;)]">
					<div class="location meta">
						<p><span>Location: </span><xsl:value-of select="iCalLocation" /></p>
					</div>
				</xsl:if>
				
				<xsl:call-template name="firstWords">
					<xsl:with-param name="TextData" select="bodyText[not(&empty;)]|metaDescription" />
					<xsl:with-param name="WordCount" select="35" />
					<xsl:with-param name="Ellipsis" select="'...'" />
				</xsl:call-template>
			</div>
			<div class="sec-link"><a class="perma-link evt">
				<xsl:attribute name="href"><xsl:value-of select="&NiceUrl;(@id)" />
				<xsl:if test="string($pastEvt)='true'"><xsl:text>?alttemplate=EventPast&amp;pastEvent=true</xsl:text></xsl:if>
				</xsl:attribute>
				Read more</a></div>
		</article>
	</li>

</xsl:template>
		
<xsl:template match="BlogPost">
	<xsl:param name="tag" />
	
	<xsl:variable name="hasMediaFolder">
		<xsl:choose>
			<xsl:when test="pageMedia//mediaItem[1]/Folder/@id[not(&empty;)]">
				<xsl:value-of select="pageMedia//mediaItem[1]/Folder/@id" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="''" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>	
	
	<xsl:choose>
		<xsl:when test="string($tag)!=''">
			<xsl:variable name="thisTag" select="Exslt.ExsltStrings:lowercase(tags)" />
			<xsl:if test="tags[not(&empty;)] and contains(concat($thisTag,','),concat($tag,','))">
				
	<li class="touchcarousel-item">
		<article>
			<xsl:if test="string(pageMedia//mediaItem[1]/Image)='' and string($hasMediaFolder)=''">
				<xsl:attribute name="class">no-img</xsl:attribute>
			</xsl:if>
			<header><h1><a href="{&NiceUrl;(@id)}"><xsl:value-of select="umbraco.library:TruncateString((pageHeading[not(&empty;)]|@nodeName)[last()],24,'...')" /></a></h1></header>

			<div class="img-holder">
				<xsl:if test="pageMedia//mediaItem[1]/Image[not(&empty;)]">
					<xsl:apply-templates select="pageMedia//mediaItem[1]/Image">
						<xsl:with-param name="imgGen">true</xsl:with-param>
						<xsl:with-param name="width">338</xsl:with-param>
						<xsl:with-param name="compress">100</xsl:with-param>
						<xsl:with-param name="allowUmbMeasure">false</xsl:with-param>
					</xsl:apply-templates>
				</xsl:if>
				<xsl:if test="pageMedia//mediaItem[1]/Folder/@id[not(&empty;)]">
					<xsl:apply-templates select="pageMedia//mediaItem[1]/Folder/@id" mode="folder">
						<xsl:with-param name="getFirstItem">true</xsl:with-param>
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
						<xsl:apply-templates select="postDate" mode="longDateNoTime" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="@createDate" mode="longDateNoTime" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<time class="meta" datetime="{(postDate[not(&empty;)]|@createDate)[last()]}">
				<p><span>Post on: </span><xsl:value-of select="$postDate" /></p>
			</time>
			
			<div class="comments meta">
				<xsl:variable name="numOfComments" select="count(UCommentLibrary:GetCommentsForNode(@id)//comment)" />
				<xsl:choose>
					<xsl:when test="string($numOfComments) = '' or string($numOfComments) = 'NaN' or number($numOfComments) &lt;= 0">
						<p><a href="{&NiceUrl;(@id)}?blog-comments=show">Leave a comment</a></p>
					</xsl:when>
					<xsl:otherwise>
						<p><a href="{&NiceUrl;(@id)}?blog-comments=show"><span><xsl:value-of select="$numOfComments" /></span> comment<xsl:if test="number($numOfComments) &gt; 1"><xsl:text>s</xsl:text></xsl:if></a></p>
					</xsl:otherwise>
				</xsl:choose>
			</div>
			
			<div class="text-holder">
				
				<div class="tags meta">
					<xsl:if test="tags[not(&empty;)]">
						<p><span>Tags: </span>
							<xsl:for-each select="TagsLib:getTagsFromNode(@id)/tags/tag">
								<xsl:variable name="cleanTag" select="Exslt.ExsltStrings:lowercase(.)" />
								<xsl:choose>
									<xsl:when test="contains($cleanTag,$tag)">
										<span class="cur"><xsl:value-of select="." /></span>
										<xsl:if test="position() !=  last()"><xsl:text>, </xsl:text></xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<a href="?tag={$cleanTag}"><xsl:value-of select="." /></a>
										<xsl:if test="position() !=  last()"><xsl:text>, </xsl:text></xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</p>
					</xsl:if>
				</div>
				
				<xsl:call-template name="firstWords">
					<xsl:with-param name="TextData" select="bodyText[not(&empty;)]|metaDescription" />
					<xsl:with-param name="WordCount" select="35" />
					<xsl:with-param name="Ellipsis" select="'...'" />
				</xsl:call-template>
			</div>
			<div class="sec-link"><a href="{&NiceUrl;(@id)}" class="perma-link post">Read more</a></div>
		</article>
	</li>
				
			</xsl:if>
			
		</xsl:when>
		<xsl:otherwise>
			
	<li class="touchcarousel-item">
		<article>
			<xsl:if test="string(pageMedia//mediaItem[1]/Image)='' and string($hasMediaFolder)=''">
				<xsl:attribute name="class">no-img</xsl:attribute>
			</xsl:if>
			<header><h1><a href="{&NiceUrl;(@id)}"><xsl:value-of select="umbraco.library:TruncateString((pageHeading[not(&empty;)]|@nodeName)[last()],24,'...')" /></a></h1></header>

			<div class="img-holder">
				<xsl:if test="pageMedia//mediaItem[1]/Image[not(&empty;)]">
					<xsl:apply-templates select="pageMedia//mediaItem[1]/Image">
						<xsl:with-param name="imgGen">true</xsl:with-param>
						<xsl:with-param name="width">338</xsl:with-param>
						<xsl:with-param name="compress">100</xsl:with-param>
						<xsl:with-param name="allowUmbMeasure">false</xsl:with-param>
					</xsl:apply-templates>
				</xsl:if>
				<xsl:if test="pageMedia//mediaItem[1]/Folder/@id[not(&empty;)]">
					<xsl:apply-templates select="pageMedia//mediaItem[1]/Folder/@id" mode="folder">
						<xsl:with-param name="getFirstItem">true</xsl:with-param>
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
						<xsl:apply-templates select="postDate" mode="longDateNoTime" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="@createDate" mode="longDateNoTime" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<time class="meta" datetime="{(postDate[not(&empty;)]|@createDate)[last()]}">
				<p><span>Post on: </span><xsl:value-of select="$postDate" /></p>
			</time>
			
			<div class="comments meta">
				<xsl:variable name="numOfComments" select="count(UCommentLibrary:GetCommentsForNode(@id)//comment)" />
				<xsl:choose>
					<xsl:when test="string($numOfComments) = '' or string($numOfComments) = 'NaN' or number($numOfComments) &lt;= 0">
						<p><a href="{&NiceUrl;(@id)}?blog-comments=show">Leave a comment</a></p>
					</xsl:when>
					<xsl:otherwise>
						<p><a href="{&NiceUrl;(@id)}?blog-comments=show"><span><xsl:value-of select="$numOfComments" /></span> comment<xsl:if test="number($numOfComments) &gt; 1"><xsl:text>s</xsl:text></xsl:if></a></p>
					</xsl:otherwise>
				</xsl:choose>
			</div>
			
			<div class="text-holder">
				
				<xsl:if test="tags[not(&empty;)]">
					<div class="tags meta">
						<p><span>Tags: </span>
							<xsl:for-each select="TagsLib:getTagsFromNode(@id)/tags/tag">
								<xsl:variable name="cleanTag" select="Exslt.ExsltStrings:lowercase(.)" />
								<a href="?tag={$cleanTag}"><xsl:value-of select="." /></a>
								<xsl:if test="position() !=  last()"><xsl:text>, </xsl:text></xsl:if>
							</xsl:for-each>
						</p>
					</div>
				</xsl:if>
				
				<xsl:call-template name="firstWords">
					<xsl:with-param name="TextData" select="bodyText[not(&empty;)]|metaDescription" />
					<xsl:with-param name="WordCount" select="35" />
					<xsl:with-param name="Ellipsis" select="'...'" />
				</xsl:call-template>
			</div>
			<div class="sec-link"><a href="{&NiceUrl;(@id)}" class="perma-link post">Read more</a></div>
		</article>
	</li>
		
		</xsl:otherwise>
	</xsl:choose>

</xsl:template>	
		
<xsl:template match="Project">
	<xsl:param name="type" />
	<xsl:param name="display" />
	
	<xsl:variable name="hasMediaFolder">
		<xsl:choose>
			<xsl:when test="pageMedia//mediaItem[1]/Folder/@id[not(&empty;)]">
				<xsl:value-of select="pageMedia//mediaItem[1]/Folder/@id" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="''" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:choose>
		<xsl:when test="string($display)!=''">
			<xsl:variable name="mod" select="number(6)" />
			
			<xsl:if test="position() = 1 or position() mod $mod = 1">
			<xsl:text disable-output-escaping="yes"><![CDATA[<li class="touchcarousel-item tile">]]></xsl:text>
			</xsl:if>
			
				<div class="tile-wrap">
					<a href="{&NiceUrl;(@id)}" data-title="{@nodeName}">
				<xsl:if test="pageMedia//mediaItem[1]/Image[not(&empty;)]">
					<xsl:apply-templates select="pageMedia//mediaItem[1]/Image">
						<xsl:with-param name="imgGen">true</xsl:with-param>
						<xsl:with-param name="width">170</xsl:with-param>
						<xsl:with-param name="height">170</xsl:with-param>
						<xsl:with-param name="compress">100</xsl:with-param>
						<xsl:with-param name="allowUmbMeasure">false</xsl:with-param>
						<xsl:with-param name="getCrop">false</xsl:with-param>
					</xsl:apply-templates>
				</xsl:if>
				<xsl:if test="pageMedia//mediaItem[1]/Folder/@id[not(&empty;)]">
					<xsl:apply-templates select="pageMedia//mediaItem[1]/Folder/@id" mode="folder">
						<xsl:with-param name="getFirstItem">true</xsl:with-param>
						<xsl:with-param name="imgGen">true</xsl:with-param>
						<xsl:with-param name="width">170</xsl:with-param>
						<xsl:with-param name="height">170</xsl:with-param>
						<xsl:with-param name="compress">100</xsl:with-param>
						<xsl:with-param name="allowUmbMeasure">false</xsl:with-param>
						<xsl:with-param name="getCrop">false</xsl:with-param>
					</xsl:apply-templates>
				</xsl:if>
					<xsl:comment>&nbsp;</xsl:comment>
					</a>
				</div>
			<xsl:if test="position() = $mod or position() mod $mod = 0">
			<xsl:text disable-output-escaping="yes"><![CDATA[</li>]]></xsl:text>
			</xsl:if>
		</xsl:when>
		<xsl:otherwise><!-- list display -->
			
	<xsl:choose>
		<xsl:when test="string($type)!=''">
			
			<xsl:variable name="thisTypes">
				<xsl:choose>
				<xsl:when test="type[not(&empty;)]">
				<xsl:for-each select="type//nodeId">
					<xsl:value-of select="Exslt.ExsltStrings:lowercase(umbraco.library:GetXmlNodeById(.)/@nodeName)" />
				</xsl:for-each>
				</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="''" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>			
			
			<xsl:if test="type[not(&empty;)] and contains($thisTypes,$type)">
			
	<li class="touchcarousel-item proj-item">
		<article>
			<xsl:if test="string(pageMedia//mediaItem[1]/Image)='' and string($hasMediaFolder)=''">
				<xsl:attribute name="class">no-img</xsl:attribute>
			</xsl:if>
			<div class="img-holder">
				<xsl:if test="pageMedia//mediaItem[1]/Image[not(&empty;)]">
					<xsl:apply-templates select="pageMedia//mediaItem[1]/Image">
						<xsl:with-param name="imgGen">true</xsl:with-param>
						<xsl:with-param name="height">540</xsl:with-param>
						<xsl:with-param name="compress">100</xsl:with-param>
						<xsl:with-param name="allowUmbMeasure">false</xsl:with-param>
					</xsl:apply-templates>
				</xsl:if>
				<xsl:if test="pageMedia//mediaItem[1]/Folder/@id[not(&empty;)]">
					<xsl:apply-templates select="pageMedia//mediaItem[1]/Folder/@id" mode="folder">
						<xsl:with-param name="getFirstItem">true</xsl:with-param>
						<xsl:with-param name="imgGen">true</xsl:with-param>
						<xsl:with-param name="height">540</xsl:with-param>
						<xsl:with-param name="compress">100</xsl:with-param>
						<xsl:with-param name="allowUmbMeasure">false</xsl:with-param>
					</xsl:apply-templates>
				</xsl:if>
			</div>
			
			<xsl:variable name="completeDate">
				<xsl:choose>
					<xsl:when test="completionDate[not(&empty;)]">
						<xsl:apply-templates select="completionDate" mode="monthYear" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="@createDate" mode="monthYear" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<div class="text-holder">

			<header><h1><a href="{&NiceUrl;(@id)}"><xsl:value-of select="umbraco.library:TruncateString((pageHeading[not(&empty;)]|@nodeName)[last()],24,'...')" /></a></h1></header>

			<time class="meta" datetime="{(completionDate[not(&empty;)]|@createDate)[last()]}">
				<xsl:if test="string($completeDate)!=''">
					<p><xsl:value-of select="$completeDate" /></p>
				</xsl:if>
			</time>
			<xsl:if test="type[not(&empty;)]">
				<div class="type meta">
					<p><span>Type: </span>
						<xsl:apply-templates select="type" mode="multipicker" />
					</p>
				</div>
			</xsl:if>
				<!--
				<xsl:call-template name="firstWords">
					<xsl:with-param name="TextData" select="bodyText[not(&empty;)]|metaDescription" />
					<xsl:with-param name="WordCount" select="35" />
					<xsl:with-param name="Ellipsis" select="'...'" />
				</xsl:call-template>
-->
			</div><!--
			<div class="sec-link"><a href="{&NiceUrl;(@id)}" class="perma-link proj">Read more</a></div>
-->
		</article>
	</li>
			</xsl:if>
		</xsl:when>
		<xsl:otherwise>
	<li class="touchcarousel-item proj-item">
		<article>
			<xsl:if test="string(pageMedia//mediaItem[1]/Image)='' and string($hasMediaFolder)=''">
				<xsl:attribute name="class">no-img</xsl:attribute>
			</xsl:if>
			<div class="img-holder">
				<xsl:if test="pageMedia//mediaItem[1]/Image[not(&empty;)]">
					<xsl:apply-templates select="pageMedia//mediaItem[1]/Image">
						<xsl:with-param name="imgGen">true</xsl:with-param>
						<xsl:with-param name="height">540</xsl:with-param>
						<xsl:with-param name="compress">100</xsl:with-param>
						<xsl:with-param name="allowUmbMeasure">false</xsl:with-param>
					</xsl:apply-templates>
				</xsl:if>
				<xsl:if test="pageMedia//mediaItem[1]/Folder/@id[not(&empty;)]">
					<xsl:apply-templates select="pageMedia//mediaItem[1]/Folder/@id" mode="folder">
						<xsl:with-param name="getFirstItem">true</xsl:with-param>
						<xsl:with-param name="imgGen">true</xsl:with-param>
						<xsl:with-param name="height">540</xsl:with-param>
						<xsl:with-param name="compress">100</xsl:with-param>
						<xsl:with-param name="allowUmbMeasure">false</xsl:with-param>
					</xsl:apply-templates>
				</xsl:if>
			</div>
			<xsl:variable name="completeDate">
				<xsl:choose>
					<xsl:when test="completionDate[not(&empty;)]">
						<xsl:apply-templates select="completionDate" mode="monthYear" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="@createDate" mode="monthYear" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<div class="text-holder">

			<header><h1><a href="{&NiceUrl;(@id)}"><xsl:value-of select="umbraco.library:TruncateString((pageHeading[not(&empty;)]|@nodeName)[last()],24,'...')" /></a></h1></header>

			<time class="meta" datetime="{(completionDate[not(&empty;)]|@createDate)[last()]}">
				<xsl:if test="string($completeDate)!=''">
					<p><xsl:value-of select="$completeDate" /></p>
				</xsl:if>
			</time>
			<xsl:if test="type[not(&empty;)]">
				<div class="type meta">
					<p><span>Type: </span>
						<xsl:apply-templates select="type" mode="multipicker" />
					</p>
				</div>
			</xsl:if>
				<!--
				<xsl:call-template name="firstWords">
					<xsl:with-param name="TextData" select="bodyText[not(&empty;)]|metaDescription" />
					<xsl:with-param name="WordCount" select="35" />
					<xsl:with-param name="Ellipsis" select="'...'" />
				</xsl:call-template>
				-->
			</div><!--
			<div class="sec-link"><a href="{&NiceUrl;(@id)}" class="perma-link proj">Read more</a></div>
-->
		</article>
	</li>
		</xsl:otherwise>
	</xsl:choose>
			
		</xsl:otherwise>
	</xsl:choose>

</xsl:template>

<!-- :: Helper Templates :: -->
<xsl:template match="* | @*" mode="longDate">
	<xsl:variable name="endings" select="umbraco.library:Split('st,nd,rd,th,th,th,th,th,th,th,th,th,th,th,th,th,th,th,th,th,st,nd,rd,th,th,th,th,th,th,th,st',',')"/>
	<xsl:variable name="pos" select="number(substring(.,9,2))" />
	<!--
	<xsl:value-of select="umbraco.library:FormatDateTime(.,'ddd, dd MMMM yyyy - H:mmtt')" />
	-->
	<xsl:value-of select="concat(umbraco.library:FormatDateTime(.,'ddd, d'),msxsl:node-set($endings)//value[$pos],umbraco.library:FormatDateTime(.,' MMMM yyyy - H:mmtt'))"/>
</xsl:template>
<xsl:template match="* | @*" mode="longDateNoTime">
	<xsl:variable name="endings" select="umbraco.library:Split('st,nd,rd,th,th,th,th,th,th,th,th,th,th,th,th,th,th,th,th,th,st,nd,rd,th,th,th,th,th,th,th,st',',')"/>
	<xsl:variable name="pos" select="number(substring(.,9,2))" />
	<xsl:value-of select="concat(umbraco.library:FormatDateTime(.,'ddd, d'),msxsl:node-set($endings)//value[$pos],umbraco.library:FormatDateTime(.,' MMMM yyyy'))"/>
</xsl:template>
<xsl:template match="* | @*" mode="monthYear">
	<xsl:value-of select="umbraco.library:FormatDateTime(.,'MMMM yyyy')" />
</xsl:template>
<xsl:template match="ProjectType">
	<xsl:param name="nodeIds" />
	
	<xsl:variable name="curType" select="umbraco.library:RequestQueryString('type')" />
	<xsl:variable name="cleanType" select="Exslt.ExsltStrings:lowercase(normalize-space(@nodeName))" />
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
	<xsl:choose>
		<xsl:when test="string($curType)!='' and contains($cleanType,$curType)">
			<span class="cur"><xsl:value-of select="@nodeName" /></span>
		</xsl:when>
		<xsl:otherwise>
			<a href="/work/?type={$cleanType}"><xsl:value-of select="@nodeName" /></a>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
		
<!-- :: Includes :: -->		
<xsl:include href="_FirstWords.xslt" />
<xsl:include href="_MediaHelper.xslt" />
<xsl:include href="_MultiPickerHelper.xslt" />

</xsl:stylesheet>