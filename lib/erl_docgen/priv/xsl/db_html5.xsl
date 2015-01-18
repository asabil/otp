<?xml version="1.0" encoding="utf-8"?>
<!--
     #
     # %CopyrightBegin%
     #
     # Copyright Ericsson AB 2009-2015. All Rights Reserved.
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
    <xsl:include href="db_html_params.xsl"/>
    <xsl:include href="db_html5_common.xsl"/>

    <xsl:param name="specs_file" select="''"/>
    <xsl:variable name="specs" select="document($specs_file)"/>

    <!-- Book -->
    <xsl:template match="book">
        <xsl:call-template name="html.document">
            <xsl:with-param name="out"><xsl:value-of select="$outdir"/>/index.html</xsl:with-param>
            <xsl:with-param name="root" select="$topdocdir"/>
            <xsl:with-param name="title" select="header/title"/>
            <xsl:with-param name="description">Erlang documentation for <xsl:value-of select="header/title"/></xsl:with-param>
            <xsl:with-param name="body">
                <header>
                    <h1><xsl:value-of select="header/title"/></h1>
                    <p>Version <xsl:value-of select="$appver"/>&#160;<small>(<xsl:value-of select="$gendate"/>)</small></p>
                </header>
                <xsl:apply-templates select="applications/application"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Application Index -->
    <xsl:template match="application">
        <article class="application">
            <section class="intro">
                <section>
                    <xsl:for-each select="description"><xsl:apply-templates /></xsl:for-each>
                    <xsl:for-each select="appref/description"><xsl:apply-templates /></xsl:for-each>
                </section>
                <xsl:apply-templates select="appref/section" />
            </section>
            <section class="guides">
                <h2>Guides</h2>
                <ul>
                    <xsl:for-each select="/book/parts/part">
                        <xsl:for-each select="chapter">
                            <xsl:variable name="guide_file"
                                          select="concat($outdir, '/guides/', substring-before(header/file, '.xml'), '.html')"/>
                            <li><a href="{$guide_file}"><xsl:value-of select="header/title"/></a></li>
                            <xsl:apply-templates select="." mode="application">
                                <xsl:with-param name="out" select="$guide_file"/>
                                <xsl:with-param name="root" select="concat($topdocdir, '/..')"/>
                            </xsl:apply-templates>
                        </xsl:for-each>
                    </xsl:for-each>
                </ul>
            </section>
            <section class="modules">
                <h2>Modules</h2>
                <ul>
                    <xsl:for-each select="erlref">
                        <xsl:variable name="reference_file"
                                      select="concat($outdir, '/reference/', module, '.html')"/>
                        <li><a href="{$reference_file}"><xsl:value-of select="header/title"/></a></li>
                        <xsl:apply-templates select="." mode="application">
                            <xsl:with-param name="out" select="$reference_file"/>
                            <xsl:with-param name="root" select="concat($topdocdir, '/..')"/>
                        </xsl:apply-templates>
                    </xsl:for-each>
                </ul>
            </section>
        </article>
    </xsl:template>

    <!-- Application Guides -->
    <xsl:template match="chapter" mode="application">
        <xsl:param name="out"/>
        <xsl:param name="root"/>
        <xsl:call-template name="html.document">
            <xsl:with-param name="out" select="$out"/>
            <xsl:with-param name="root" select="$root"/>
            <xsl:with-param name="title" select="header/title"/>
            <xsl:with-param name="description">Erlang guide for <xsl:value-of select="header/title"/></xsl:with-param>
            <xsl:with-param name="body">
                <article class="guide">
                    <h1><xsl:value-of select="header/title"/></h1>
                    <xsl:apply-templates select="section" />
                </article>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Application Erlang References -->
    <xsl:template match="erlref" mode="application">
        <xsl:param name="out"/>
        <xsl:param name="root"/>
        <xsl:call-template name="html.document">
            <xsl:with-param name="out" select="$out"/>
            <xsl:with-param name="root" select="$root"/>
            <xsl:with-param name="title" select="header/title"/>
            <xsl:with-param name="description" select="modulesummary"/>
            <xsl:with-param name="body">
                <article class="reference">
                    <h1><xsl:value-of select="header/title"/></h1>
                    <nav class="toc">
                        <xsl:if test="count(datatypes) > 0">
                            <div>
                                <div class="title">Datatypes</div>
                                <xsl:apply-templates select="datatypes" mode="menu">
                                    <xsl:with-param name="module" select="module"/>
                                </xsl:apply-templates>
                            </div>
                        </xsl:if>
                        <xsl:if test="count(funcs) > 0">
                            <div>
                                <div class="title">Functions</div>
                                <xsl:apply-templates select="funcs" mode="menu">
                                    <xsl:with-param name="module" select="module"/>
                                </xsl:apply-templates>
                            </div>
                        </xsl:if>
                    </nav>
                    <section class="intro">
                        <xsl:apply-templates select="description"/>
                        <xsl:apply-templates select="section"/>
                    </section>
                    <xsl:if test="count(datatypes) > 0">
                        <section class="datatypes">
                            <h2>Datatypes</h2>
                            <xsl:apply-templates select="datatypes">
                                <xsl:with-param name="module" select="module"/>
                            </xsl:apply-templates>
                        </section>
                    </xsl:if>
                    <xsl:if test="count(funcs) > 0">
                        <section class="functions">
                            <h2>Functions</h2>
                            <xsl:apply-templates select="funcs">
                                <xsl:with-param name="module" select="module"/>
                            </xsl:apply-templates>
                        </section>
                    </xsl:if>
                </article>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="erlref/datatypes">
        <xsl:param name="module"/>
        <dl>
            <xsl:apply-templates select="datatype">
                <xsl:with-param name="module" select="$module"/>
            </xsl:apply-templates>
        </dl>
    </xsl:template>

    <xsl:template match="erlref/datatypes/datatype">
        <xsl:param name="module"/>

        <xsl:choose>
            <xsl:when test="name[@name]">
                <xsl:variable name="name" select="name/@name"/>
                <xsl:variable name="n_vars" select="name/@n_vars"/>
                <xsl:variable name="type"
                              select="$specs/specs/module[@name=$module]/type[
                        (name = $name) and
                        (string-length($n_vars) = 0 or n_vars = $n_vars)]"/>
                <xsl:variable name="arity" select="$type/n_vars"/>

                <dt><a id="type:{$name}"><pre><xsl:value-of select="$name"/>/<xsl:value-of select="$arity"/></pre></a></dt>
                <dd>
                    <pre><code class="erlang"><xsl:apply-templates select="$type/typedecl/typehead"/></code></pre>
                    <xsl:apply-templates select="desc"/>
                </dd>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="name" select="substring-after(name/marker/@id, 'type-')"/>
                <xsl:variable name="arity" select="0"/>

                <dt><a id="type:{$name}"><pre><xsl:value-of select="$name"/>/<xsl:value-of select="$arity"/></pre></a></dt>
                <dd>
                    <xsl:apply-templates select="desc"/>
                </dd>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="erlref/datatypes" mode="menu">
        <xsl:param name="module"/>
        <ul>
            <xsl:apply-templates select="datatype" mode="menu">
                <xsl:with-param name="module" select="$module"/>
            </xsl:apply-templates>
        </ul>
    </xsl:template>

    <xsl:template match="erlref/datatypes/datatype" mode="menu">
        <xsl:param name="module"/>

        <xsl:choose>
            <xsl:when test="name[@name]">
                <xsl:variable name="name" select="name/@name"/>
                <xsl:variable name="n_vars" select="name/@n_vars"/>
                <xsl:variable name="type"
                              select="$specs/specs/module[@name=$module]/type[
                        (name = $name) and
                        (string-length($n_vars) = 0 or n_vars = $n_vars)]"/>
                <xsl:variable name="arity" select="$type/n_vars"/>
                <li><a href="#type:{$name}"><xsl:value-of select="$name"/>/<xsl:value-of select="$arity"/></a></li>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="name" select="substring-after(name/marker/@id, 'type-')"/>
                <xsl:variable name="arity" select="0"/>
                <li><a href="#type:{$name}"><xsl:value-of select="$name"/>/<xsl:value-of select="$arity"/></a></li>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template match="erlref/funcs">
        <xsl:param name="module"/>
        <dl>
            <xsl:apply-templates select="func">
                <xsl:with-param name="module" select="$module"/>
            </xsl:apply-templates>
        </dl>
    </xsl:template>

    <xsl:template match="erlref/funcs/func">
        <xsl:param name="module"/>
        <xsl:variable name="name" select="name/@name"/>
        <xsl:variable name="arity" select="name/@arity"/>
        <xsl:variable name="spec"
                      select="$specs/specs/module[@name=$module]/spec[(name = $name) and (arity = $arity)]"/>
        <xsl:variable name="clause" select="$spec/contract/clause"/>

        <dt><a id="{$name}/{$arity}"><pre><xsl:value-of select="$name"/>/<xsl:value-of select="$arity"/></pre></a></dt>
        <dd>
            <pre><code class="erlang"><xsl:apply-templates select="$clause/head"/></code></pre>
            <xsl:if test="count($clause/guard) = 1">
                where
                <pre>
                    <code class="erlang">
                        <xsl:for-each select="$clause/guard/subtype[string-length(normalize-space(string)) > 0]">
                            <xsl:apply-templates select="string"/><br/>
                        </xsl:for-each>
                    </code>
                </pre>
            </xsl:if>
            <xsl:apply-templates select="desc"/>
        </dd>
    </xsl:template>

    <xsl:template match="spec/contract/clause/head/br"/>
    <xsl:template match="spec/contract/clause/head/nbsp"/>

    <xsl:template match="erlref/funcs" mode="menu">
        <xsl:param name="module"/>
        <ul>
            <xsl:apply-templates select="func" mode="menu"/>
        </ul>
    </xsl:template>

    <xsl:template match="erlref/funcs/func" mode="menu">
        <xsl:variable name="name" select="name/@name"/>
        <xsl:variable name="arity" select="name/@arity"/>

        <li><a href="#{$name}/{$arity}"><xsl:value-of select="$name"/>/<xsl:value-of select="$arity"/></a></li>
    </xsl:template>

    <!-- Generic -->
    <xsl:template match="section">
        <section>
            <h2><xsl:value-of select="title"/></h2>
            <xsl:apply-templates/>
        </section>
    </xsl:template>

    <xsl:template match="section/title"/>

    <!-- HTML5 -->
    <xsl:template name="html.document">
        <xsl:param name="out"/>
        <xsl:param name="root"/>
        <xsl:param name="title"/>
        <xsl:param name="description"/>
        <xsl:param name="body"/>

        <xsl:document href="{$out}"
                      omit-xml-declaration="yes"
                      method="html"
                      encoding="UTF-8"
                      indent="yes">
            <xsl:text disable-output-escaping="yes"><![CDATA[<!doctype html>
]]></xsl:text>
            <html>
                <head>
                    <meta charset="utf-8"/>
                    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
                    <xsl:choose>
                        <xsl:when test="string-length($winprefix) > 0">
                            <title><xsl:value-of select="$winprefix"/> &#8211; <xsl:value-of select="$title"/></title>
                        </xsl:when>
                        <xsl:otherwise>
                            <title>Erlang &#8211; <xsl:value-of select="$title"/></title>
                        </xsl:otherwise>
                    </xsl:choose>
                    <meta name="description" content="{$description}"/>
                    <meta name="viewport" content="width=device-width, initial-scale=1"/>
                    <link rel="stylesheet" href="{$root}/css/normalize.css"/>
                    <link rel="stylesheet" href="{$root}/css/doc.css"/>
                    <link rel="stylesheet" href="{$root}/css/highlight.css"/>
                </head>
                <body>
                    <main>
                        <xsl:copy-of select="$body"/>
                    </main>
                    <footer>
                        <hr/>
                        <p>
                            <xsl:value-of select="$copyright"/>
                            <xsl:value-of select="/book/header/copyright/year[1]"/>
                            <xsl:text>-</xsl:text>
                            <xsl:value-of select="substring-after(normalize-space(substring-after($gendate, ' ')), ' ')"/>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="/book/header/copyright/holder"/>
                        </p>
                    </footer>
                    <script src="{$root}/js/highlight/highlight.pack.js"></script>
                    <script><![CDATA[hljs.initHighlightingOnLoad();]]></script>
                </body>
            </html>
        </xsl:document>
    </xsl:template>
</xsl:stylesheet>
