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
	xmlns:fb="http://www.facebook.com/2008/fbml"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" xmlns:uTube.XSLT="urn:uTube.XSLT" xmlns:google.maps="urn:google.maps" 
	exclude-result-prefixes="msxml fb umbraco.library UCommentLibrary TagsLib Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets uTube.XSLT google.maps ">


<xsl:output method="html" omit-xml-declaration="yes"/>

<xsl:param name="currentPage"/>
		
<xsl:variable name="homeNode" select="$currentPage/ancestor-or-self::Homepage[@isDoc]" />
<xsl:variable name="timeout" select="$homeNode/timeout[not(@isDoc)]" />
<xsl:variable name="speed" select="$homeNode/transitionSpeed[not(@isDoc)]" />
<xsl:variable name="itemWidth" select="number(338)" />
<xsl:variable name="blogNode" select="$currentPage/ancestor-or-self::Blog[@isDoc]" />
		
<xsl:template match="/">
	
	<xsl:variable name="hasMediaFolder">
		<xsl:choose>
			<xsl:when test="$currentPage/pageMedia//mediaItem[1]/Folder/@id[not(&empty;)]">
				<xsl:value-of select="$currentPage/pageMedia//mediaItem[1]/Folder/@id" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="''" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>	

	<li class="touchcarousel-item" id="article-slide">
		<article>
			<xsl:if test="string($currentPage/pageMedia//mediaItem[1]/Image)='' and string($hasMediaFolder)=''">
				<xsl:attribute name="class">no-img</xsl:attribute>
			</xsl:if>
			<header>
				<h1><xsl:value-of select="($currentPage/pageHeading[not(&empty;)]|$currentPage/@nodeName)[last()]" /></h1>
			</header>
			<div class="img-holder">
			<xsl:if test="$currentPage/pageMedia//mediaItem[1]/Image[not(&empty;)]">
				<xsl:apply-templates select="$currentPage/pageMedia//mediaItem[1]/Image">
					<xsl:with-param name="imgGen">true</xsl:with-param>
					<xsl:with-param name="width">432</xsl:with-param>
					<xsl:with-param name="compress">100</xsl:with-param>
					<xsl:with-param name="allowUmbMeasure">false</xsl:with-param>
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test="string($hasMediaFolder)!=''">
				<xsl:apply-templates select="$currentPage/pageMedia//mediaItem[1]/Folder/@id" mode="folder">
					<xsl:with-param name="getFirstItem">true</xsl:with-param>
					<xsl:with-param name="imgGen">true</xsl:with-param>
					<xsl:with-param name="width">432</xsl:with-param>
					<xsl:with-param name="compress">100</xsl:with-param>
					<xsl:with-param name="allowUmbMeasure">false</xsl:with-param>
				</xsl:apply-templates>
			</xsl:if>
			</div>
			<xsl:variable name="postDate">
				<xsl:choose>
					<xsl:when test="$currentPage/postDate[not(&empty;)]">
						<xsl:apply-templates select="$currentPage/postDate" mode="longDateNoTime" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="$currentPage/@createDate" mode="longDateNoTime" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<time class="meta" datetime="{($currentPage/postDate[not(&empty;)]|$currentPage/@createDate)[last()]}">
				<p><span>Post on: </span><xsl:value-of select="$postDate" /></p>
			</time>

			<div class="comments meta">
				<div class="p"><a href="?blog-comments=show" class="comment-handle"><div class="fb-comments-count" data-href="{concat('http://',umbraco.library:RequestServerVariables('HTTP_HOST'),&NiceUrl;($currentPage/@id))}">0</div> comments</a></div>
				<!--
				<xsl:variable name="numOfComments" select="count(UCommentLibrary:GetCommentsForNode($currentPage/@id)//comment)" />
				<xsl:choose>
					<xsl:when test="string($numOfComments) = '' or string($numOfComments) = 'NaN' or number($numOfComments) &lt;= 0">
						<p><a href="?blog-comments=show" class="comment-handle">Leave a comment</a></p>
					</xsl:when>
					<xsl:otherwise>
						<p><a href="?blog-comments=show" class="comment-handle"><span><xsl:value-of select="$numOfComments" /></span> comment<xsl:if test="number($numOfComments) &gt; 1"><xsl:text>s</xsl:text></xsl:if></a></p>
					</xsl:otherwise>
				</xsl:choose>
				-->
			</div>
			
			<div class="text-holder">
				<xsl:if test="$currentPage/tags[not(&empty;)]">
					<div class="tags meta">
						<p><span>Tags: </span>
							<xsl:for-each select="TagsLib:getTagsFromNode($currentPage/@id)/tags/tag">
								<xsl:variable name="cleanTag" select="Exslt.ExsltStrings:lowercase(.)" />
								<a href="{&NiceUrl;($blogNode/@id)}?tag={$cleanTag}"><xsl:value-of select="." /></a>
								<xsl:if test="position() !=  last()"><xsl:text>, </xsl:text></xsl:if>
							</xsl:for-each>
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


		<xsl:apply-templates select="$currentPage/pageMedia//mediaItem/Image">
			<xsl:with-param name="imgGen">true</xsl:with-param>
			<xsl:with-param name="height">540</xsl:with-param>
			<xsl:with-param name="compress">100</xsl:with-param>
			<xsl:with-param name="allowUmbMeasure">false</xsl:with-param>
			<xsl:with-param name="isSlide">true</xsl:with-param>
		</xsl:apply-templates>
	
		<xsl:apply-templates select="$currentPage/pageMedia//mediaItem/Video">
			<xsl:with-param name="isSlide">true</xsl:with-param>
		</xsl:apply-templates>
		
		<xsl:if test="string($hasMediaFolder)!=''">
			<xsl:apply-templates select="$currentPage/pageMedia//mediaItem[1]/Folder/@id" mode="folder">
				<xsl:with-param name="imgGen">true</xsl:with-param>
				<xsl:with-param name="height">540</xsl:with-param>
				<xsl:with-param name="compress">100</xsl:with-param>
				<xsl:with-param name="allowUmbMeasure">false</xsl:with-param>
				<xsl:with-param name="isSlide">true</xsl:with-param>
			</xsl:apply-templates>
		</xsl:if>

	
</xsl:template>
		
<!-- :: Helper Templates :: -->
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
	<xsl:value-of select="@nodeName" />
</xsl:template>
	
<!-- :: Includes :: -->	
<xsl:include href="_WYSIWYG.xslt" />
<xsl:include href="_MediaHelper.xslt" />
<xsl:include href="_MultiPickerHelper.xslt" />
</xsl:stylesheet>