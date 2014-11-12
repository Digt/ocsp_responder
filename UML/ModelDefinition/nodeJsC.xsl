<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" omit-xml-declaration="yes" indent="no"/>
  <!-- Отсутп -->
  <xsl:variable name ="space">&#160;&#160;&#160;&#160;</xsl:variable>

  <!-- ВЫВОД ДОКУМЕНТА НА ЭКРАН -->
  <xsl:template match="package">
    <!-- Первый запускаемый файл init.cc -->
    <xsl:apply-templates select="." mode="init.cc"/>
    <!-- Генерация кода для классов -->
    <xsl:for-each select=".//packageHasNamedElement/class">
      <xsl:apply-templates select="." mode="classCode"/>
    </xsl:for-each>
  </xsl:template>

  <!-- Обозначение начала файла -->
  <xsl:template name="fileBegin">
    <xsl:param name="fileName"/>
    <xsl:text>-------------------- BEGIN: </xsl:text>
    <xsl:value-of select="$fileName"/>
    <xsl:text> --------------------&#xa;&#xa;</xsl:text>
  </xsl:template>

  <!-- Обозначение конца файла -->
  <xsl:template name="fileEnd">
    <xsl:param name="fileName"/>
    <xsl:text>&#xa;&#xa;-------------------- END: </xsl:text>
    <xsl:value-of select="$fileName"/>
    <xsl:text> --------------------&#xa;&#xa;</xsl:text>
  </xsl:template>

  <!-- init.cc -->
  <xsl:template match="package" mode="init.cc">
    <xsl:variable name="fileName">init.cc</xsl:variable>
    <xsl:call-template name="fileBegin">
      <xsl:with-param name="fileName" select="$fileName"/>
    </xsl:call-template>
    <xsl:apply-templates select="." mode="header"/>
    <xsl:apply-templates select="." mode="includes"/>
    <xsl:apply-templates select ="." mode="initFunction"/>
    <xsl:call-template name="fileEnd">
      <xsl:with-param name="fileName" select="$fileName"/>
    </xsl:call-template>
  </xsl:template>

  <!-- init.cc: Заголовок файла -->
  <xsl:template match="package" mode="header">
    <xsl:text>
