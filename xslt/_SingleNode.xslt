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
			<header><h1><a href="{&NiceUrl;(@id)}"><xsl:value-of select="pageHeading[not(&empty;)]|metaTitle[not(&empty;)]|@nodeName " /></a></h1></header>

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
			</div>
			<div class="sec-link"><a href="{&NiceUrl;(@id)}" class="perma-link evt">Read more</a></div>
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
			<header><h1><a href="{&NiceUrl;(@id)}"><xsl:value-of select="pageHeading[not(&empty;)]|metaTitle[not(&empty;)]|@nodeName " /></a></h1></header>

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
			
			<time datetime="{(postDate[not(&empty;)]|@createDate)[last()]}">
				<p><span>Post on: </span><xsl:value-of select="$postDate" /></p>
			</time>
			
			<div class="comments">
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
				
				<div class="tags">
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
					<xsl:with-param name="WordCount" select="50" />
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
			<header><h1><a href="{&NiceUrl;(@id)}"><xsl:value-of select="pageHeading[not(&empty;)]|metaTitle[not(&empty;)]|@nodeName " /></a></h1></header>

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
			
			<time datetime="{(postDate[not(&empty;)]|@createDate)[last()]}">
				<p><span>Post on: </span><xsl:value-of select="$postDate" /></p>
			</time>
			
			<div class="comments">
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
					<div class="tags">
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
					<xsl:with-param name="WordCount" select="50" />
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
			
	<li class="touchcarousel-item">
		<article>
			<xsl:if test="string(pageMedia//mediaItem[1]/Image)='' and string($hasMediaFolder)=''">
				<xsl:attribute name="class">no-img</xsl:attribute>
			</xsl:if>
			<header><h1><a href="{&NiceUrl;(@id)}"><xsl:value-of select="pageHeading[not(&empty;)]|metaTitle[not(&empty;)]|@nodeName " /></a></h1></header>

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
			<time datetime="{(completionDate[not(&empty;)]|@createDate)[last()]}">
				<xsl:if test="string($completeDate)!=''">
					<p><span>Date: </span><xsl:value-of select="$completeDate" /></p>
				</xsl:if>
			</time>
			
			<div class="text-holder">

			<xsl:if test="type[not(&empty;)]">
				<div class="type">
					<p><span>Type: </span>
						<xsl:apply-templates select="type" mode="multipicker" />
					</p>
				</div>
			</xsl:if>
				
				<xsl:call-template name="firstWords">
					<xsl:with-param name="TextData" select="bodyText[not(&empty;)]|metaDescription" />
					<xsl:with-param name="WordCount" select="50" />
					<xsl:with-param name="Ellipsis" select="'...'" />
				</xsl:call-template>
			</div>
			<div class="sec-link"><a href="{&NiceUrl;(@id)}" class="perma-link proj">Read more</a></div>
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
			<header><h1><a href="{&NiceUrl;(@id)}"><xsl:value-of select="pageHeading[not(&empty;)]|metaTitle[not(&empty;)]|@nodeName " /></a></h1></header>

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
			<time datetime="{(completionDate[not(&empty;)]|@createDate)[last()]}">
				<xsl:if test="string($completeDate)!=''">
					<p><span>Date: </span><xsl:value-of select="$completeDate" /></p>
				</xsl:if>
			</time>
			
			<div class="text-holder">

			<xsl:if test="type[not(&empty;)]">
				<div class="type">
					<p><span>Type: </span>
						<xsl:apply-templates select="type" mode="multipicker" />
					</p>
				</div>
			</xsl:if>
				
				<xsl:call-template name="firstWords">
					<xsl:with-param name="TextData" select="bodyText[not(&empty;)]|metaDescription" />
					<xsl:with-param name="WordCount" select="50" />
					<xsl:with-param name="Ellipsis" select="'...'" />
				</xsl:call-template>
			</div>
			<div class="sec-link"><a href="{&NiceUrl;(@id)}" class="perma-link proj">Read more</a></div>
		</article>
	</li>
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