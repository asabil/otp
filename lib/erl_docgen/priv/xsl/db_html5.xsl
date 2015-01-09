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

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:include href="db_html_params.xsl"/>
    <xsl:include href="db_html5_common.xsl"/>

    <xsl:output method="html"
                doctype-system="about:legacy-compat"
                encoding="UTF-8"
                indent="yes"/>

    <!-- Book -->
    <xsl:template match="book">
        <xsl:apply-templates select="parts"/>
    </xsl:template>

    <!-- Parts (guides) -->
    <xsl:template match="parts">
        <xsl:apply-templates select="part"/>
    </xsl:template>

    <xsl:template match="part">
        <xsl:apply-templates select="chapter" mode="guide"/>
    </xsl:template>

    <xsl:template match="chapter" mode="guide">
        <xsl:result-document href="guides/{substring-before(header/file, '.xml')}.html">
            <html>
                <head>
                    <meta charset="utf-8"/>
                    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
                    <xsl:choose>
                        <xsl:when test="string-length($winprefix) > 0">
                            <title><xsl:value-of select="$winprefix"/> &#8211; <xsl:value-of select="header/title"/></title>
                        </xsl:when>
                        <xsl:otherwise>
                            <title>Erlang &#8211; <xsl:value-of select="header/title"/></title>
                        </xsl:otherwise>
                    </xsl:choose>
                    <meta name="description" content="Erlang user guide for {header/title}"/>
                    <meta name="viewport" content="width=device-width, initial-scale=1"/>
                    <link rel="stylesheet" href="../css/normalize.css"/>
                    <link rel="stylesheet" href="../css/doc.css"/>
                </head>
                <body>
                    <main>
                        <article>
                            <h1><xsl:value-of select="header/title"/></h1>
                            <xsl:apply-templates select="section"/>
                        </article>
                    </main>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="chapter/section">
        <h2><xsl:value-of select="title"/></h2>
    </xsl:template>
</xsl:stylesheet>
