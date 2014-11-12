<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" omit-xml-declaration="yes" indent="no"/>
  <!-- Отсутп -->
  <xsl:variable name ="space">&#160;&#160;&#160;&#160;</xsl:variable>

  <!-- ВЫВОД ДОКУМЕНТА НА ЭКРАН -->
  <xsl:template match="package|modelStoreModel">
    <!-- Генерация кода для классов -->
    <xsl:for-each select=".//packageHasNamedElement/class">
      <xsl:apply-templates select="." mode="classCode"/>
    </xsl:for-each>
  </xsl:template>

  <!-- Обозначение начала файла -->
  <xsl:template name="fileBegin">
    <xsl:param name="fileName"/>
    <xsl:text>//-------------------- BEGIN: </xsl:text>
    <xsl:value-of select="$fileName"/>
    <xsl:text> --------------------&#xa;&#xa;</xsl:text>
  </xsl:template>

  <!-- Обозначение конца файла -->
  <xsl:template name="fileEnd">
    <xsl:param name="fileName"/>
    <xsl:text>&#xa;&#xa;//-------------------- END: </xsl:text>
    <xsl:value-of select="$fileName"/>
    <xsl:text> --------------------&#xa;&#xa;</xsl:text>
  </xsl:template>

  <!-- ClassCode -->
  <xsl:template match="class" mode="classCode">
    <xsl:variable name="fileName">
      <xsl:value-of select="@name"/>
      <xsl:text>.js</xsl:text>
    </xsl:variable>
    <xsl:call-template name="fileBegin">
      <xsl:with-param name="fileName" select="$fileName"/>
    </xsl:call-template>

    <!-- Объявление класса -->
    <xsl:apply-templates select="." mode="doc"/>
    <xsl:value-of select="@name"/>
    <xsl:text> = function() {&#xa;</xsl:text>
    
    <!-- Объявление параметров -->
    <xsl:for-each select=".//property">
      <xsl:value-of select ="$space"/>
      <xsl:text>var </xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text>;&#xa;</xsl:text>
    </xsl:for-each>

    <!-- Inicialization -->
    <xsl:text>&#xa;</xsl:text>
    <xsl:apply-templates select="." mode="init"/>

    <!-- Объяевление свойств -->
    <xsl:text>&#xa;</xsl:text>
    <xsl:value-of select="$space"/>
    <xsl:text>{// Properties&#xa;</xsl:text>
    <xsl:for-each select="./ownedAttributesInternal/property[not(@direction)]">
      <xsl:value-of select="$space"/>
      <xsl:value-of select="$space"/>
      <xsl:text>{// </xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text>&#xa;</xsl:text>
      <xsl:variable name="name">
        <xsl:value-of select="translate(substring(@name,1,1),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
        <xsl:value-of select="substring(@name,2,string-length(@name)-1)"/>
      </xsl:variable>
      <xsl:variable name="tab">
        <xsl:value-of select="$space"/>
        <xsl:value-of select="$space"/>
        <xsl:value-of select="$space"/>
      </xsl:variable>
      <xsl:if test="@isReadOnly='false'">
        <xsl:apply-templates select="." mode="docSET">
          <xsl:with-param name="tab" select="$tab"/>
        </xsl:apply-templates>
        <xsl:value-of select="$tab"/>
        <xsl:text>this.set</xsl:text>
        <xsl:value-of select="$name"/>
        <xsl:text> = function(value) {&#xa;</xsl:text>
        <xsl:value-of select="$tab"/>
        <xsl:value-of select="$space"/>
        <xsl:value-of select="@name"/>
        <xsl:text> = value;&#xa;</xsl:text>
        <xsl:value-of select="$tab"/>
        <xsl:text>};&#xa;</xsl:text>
        <xsl:text>&#xa;</xsl:text>
      </xsl:if>
      <xsl:apply-templates select="." mode="docGET">
        <xsl:with-param name="tab" select="$tab"/>
      </xsl:apply-templates>
      <xsl:value-of select="$tab"/>
      <xsl:text>this.get</xsl:text>
      <xsl:value-of select="$name"/>
      <xsl:text> = function() {&#xa;</xsl:text>
      <xsl:value-of select="$tab"/>
      <xsl:value-of select="$space"/>
      <xsl:text>return </xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text>;&#xa;</xsl:text>
      <xsl:value-of select="$tab"/>
      <xsl:text>};&#xa;</xsl:text>
      <xsl:value-of select="$space"/>
      <xsl:value-of select="$space"/>
      <xsl:text>}&#xa;</xsl:text>
    </xsl:for-each>
    <xsl:value-of select="$space"/>
    <xsl:text>}&#xa;</xsl:text>

    <!-- Объяевление методов -->
    <xsl:text>&#xa;</xsl:text>
    <xsl:value-of select="$space"/>
    <xsl:text>{// Methods&#xa;</xsl:text>
    <xsl:variable name="tab">
      <xsl:value-of select="$space"/>
      <xsl:value-of select="$space"/>
    </xsl:variable>
    <xsl:for-each select="./ownedOperationsInternal/operation">
      <xsl:text>&#xa;</xsl:text>
      <xsl:apply-templates select="." mode="doc">
        <xsl:with-param name="tab" select="$tab"/>
      </xsl:apply-templates>
      <xsl:value-of select="$space"/>
      <xsl:value-of select="$space"/>
      <xsl:text>this.</xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text> = function(</xsl:text>
      <!-- Объяевление параметров -->
      <xsl:for-each select=".//parameter">
        <xsl:value-of select="@name"/>
        <xsl:if test="not(position()=last())">
          <xsl:text>, </xsl:text>
        </xsl:if>
      </xsl:for-each>
      <xsl:text>) {</xsl:text>
      <xsl:variable name="content">
        <xsl:text>&#xa;</xsl:text>
        <xsl:text>&#xa;</xsl:text>
        <xsl:value-of select="$space"/>
        <xsl:value-of select="$space"/>
        <xsl:value-of select="$space"/>
        <xsl:text>//Content&#xa;</xsl:text>
        <xsl:value-of select="$space"/>
        <xsl:value-of select="$space"/>
        <xsl:value-of select="$space"/>
        <xsl:text>throw("method '</xsl:text>
        <xsl:value-of select="@name"/>
        <xsl:text>' is not implemented");&#xa;</xsl:text>
        <xsl:text>&#xa;</xsl:text>
      </xsl:variable>
      <!-- Возврат результата -->
      <xsl:choose>
        <xsl:when test=".//parameter/@direction='Return'">
          <xsl:text>&#xa;</xsl:text>
          <xsl:value-of select="$space"/>
          <xsl:value-of select="$space"/>
          <xsl:value-of select="$space"/>
          <xsl:text>var result;</xsl:text>
          <xsl:value-of select="$content"/>
          <xsl:text>&#xa;</xsl:text>
          <xsl:value-of select="$space"/>
          <xsl:value-of select="$space"/>
          <xsl:value-of select="$space"/>
          <xsl:text>return result;</xsl:text>
          <xsl:text>&#xa;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$content"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="$space"/>
      <xsl:value-of select="$space"/>
      <xsl:text>};&#xa;</xsl:text>
    </xsl:for-each>
    <xsl:value-of select="$space"/>
    <xsl:text>}&#xa;</xsl:text>
    <xsl:text>&#xa;</xsl:text>
    <!-- Вызов функции инициализации -->
    <xsl:value-of select="$space"/>
    <xsl:text>init();&#xa;</xsl:text>
    <xsl:text>};&#xa;</xsl:text>

    <xsl:call-template name="fileEnd">
      <xsl:with-param name="fileName" select="$fileName"/>
    </xsl:call-template>
  </xsl:template>

  <!-- JavaDoc для свойства GET -->
  <xsl:template match="property" mode ="docGET">
    <xsl:param name="tab"/>
    <xsl:value-of select="$tab"/>
    <xsl:text>/**&#xa;</xsl:text>
    <xsl:value-of select="$tab"/>
    <xsl:text> * </xsl:text>
    <xsl:value-of select="description"/>
    <xsl:text>&#xa;</xsl:text>
    <xsl:value-of select="$tab"/>
    <xsl:text> * @name </xsl:text>
    <xsl:variable name="name">
      <xsl:value-of select="translate(substring(@name,1,1),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
      <xsl:value-of select="substring(@name,2,string-length(@name)-1)"/>
    </xsl:variable>
    <xsl:text>set</xsl:text>
    <xsl:value-of select="$name"/>
    <xsl:text>&#xa;</xsl:text>
    <xsl:value-of select="$tab"/>
    <xsl:text> * @function </xsl:text>
    <xsl:text>&#xa;</xsl:text>
    <xsl:value-of select="$tab"/>
    <xsl:text> * @return {</xsl:text>
    <xsl:value-of select=".//@LastKnownName"/>
    <xsl:text>}</xsl:text>
    <xsl:text>&#xa;</xsl:text>
    <xsl:value-of select="$tab"/>
    <xsl:text> */&#xa;</xsl:text>
  </xsl:template>

  <!-- JavaDoc для свойства SET -->
  <xsl:template match="property" mode ="docSET">
    <xsl:param name="tab"/>
    <xsl:value-of select="$tab"/>
    <xsl:text>/**&#xa;</xsl:text>
    <xsl:value-of select="$tab"/>
    <xsl:text> * </xsl:text>
    <xsl:value-of select="description"/>
    <xsl:text>&#xa;</xsl:text>
    <xsl:value-of select="$tab"/>
    <xsl:text> * @name </xsl:text>
    <xsl:variable name="name">
      <xsl:value-of select="translate(substring(@name,1,1),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
      <xsl:value-of select="substring(@name,2,string-length(@name)-1)"/>
    </xsl:variable>
    <xsl:text>get</xsl:text>
    <xsl:value-of select="$name"/>
    <xsl:text>&#xa;</xsl:text>
    <xsl:value-of select="$tab"/>
    <xsl:text> * @function </xsl:text>
    <xsl:text>&#xa;</xsl:text>
    <xsl:value-of select="$tab"/>
    <xsl:text> * @param {</xsl:text>
    <xsl:value-of select=".//@LastKnownName"/>
    <xsl:text>} value</xsl:text>
    <xsl:text>&#xa;</xsl:text>
    <xsl:value-of select="$tab"/>
    <xsl:text> */&#xa;</xsl:text>
  </xsl:template>

  <!-- JavaDoc для Метода -->
  <xsl:template match="operation" mode ="doc">
    <xsl:param name="tab"/>
    <xsl:value-of select="$tab"/>
    <xsl:text>/**&#xa;</xsl:text>
    <xsl:value-of select="$tab"/>
    <xsl:text> * </xsl:text>
    <xsl:value-of select="description"/>
    <xsl:text>&#xa;</xsl:text>
    <xsl:value-of select="$tab"/>
    <xsl:text> * @name </xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text>&#xa;</xsl:text>
    <xsl:value-of select="$tab"/>
    <xsl:text> * @function </xsl:text>
    <xsl:text>&#xa;</xsl:text>
    <xsl:for-each select=".//parameter[not(@direction='Return')]">
      <xsl:value-of select="$tab"/>
      <xsl:text> * @param {</xsl:text>
      <xsl:value-of select=".//@LastKnownName"/>
      <xsl:text>} </xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text>&#160;</xsl:text>
      <xsl:value-of select="description"/>
      <xsl:text>&#xa;</xsl:text>
    </xsl:for-each>
    <xsl:for-each select=".//parameter[@direction='Return']">
      <xsl:value-of select="$tab"/>
      <xsl:text> * @return {</xsl:text>
      <xsl:value-of select=".//@LastKnownName"/>
      <xsl:text>} </xsl:text>
      <xsl:value-of select="description"/>
      <xsl:text>&#xa;</xsl:text>
    </xsl:for-each>
    <xsl:value-of select="$tab"/>
    <xsl:text> */&#xa;</xsl:text>
  </xsl:template>
  
  <!-- JavaDoc для Класса -->
  <xsl:template match="class" mode ="doc">
    <xsl:param name="tab"/>
    <xsl:value-of select="$tab"/>
    <xsl:text>/**&#xa;</xsl:text>
    <xsl:value-of select="$tab"/>
    <xsl:text> * </xsl:text>
    <xsl:value-of select="description"/>
    <xsl:text>&#xa;</xsl:text>
    <xsl:value-of select="$tab"/>
    <xsl:text> * @class </xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text> class&#xa;</xsl:text>
    <!--<xsl:for-each select=".//property">
      <xsl:value-of select="$tab"/>
      <xsl:text> * @property {</xsl:text>
      <xsl:value-of select=".//@LastKnownName"/>
      <xsl:text>} </xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text>&#160;</xsl:text>
      <xsl:value-of select="description"/>
      <xsl:text>&#xa;</xsl:text>
    </xsl:for-each>-->
    <xsl:value-of select="$tab"/>
    <xsl:text> */&#xa;</xsl:text>
  </xsl:template>

  <!-- init function -->
  <xsl:template match="class" mode="init">
    <xsl:value-of select="$space"/>
    <xsl:text>// Inicialization&#xa;</xsl:text>
    <xsl:value-of select="$space"/>
    <xsl:text>function init() {&#xa;</xsl:text>
    <xsl:for-each select=".//property">
      <xsl:value-of select="$space"/>
      <xsl:value-of select="$space"/>
      <xsl:value-of select="@name"/>
      <xsl:text> = undefined;&#xa;</xsl:text>
    </xsl:for-each>
    <xsl:value-of select="$space"/>
    <xsl:text>}&#xa;</xsl:text>
  </xsl:template>

</xsl:stylesheet>