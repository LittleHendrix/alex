<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp "&#x00A0;">
]>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:umbraco.library="urn:umbraco.library"
	xmlns:UCommentLibrary="urn:UCommentLibrary"
	exclude-result-prefixes="msxml umbraco.library UCommentLibrary">


  <xsl:output method="html" omit-xml-declaration="yes"/>

  <xsl:param name="currentPage"/>

  <xsl:template match="/">
	
<xsl:variable name="comments" select="UCommentLibrary:GetCommentsForNode($currentPage/@id)//comment"/>
    <xsl:if test="count($comments) &gt; 0">
      <h3>
        <xsl:value-of select="count($comments)"/> comment<xsl:if test="count($comments) &gt; 1">s</xsl:if>  for  &#8220;<xsl:value-of select="$currentPage/@nodeName"/>&#8221;
      </h3>

      <ol class="commentlist">
        <xsl:for-each select="$comments">

          <li class="comment alt" id="comment-{@id}">
            <div class="comment-author vcard">
              <img class="photo avatar avatar-32 photo" width="32" height="32" src="{UCommentLibrary:getGravatar(./email, 40, '')}" alt="Gravatar of {./name}"/>
              <p class="fn n">
				  <xsl:value-of select="./name" />
				<!--
                <xsl:choose>
                  <xsl:when test="string-length(./website) = 0">
                      <xsl:value-of select="./name"/>
                  </xsl:when>
                  <xsl:otherwise>
                      <a class="url url" rel="external nofollow" href="{./website}">
                        <xsl:value-of select="./name"/>
                      </a>
                  </xsl:otherwise>
                </xsl:choose>
				-->
              </p>
            </div>
			<div class="comment-body">
				<div class="comment-meta">
					<p>Posted on <xsl:apply-templates select="@created" mode="longDate" /></p>
				</div>
				<p>
				  <xsl:value-of select="umbraco.library:ReplaceLineBreaks(./message)" disable-output-escaping="yes"/>
				</p>
			</div>
          </li>
        </xsl:for-each>
      </ol>
    </xsl:if>
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
</xsl:stylesheet>