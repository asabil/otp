<?xml version="1.0" encoding="utf-8"?>
<!--
     #
     # %CopyrightBegin%
     #
     # Copyright Ericsson AB 2009-2012. All Rights Reserved.
     #
     # The contents of this file are subject to the Erlang Public License,
     # Version 1.1, (the "License"); you may not use this file except in
     # compliance with the License. You should have received a copy of the
     # Erlang Public License along with this software. If not, it can be
     # retrieved online at http://www.erlang.org/.
     #
     # Software distributed under the License is distributed on an "AS IS"
     # basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
     # the License for the specific language governing rights and limitations
     # under the License.
     #
     # %CopyrightEnd%

     -->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!-- Text -->
    <xsl:template match="b">
        <strong><xsl:apply-templates/></strong>
    </xsl:template>

    <xsl:template match="br"><br/></xsl:template>
    <xsl:template match="nbsp">&#160;</xsl:template>

    <xsl:template match="c">
        <code class="erlang"><xsl:apply-templates/></code>
    </xsl:template>

    <xsl:template match="em">
        <strong><em><xsl:apply-templates/></em></strong>
    </xsl:template>

    <!-- Paragraph -->
    <xsl:template match="p">
        <p><xsl:apply-templates/></p>
    </xsl:template>

    <!-- Code -->
    <xsl:template match="code">
        <pre><code class="erlang"><xsl:apply-templates/></code></pre>
    </xsl:template>

    <!-- Pre -->
    <xsl:template match="pre">
        <pre><xsl:apply-templates/></pre>
    </xsl:template>

    <!-- Lists -->
    <xsl:template match="list | list[@type='bulleted']">
        <ul><xsl:apply-templates/></ul>
    </xsl:template>

    <xsl:template match="list[@type='ordered']">
        <ol><xsl:apply-templates/></ol>
    </xsl:template>

    <xsl:template match="list/item">
        <li><xsl:apply-templates/></li>
    </xsl:template>

    <xsl:template match="taglist">
        <dl><xsl:apply-templates/></dl>
    </xsl:template>

    <xsl:template match="taglist/tag">
        <dt><xsl:apply-templates/></dt>
    </xsl:template>

    <xsl:template match="taglist/item">
        <dd><xsl:apply-templates/></dd>
    </xsl:template>

    <!-- Table -->
    <xsl:template match="table">
        <table>
            <xsl:apply-templates select="tcaption"/>
            <xsl:apply-templates select="row"/>
        </table>
    </xsl:template>

    <xsl:template match="row">
        <tr><xsl:apply-templates select="cell"/></tr>
    </xsl:template>

    <xsl:template match="cell">
        <td><xsl:apply-templates/></td>
    </xsl:template>

    <xsl:template match="tcaption">
        <caption><xsl:apply-templates/></caption>
    </xsl:template>

    <!-- Image -->
    <xsl:template match="image">
        <img src="{@file}"/>
    </xsl:template>

    <xsl:template match="image[icaption]">
        <figure>
            <img src="{@file}"/>
            <xsl:apply-templates select="icaption"/>
        </figure>
    </xsl:template>

    <xsl:template match="icaption">
        <caption><xsl:apply-templates/></caption>
    </xsl:template>

</xsl:stylesheet>
