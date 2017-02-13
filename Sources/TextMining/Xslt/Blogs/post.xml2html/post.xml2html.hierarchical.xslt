﻿<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                exclude-result-prefixes="msxsl"
                >
  <xsl:output method="html" indent="yes"/>
  
  <xsl:variable name="LEVEL_INDENT">30</xsl:variable>
  
  <xsl:template match="/">
    <xsl:call-template name="root">
      <xsl:with-param name="rootNode" select="./result/posts/post[ ./id/text() = ./root/text() ]" />
    </xsl:call-template>
  </xsl:template>
  

  <xsl:template name="root">
    <xsl:param name="rootNode" />

    <xsl:choose>
      <xsl:when test="count($rootNode) >= 1">
        <div>
          <style type="text/css">a img { border: 0; }</style>          
          <xsl:for-each select="$rootNode">          
            <xsl:apply-templates select="$rootNode" />
          </xsl:for-each>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <div>
          <h2>Root element-'post' not found:</h2>
          <xsl:apply-templates mode="escape" />
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  

  <xsl:template match="post">
    <xsl:element name="div">
      <xsl:attribute name="style">
        <xsl:text>padding-left: </xsl:text>
        <xsl:value-of select="$LEVEL_INDENT * number(./lvl/text())" />
        <xsl:text>px; </xsl:text>        
      </xsl:attribute>
      
      <div style="border: 1px dotted silver; margin: 2px;">
        <xsl:if test="normalize-space(./title/text()) != ''">
          <span style="font-size: x-small; color: silver;">[title]: </span>
          <h3><xsl:value-of select="./title/text()" /></h3> 
          <br/>
        </xsl:if>
        <xsl:if test="normalize-space(./body/text()) != ''">
          <span style="font-size: x-small; color: silver;">[body]: </span>
          <xsl:value-of select="./body/text()" disable-output-escaping="yes" />
          <br/>
        </xsl:if>
        <span style="font-size: x-small; color: silver;">[autor, date]: </span>
        <span style="font-size: x-small;">
          <!--<xsl:value-of select="./author/text()" disable-output-escaping="yes" />-->
          <span>
            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="./author/@authorprofile" disable-output-escaping="yes" />
              </xsl:attribute>
              <xsl:attribute name="target">_blank</xsl:attribute>

              <xsl:element name="img">
                <xsl:attribute name="src">
                  <xsl:value-of select="./author/@authoravatar" disable-output-escaping="yes" />
                </xsl:attribute>
              </xsl:element>
            </xsl:element>

            <xsl:element name="a">
              <xsl:attribute name="href">
                <xsl:value-of select="./author/@authorhome" disable-output-escaping="yes" />                
              </xsl:attribute>
              <xsl:attribute name="target">_blank</xsl:attribute>
              <b>
                <xsl:value-of select="./author/@authorname" disable-output-escaping="yes" />
              </b>
            </xsl:element>
          </span>          
          <xsl:text>, </xsl:text>
          <xsl:value-of select="msxsl:format-date(./modify/text(), 'dd.MM.yyyy')" disable-output-escaping="yes" /><xsl:text> </xsl:text>
          <xsl:value-of select="msxsl:format-time(./modify/text(), 'HH:mm:ss')" disable-output-escaping="yes" />
        </span>

        <xsl:variable name="rootNode" select="." />
        <xsl:apply-templates select="/result/posts/post[ ./parent/text() = $rootNode/id/text() and ./id/text() != $rootNode/id/text() ]" />

      </div>
    
    </xsl:element>
  </xsl:template>
  

  <xsl:template match="*" mode="escape">
    <xsl:text>&lt;</xsl:text>
    <xsl:value-of select="name()"/>
    <xsl:apply-templates select="@*" mode="escape"/>
    <xsl:text>&gt;</xsl:text>
    <xsl:apply-templates select="node()" mode="escape"/>
    <xsl:text>&lt;</xsl:text>
    <xsl:value-of select="name()"/>
    <xsl:text>&gt;</xsl:text>
  </xsl:template>
  <xsl:template match="@*" mode="escape">
    <xsl:text>&#32;</xsl:text>
    <xsl:value-of select="name()"/>
    <xsl:text>="</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>"</xsl:text>
  </xsl:template>
  <xsl:template match="text()" mode="escape">
    <xsl:value-of select="."/>
  </xsl:template>

</xsl:stylesheet>
