<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ 
<!ENTITY % entities SYSTEM "entities.ent">
    %entities;
]>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:ucom="urn:ucomponents.xml"  
	exclude-result-prefixes="ucom">


<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />
 
    <xsl:template match="*" mode="WYSIWYG">
        <xsl:apply-templates select="ucom:ParseXhtml(.)" />
    </xsl:template>
 
    <!-- Identity transform -->
    <xsl:template match="* | text()">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:apply-templates select="* | text()" />
        </xsl:copy>
    </xsl:template>
 
    <xsl:template match="@*">
        <xsl:copy-of select="." />
    </xsl:template>
 
    <!-- Rule for the wrapper element returned by ParseXhtml() -->
    <xsl:template match="xhtml">
        <xsl:apply-templates />
    </xsl:template>
 
</xsl:stylesheet>