/*
 * Описание для заголовка файла
/*
</xsl:text>
  </xsl:template>

  <!-- init.cc: Includes -->
  <xsl:template match="package" mode="includes">
    <xsl:text>
#include &lt;node.h&gt;
#include &lt;v8.h&gt;

using namespace v8;
</xsl:text>
  </xsl:template>

  <!-- init.cc: function init-->
  <xsl:template match="package" mode="initFunction">
    <xsl:text>
void init(Handle&lt;Object&gt; target)
{
</xsl:text>
    <xsl:value-of select="$space"/>
    <xsl:text>// Other Class Inicialization&#10;&#10;</xsl:text>
    <xsl:value-of select="$space"/>
    <!-- Class Inicialization -->
    <xsl:text>// Class Inicialization&#10;</xsl:text>
    <xsl:for-each select=".//packageHasNamedElement/class">
      <xsl:apply-templates select="." mode="classInitialize"/>
    </xsl:for-each>
    <xsl:text>&#10;</xsl:text>
    <!-- Enum Inicialization -->
    <xsl:value-of select="$space"/>
    <xsl:text>// Enum Inicialization&#10;</xsl:text>
    <xsl:for-each select=".//packageHasNamedElement/enumeration">
      <xsl:apply-templates select="." mode="enumInitialize"/>
    </xsl:for-each>
    <xsl:text>}

NODE_MODULE(trustedJS, init)
    </xsl:text>
    <!--target->Set(String::NewSymbol("</xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text>"), FunctionTemplate::New(</xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text>)->GetFunction());-->
  </xsl:template>

  <!-- init.cc Enum Inicialization -->
  <xsl:template match="enumeration" mode="enumInitialize">
    <xsl:value-of select="$space"/>
    <xsl:value-of select="@name"/>
    <xsl:text>::Initialize(target);&#xa;</xsl:text>
  </xsl:template>

  <!-- init.cc Class Inicialization -->
  <xsl:template match="class" mode="classInitialize">
    <xsl:value-of select="$space"/>
    <xsl:value-of select="@name"/>
    <xsl:text>::Initialize(target);&#xa;</xsl:text>
  </xsl:template>

  <!-- Генерирует код для класса -->
  <xsl:template match="class" mode="classCode">
    <xsl:apply-templates select="." mode="class.h"/>
    <xsl:apply-templates select="." mode="class.cc"/>
  </xsl:template>

  <!-- Генерирует заголовочный файл для класса -->
  <xsl:template match="class" mode="class.h">
    <xsl:variable name="fileName">
      <xsl:value-of select="@name"/>
      <xsl:text>.h</xsl:text>
    </xsl:variable>
    <xsl:call-template name="fileBegin">
      <xsl:with-param name="fileName" select="$fileName"/>
    </xsl:call-template>

    <!-- Содержимое -->
    <xsl:call-template name="classIncludes"/>
    <xsl:call-template name="classNamespaces"/>
    <xsl:text>&#xa;</xsl:text>
    <xsl:text>class DX509: node::ObjectWrap&#xa;{&#xa;</xsl:text>
    <xsl:value-of select="$space"/>
    <xsl:text>public:</xsl:text>
    <xsl:text>&#xa;</xsl:text>
    <xsl:for-each select="./ownedAttributesInternal/property[not(@direction)]">
      <xsl:value-of select="$space"/>
      <xsl:value-of select="$space"/>
      <xsl:variable name="name">
        <xsl:value-of select="translate(substring(@name,1,1),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
        <xsl:value-of select="substring(@name,2,string-length(@name)-1)"/>
      </xsl:variable>
      <xsl:if test="@isReadOnly='false'">
        <xsl:text>set</xsl:text>
        <xsl:value-of select="$name"/>
        <xsl:text>(const Arguments &amp;args)</xsl:text>
        <xsl:text>&#xa;</xsl:text>
        <xsl:value-of select="$space"/>
        <xsl:value-of select="$space"/>
      </xsl:if>
      <xsl:text>get</xsl:text>
      <xsl:value-of select="$name"/>
      <xsl:text>(const Arguments &amp;args)</xsl:text>
      <xsl:text>&#xa;</xsl:text>
    </xsl:for-each>
    <xsl:value-of select="$space"/>
    <xsl:text>protected:</xsl:text>
    <xsl:text>&#xa;</xsl:text>
    <xsl:value-of select="$space"/>
    <xsl:text>private:</xsl:text>
    <xsl:text>&#xa;</xsl:text>
    <xsl:text>}</xsl:text>

    <xsl:call-template name="fileEnd">
      <xsl:with-param name="fileName" select="$fileName"/>
    </xsl:call-template>
  </xsl:template>

  <!-- Генерирует исполняющий файл для класса -->
  <xsl:template match="class" mode="class.cc">
    <xsl:variable name="fileName">
      <xsl:value-of select="@name"/>
      <xsl:text>.cc</xsl:text>
    </xsl:variable>
    <xsl:call-template name="fileBegin">
      <xsl:with-param name="fileName" select="$fileName"/>
    </xsl:call-template>

    <!-- Содержимое -->

    <xsl:call-template name="fileEnd">
      <xsl:with-param name="fileName" select="$fileName"/>
    </xsl:call-template>
  </xsl:template>

  <!-- class: Includes -->
  <xsl:template name="classIncludes">
    <xsl:text>
#include &lt;v8.h&gt;
#include &lt;node.h&gt;
#include &lt;node_object_wrap.h&gt;
#include &lt;node_buffer.h&gt;

#include &lt;openssl/x509v3.h&gt;
#include &lt;openssl/pem.h&gt;
#include &lt;openssl/evp.h&gt;
#include &lt;openssl/err.h&gt;

#include &lt;string.h&gt;
#include &lt;stdio.h&gt;
#include &lt;stdlib.h&gt;
#include &lt;errno.h&gt;
#include "common.h"
</xsl:text>
  </xsl:template>

  <!-- class: Namespaces -->
  <xsl:template name="classNamespaces">
    <xsl:text>
using namespace v8;
using namespace node;
</xsl:text>
  </xsl:template>

</xsl:stylesheet>