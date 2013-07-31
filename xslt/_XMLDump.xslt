<?xml version="1.0"?>
<?umbraco-package "XML Dump for Umbraco (v0.9.2)"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:umb="urn:umbraco.library" xmlns:make="urn:schemas-microsoft-com:xslt" xmlns:str="http://exslt.org/strings" version="1.0" extension-element-prefixes="umb make str">
	
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
	
<!--
	Umbraco supplies this parameter.
	The select attribute is used when no value is supplied from "outside" (i.e. local development)
-->
	<xsl:param name="currentPage" select="/root/*[@isDoc or self::node][1]"/>
	
	<!-- Grab the root node -->
	<xsl:variable name="root" select="$currentPage/ancestor::root"/>
	
	<!-- Allowed for this node? -->
	<xsl:variable name="remoteAddress" select="umb:RequestServerVariables('REMOTE_ADDR')"/>
	<xsl:variable name="xmldumpAllowed" select="boolean($currentPage/ancestor-or-self::*[contains(xmldumpAllowedIPs, $remoteAddress)] | $currentPage/ancestor-or-self::node[contains(data[@alias = 'xmldumpAllowedIPs'], $remoteAddress)] | $currentPage/ancestor-or-self::root/AdminSettings[contains(xmldumpAllowedIPs, $remoteAddress)])"/>
	
	<!-- Determine if using legacy or v4.5 XML Schema -->
	<xsl:variable name="isLegacyXML" select="boolean(not($root/*[@isDoc][1]))"/>
	<xsl:variable name="isNewXML" select="not($isLegacyXML)"/>
	
	<xsl:variable name="upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ&#xC6;&#xD8;&#xC5;'"/>
	<xsl:variable name="lower" select="'abcdefghijklmnopqrstuvwxyz&#xE6;&#xF8;&#xE5;'"/>
	
<!-- :: Configuration variables :: -->
<!--
	You can tailor the XML output to your needs by specifying some
	URL parameters - e.g. to check a specific node (by id), or you need to
	see all nodes of a specific Document Type.
	
	The following variables handle these by collecting all URL parameters into
	an options XML variable. This enables referring to options like this: $options[@key = 'id']
-->

	<xsl:variable name="optionsProxy">
		<xsl:call-template name="parseOptions">
			<xsl:with-param name="options" select="umb:RequestServerVariables('QUERY_STRING')"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="options" select="make:node-set($optionsProxy)/options/option"/>

	<xsl:variable name="nodeId" select="$options[@key = 'id']"/>
	<xsl:variable name="type" select="$options[@key = 'type']"/>
	<xsl:variable name="mediaId" select="$options[@key = 'media']"/>
	<xsl:variable name="property" select="($options[@key = 'property'] | $options[@key = 'prop'])[1]"/>
	<xsl:variable name="xpath" select="$options[@key = 'xpath']"/>
	<xsl:variable name="hidden" select="$options[@key = 'hidden']"/>
	<xsl:variable name="hiddenOnly" select="boolean($hidden = 'yes')"/>
	<xsl:variable name="sitemap" select="$options[@key = 'sitemap']"/>
	<xsl:variable name="navOnly" select="boolean($sitemap = 'yes')"/>
	<xsl:variable name="verbose" select="($options[@key = 'v'] | $options[@key = 'verbose'])[1]"/>
	<xsl:variable name="verbosity" select="boolean($verbose = 'yes')"/>
	<xsl:variable name="search" select="($options[@key = 'search'] | $options[@key = 's'])[1]"/>
	<xsl:variable name="mntp" select="$options[@key = 'mntp']"/>
	<xsl:variable name="expandMNTP" select="boolean($mntp = 'yes')"/>

	<!-- Secret option - not ready for prime time yet :-) -->
	<xsl:variable name="memberId" select="$options[@key = 'member']"/>
	
	<xsl:variable name="processChildNodes" select="   not(    $hiddenOnly    or number($nodeId)    or normalize-space($type)    or normalize-space($property)    or normalize-space($xpath)   ) or $verbosity"/>
	
<!-- :: Templates :: -->

	<xsl:template match="/">
		<!-- Start up the engines... -->
		<xsl:apply-templates select="macro[$xmldumpAllowed]"/>
		
		<!-- ...or show them the door -->
		<xsl:apply-templates select="macro[not($xmldumpAllowed)]" mode="unauthorized"/>
	</xsl:template>
	
	<xsl:template match="macro">
		<!-- Start by writing a 'usage' comment to the output  -->
		<xsl:call-template name="usage-comment"/>
		
		<!-- Now decide what to output, determined by the supplied options (if any) -->
		<xsl:choose>
			<!-- Was a specific node requested by id? -->
			<xsl:when test="number($nodeId)">
				<xsl:apply-templates select="$root//*[@isDoc or self::node][@id = $nodeId]"/>
			</xsl:when>
			
			<!-- Was an XPath specified? -->
			<xsl:when test="normalize-space($xpath)">
				<!-- We need to build an XPath we can use with the library method GetXmlNodeByXPath() -->
				<xsl:variable name="queryXPath">
					<!-- Base XPath off of $currentPage, unless it starts with a slash -->
					<xsl:if test="not(starts-with($xpath, '/'))">
						<xsl:value-of select="concat('id(', $currentPage/@id, ')/')"/>
					</xsl:if>
					<xsl:value-of select="$xpath"/>
				</xsl:variable>
				<!-- Next we create the printed XPath that you'll end up copying for your XSLT -->
				<xsl:variable name="umbXPath">
					<xsl:if test="not(starts-with($xpath, '/'))">
						<xsl:text>$currentPage/</xsl:text>
					</xsl:if>
					<xsl:value-of select="$xpath"/>
				</xsl:variable>
				
				<xsl:variable name="matchedNodes" select="umb:GetXmlNodeByXPath($queryXPath)"/>
				<output select="{$umbXPath}" total="{count($matchedNodes)}">
					<xsl:apply-templates select="$matchedNodes"/>
				</output>
			</xsl:when>
			
			<!-- Do we only want a specific property? -->
			<xsl:when test="normalize-space($property)">
				<output property="{$property}">
					<!-- Using the "Mutually Exclusive Hack" -->
					<xsl:apply-templates select="$root//*[@isDoc or self::node][data[@alias = $property]]"/>
					<xsl:apply-templates select="$root//*[@isDoc or self::node][*[name() = $property]]"/>
				</output>
			</xsl:when>
			
			<!-- Requested a DocumentType? -->
			<xsl:when test="normalize-space($type)">
				<output documentType="{$type}">
					<xsl:apply-templates select="$root//*[@isDoc or self::node][concat(name(self::*[@isDoc]), self::node/@nodeTypeAlias) = $type]"/>
				</output>
			</xsl:when>

			<!-- Specific Media id? -->
			<xsl:when test="number($mediaId)">
				<xsl:variable name="mediaNode" select="umb:GetMedia($mediaId, true())"/>
					<media>
						<xsl:apply-templates select="$mediaNode[not(error)]"/>
					</media>
			</xsl:when>
			
			<!-- Performing a search? -->
			<xsl:when test="normalize-space($search)">
				<root search="{$search}">
					<xsl:variable name="search-downcased" select="translate($search, $upper, $lower)"/>
					<xsl:apply-templates select="$root//*[@isDoc or self::node][*[not(@isDoc) or name() = 'data'][contains(translate(., $upper, $lower), $search-downcased)]] | $root//*[@isDoc or self::node][contains(translate(@nodeName, $upper, $lower), $search-downcased)]"/>
				</root>
			</xsl:when>
			
			<!-- Only show sitemap-style nodes? -->
			<xsl:when test="$navOnly">
				<root id="-1">
					<xsl:apply-templates select="$root/*[@isDoc or self::node][1]" mode="sitemap"/>
				</root>					
			</xsl:when>
			
			<!-- Member node? quirky, but let's try to get the current member... -->
			<xsl:when test="number($memberId)">
				<members>
					<xsl:copy-of select="umb:GetCurrentMember()"/>
				</members>
			</xsl:when>
			
			<!-- Show only hidden nodes? -->
			<xsl:when test="$hiddenOnly">
				<output>
					<xsl:attribute name="umbracoNaviHide">1</xsl:attribute>
					<xsl:apply-templates select="$root//*[@isDoc or self::node][data[@alias = 'umbracoNaviHide'] = 1 or umbracoNaviHide = 1]"/>
				</output>
			</xsl:when>
			
			<xsl:otherwise>
				<!-- Okay, no specific nodes selected - show tree from $currentPage -->
				<xsl:apply-templates select="$currentPage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Template for copying nodes -->
	<xsl:template match="*">
		<!-- Copy the current node (whatever it's called) -->
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="$verbosity">
					<!-- Copy all attributes verbatim -->
					<xsl:copy-of select="@*"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- Copy only predefined defaults -->
					<xsl:copy-of select="@id | @nodeName | @urlName | @isDoc | @level | @nodeTypeAlias | @alias | @url | @name | @title | @link"/>
				</xsl:otherwise>
			</xsl:choose>
			
			<!-- Process the properties or their text nodes -->
			<xsl:choose>
				<xsl:when test="$isNewXML">
					<xsl:apply-templates select="*[not(@isDoc)] | self::*[not(@isDoc)]/text()"/>
				</xsl:when>
				<xsl:when test="$isLegacyXML">
					<xsl:apply-templates select="data | self::data/text()"/>
				</xsl:when>
			</xsl:choose>
			
			<!-- Only continue copying nested DocumentType elements if applicable -->
			<xsl:choose>
				<xsl:when test="$processChildNodes">
					<xsl:apply-templates select="*[@isDoc or self::node]"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="*[@isDoc or self::node]">
						<xsl:variable name="nodecount" select="count(*[@isDoc or self::node])"/>
	<xsl:comment xml:space="preserve"> (<xsl:value-of select="$nodecount"/> element<xsl:if test="$nodecount &gt; 1">s</xsl:if> below this)</xsl:comment>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="*[not(@isDoc) or name() = 'data']/text()">
		<xsl:value-of select="."/>
	</xsl:template>
	
	<!-- Template for 'sitemap' mode -->
	<xsl:template match="*[@isDoc or self::node]" mode="sitemap">
		<xsl:element name="{name()}">
			<xsl:copy-of select="@id | @nodeName | @urlName"/>
			<xsl:apply-templates select="*[@isDoc or self::node]" mode="sitemap"/>
		</xsl:element>
	</xsl:template>
	
	<!-- Hey - that's a uComponents picker - should we expand it? -->
	<xsl:template match="MultiNodePicker/nodeId | XPathCheckBoxList/nodeId | CheckBoxTree/nodeId">
		<xsl:choose>
			<xsl:when test="$expandMNTP">
				<xsl:variable name="node" select="id(.)"/>
				<xsl:apply-templates select="$node" mode="MNTP"/>

				<xsl:if test="not($node)">
					<!-- Try to see if it's a Media node -->
					<xsl:variable name="mediaNode" select="umb:GetMedia(., false())"/>
					<xsl:apply-templates select="$mediaNode[not(error)]" mode="MNTP"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<nodeId><xsl:value-of select="."/></nodeId>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*" mode="MNTP">
		<xsl:comment>Node referenced by uComponents DataType</xsl:comment>
		<xsl:copy>
			<xsl:copy-of select="@id | @nodeName | @urlName | @isDoc | @level | @nodeTypeAlias | @alias | @url | @name | @title | @link"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="*[@isDoc or self::node][data[@alias = 'umbracoNaviHide'] = 1 or umbracoNaviHide = 1]" mode="sitemap"/>
	
<!-- :: Utility templates :: -->
	<xsl:template name="usage-comment">
<xsl:comment xml:space="preserve">
	XML Dump for Umbraco (v0.9.2)
	======================================================================================
	Options (QueryString parameters):
	- id		Grab a node by its id, e.g.: id=1080
	- type		Grab node(s) by their DocumentType, e.g.: type=GalleryItem
	- prop		Find nodes that have a specific property, e.g.: prop=metaDescription
	- media		View XML for media item, e.g.: media=1337
	- search	Search the name and properties of Documents for a string, e.g.: search=umbraco
	- sitemap	Set to 'yes' to show navigation structure only (shows only "@id | @nodeName | @urlName" and hides nodes with 'umbracoNaviHide' checked)
	- hidden	Set to 'yes' to show all nodes with 'umbracoNaviHide' checked.
	- xpath		Grab node(s) using an XPath, e.g.: xpath=/root//*[@isDoc or self::node][@nodeName = 'Home']
	
	- mntp		Set to 'yes' to show nodes referenced by uComponents pickers instead of just their node id 
	
	You can add 'v=yes' (or 'verbose=yes') to show all attributes of Document nodes (by default only shows "@id | @nodeName | @urlName | @isDoc | @level | @nodeTypeAlias | @alias | @url | @name | @title | @link").

	(For all boolean options, the values 'yes', 'true', 'on' and '1' will work as expected)
</xsl:comment>
	</xsl:template>
	
	<!-- Options Parsing -->
	<xsl:template name="parseOptions">
		<xsl:param name="options" select="''"/>
		<options>
			<xsl:apply-templates select="umb:Split($options, '&amp;')/value" mode="parse"/>
		</options>
	</xsl:template>
	
	<xsl:template match="value" mode="parse">
		<xsl:variable name="key" select="substring-before(., '=')"/>
		<option key="{$key}">
			<xsl:value-of select="umb:RequestQueryString($key)"/>
		</option>
	</xsl:template>
	
	<!-- Make sure to catch sane attempts to set a BOOL option to something truthy, and normalize to 'yes' -->
	<xsl:template match="value[contains('|yes|true|1|on|', concat('|', translate(substring-after(., '='), 'NOTRUESY', 'notruesy'), '|'))]" mode="parse">
		<option key="{substring-before(., '=')}">yes</option>
	</xsl:template>
	
	<xsl:template match="macro" mode="unauthorized">
		<output>
<xsl:comment xml:space="preserve">
	XMLDump is not allowed for this node
	====================================
	To enable, add a textstring property with the alias "xmldumpAllowedIPs" on your top-level Document Type.
	Then go to the corresponding Content node and fill in your IP address (or more, comma-separated). Hit "Save and Publish" to enable XMLDump.

	XML Dump for Umbraco (v0.9.2)
</xsl:comment>
		</output>
	</xsl:template>

</xsl:stylesheet>
