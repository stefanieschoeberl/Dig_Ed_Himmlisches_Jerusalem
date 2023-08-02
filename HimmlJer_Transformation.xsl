<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs tei"
    xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0">
    <xsl:output method="xml" indent="yes" encoding="UTF-8" doctype-system="about:legacy-compat"/>

    <xsl:variable name="charDecl" select="tei:TEI/tei:teiHeader/tei:encodingDesc/tei:charDecl"/>

    <xsl:template match="/">
        <html>
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>

                <title>
                    <xsl:value-of select="//tei:titleStmt/tei:title"/>
                </title>
                <meta name="viewport" content="width=device-width, initial-scale=1"/>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/css/bootstrap.min.css"
                    rel="stylesheet"/>
                <link rel="stylesheet" type="text/css" href="HimmlJer_Stylesheet.css"/>
            </head>
            <body>
                <section id="header">
                    <h1>
                        <xsl:value-of select="//tei:titleStmt/tei:title"/>
                    </h1>
                    <section id="resp">
                        <h2>
                            <xsl:value-of select="//tei:resp"/>
                            <xsl:text> von </xsl:text>
                            <xsl:value-of select="//tei:respStmt/tei:persName"/>
                        </h2>
                    </section>
                    <section id="subheader_source" class="header2">
                        <h2>
                            <xsl:text>Kodikologie</xsl:text>
                        </h2>
                        <xsl:apply-templates select="//tei:msDesc" mode="source"/>
                    </section>
                    <section id="subheader_encoding" class="header2">
                        <h2>
                            <xsl:text>Zur Edition</xsl:text>
                        </h2>
                        <xsl:apply-templates select="//tei:encodingDesc" mode="encoding"/>
                    </section>
                    <section id="body_hyper" class="body_hyper">
                        <xsl:apply-templates select="//tei:lg" mode="hyper"/>
                    </section>
                    <section id="body_norm" class="body_norm">
                        <xsl:apply-templates select="//tei:lg" mode="norm"/>
                    </section>
                </section>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-gtEjrD/SeCtmISkJkNUaaKMoLD0//ElJ19smozuHV6z3Iehds+3Ulb9Bn9Plx0x4" crossorigin="anonymous"/>
                <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js" integrity="sha384-IQsoLXl5PILFhosVNubq5LC7Qb9DXgDA9i+tQ8Zj3iwWAwPtgFTxbJ8NT4GN1R8p" crossorigin="anonymous"/>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/js/bootstrap.min.js" integrity="sha384-Atwg2Pkwv9vp0ygtn1JAojH0nYbwNJLPhwyoVbhoPwBhjQPR5VtM2+xf0Uwh9KtT" crossorigin="anonymous"/>

            </body>
        </html>
    </xsl:template>

    <!-- hyperdiplomatische Anzeige-->
    <!-- Aufbau der Seitenstruktur (Folio-Anzeige, Strophen, Zeilen) -->
    <xsl:template match="tei:lg" mode="hyper">
        <h2>
            <xsl:text>Fol. </xsl:text>
            <xsl:value-of select="substring(@facs, 8, 5)"/>
            <xsl:text> (Strophe </xsl:text>
            <xsl:value-of select="substring-after(@xml:id, '_p')"/>
            <xsl:text>)</xsl:text>
        </h2>
        <section>
            <xsl:for-each select=".">
                <p>
                    <xsl:apply-templates select="." mode="hyper_text"/>
                </p>
            </xsl:for-each>
        </section>
    </xsl:template>

    <xsl:template match="tei:lb" mode="hyper_text">
        <xsl:for-each select=".">
            <section>
                <p>
                    <span class="lb">
                        <xsl:value-of select="@n"/>
                    </span>
                </p>
                <p>
                    <span class="hyper">
                        <xsl:value-of select="."/>
                    </span>
                </p>
            </section>
        </xsl:for-each>
    </xsl:template>

    <!-- Abkürzungen, Normierungen, Notes, Additions -->
    <xsl:template match="tei:expan" mode="hyper_text">
        <xsl:text/>
    </xsl:template>

    <xsl:template match="tei:reg" mode="hyper_text">
        <xsl:text/>
    </xsl:template>

    <xsl:template match="tei:note" mode="hyper_text">
        <span class="note">
            <xsl:value-of select="."/>
        </span>
    </xsl:template>

    <xsl:template match="tei:add" mode="hyper_text">
        <xsl:choose>
            <xsl:when test="@type = 'addition'">
                <span class="hi">
                    <xsl:value-of select="."/>
                </span>
                <span class="note">
                    <xsl:text> (Addition)</xsl:text>
                </span>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- Zeichendarstellung -->
    <xsl:template match="tei:g" mode="hyper_text">
        <xsl:param name="url">
            <xsl:text/>
        </xsl:param>
        <xsl:variable name="zeichenID">
            <xsl:value-of select="substring(@ref, 2)"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$url = ''">
                <xsl:value-of
                    select="$charDecl/tei:glyph[@xml:id = $zeichenID]/child::tei:mapping[@subtype = 'html_entity']"
                />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of
                    select="doc('http://ressource_url')//tei:glyph[@xml:id = $zeichenID]/child::tei:mapping[@subtype = 'html_entity']"
                />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- Anzeige nach Versen -->
    <!-- Aufbau der Seitenstruktur (Strophen, Zeilen) -->
    <xsl:template match="tei:lg" mode="norm">
        <h2>
            <xsl:text>Strophe </xsl:text>
            <xsl:value-of select="substring-after(@xml:id, '_p')"/>
        </h2>
        <section class="ln">
            <xsl:for-each select="tei:l">
                <p>
                    <xsl:value-of select="@n"/>
                </p>
            </xsl:for-each>
        </section>

        <section class="norm">
            <xsl:for-each select="tei:l">
                <p>
                    <xsl:apply-templates select="." mode="norm"/>
                </p>
            </xsl:for-each>
        </section>
    </xsl:template>

    <!-- Auszeichnung der Zeilennummerierung (außerhalb von <choice>) -->
    <xsl:template match="//tei:lb" mode="norm">
        <span class="note">
            <xsl:text>(</xsl:text>
            <xsl:value-of select="@n"/>
            <xsl:text>) </xsl:text>
        </span>
    </xsl:template>

    <!-- Abkürzungen, Normierungen (+ Zeilennummerierung innerhalb von <choice>), Notes, Additions  -->
    <xsl:template match="tei:choice" mode="norm">
        <span>
            <xsl:choose>
                <xsl:when test="@ana = 'abbr'">
                    <xsl:value-of select="tei:expan"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="@ana = 'lb'">
                            <span class="lb_note">
                                <xsl:text>(</xsl:text>
                                <xsl:value-of select="tei:orig/tei:lb/@n"/>
                                <xsl:text>) </xsl:text>
                            </span>
                            <span>
                                <xsl:value-of select="tei:reg"/>
                            </span>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="tei:reg"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:template>

    <xsl:template match="tei:note" mode="norm">
        <span class="note">
            <xsl:value-of select="."/>
        </span>
    </xsl:template>

    <xsl:template match="tei:add" mode="norm">
        <xsl:choose>
            <xsl:when test="@type = 'addition'">
                <span class="hi">
                    <xsl:value-of select="."/>
                </span>
                <span class="note">
                    <xsl:text> (Addition)</xsl:text>
                </span>
            </xsl:when>
        </xsl:choose>
    </xsl:template>


    <!-- MS-Description -->
    <xsl:template match="tei:msDesc" mode="source">
        <section id="msIdentifier" class="subheader">
            <!-- maschinell - inkonsistente Bezeichnungen
            <xsl:for-each select="tei:msIdentifier/child::*">
                <p>
                    <xsl:value-of select="@ana"/>
                    <xsl:text>: </xsl:text>
                    <xsl:value-of select="."/>
                </p>
            </xsl:for-each>
            <xsl:for-each select="tei:msContents/tei:msItem/child::*">
                <p>
                    <xsl:value-of select="@ana"/>
                    <xsl:text>: </xsl:text>
                    <xsl:value-of select="."/>
                </p>
            </xsl:for-each>-->
            <p>
                <xsl:text>Land: </xsl:text>
                <xsl:value-of select="//tei:msIdentifier/tei:country"/>
            </p>
            <p>
                <xsl:text>Institution: </xsl:text>
                <xsl:value-of select="//tei:msIdentifier/tei:institution"/>
            </p>
            <p>
                <xsl:text>Signatur: </xsl:text>
                <xsl:value-of select="//tei:msIdentifier/tei:idno"/>
            </p>
            <p>
                <xsl:text>Alternativ-Signatur: </xsl:text>
                <xsl:value-of select="//tei:msIdentifier/tei:altIdentifier[@type='shelfmark']/tei:idno"/>
            </p>
            <p>
                <xsl:text>Alternativ-Signatur: </xsl:text>
                <xsl:value-of select="//tei:msIdentifier/tei:altIdentifier[@type='URI']/tei:idno"/>
            </p>
            <p>
                <xsl:text>Titel: </xsl:text>
                <xsl:value-of select="//tei:msItem/tei:title"/>
            </p>
            <p>
                <xsl:text>Locus: </xsl:text>
                <xsl:value-of select="//tei:msItem/tei:locus"/>
            </p>
            <p>
                <xsl:text>Sprache (Großteil): </xsl:text>
                <xsl:value-of select="//tei:msItem/tei:textLang[@ana='main']"/>
            </p>
            <p>
                <xsl:text>Sprache (Einfluss): </xsl:text>
                <xsl:value-of select="//tei:msItem/tei:textLang[@ana='traces']"/>
            </p>
        </section>
        <section id="physDesc_objectDesc" class="subheader">
            <p style="font-weight:bold">
                <xsl:text>Support-Description</xsl:text>
            </p>
            <p>
                <xsl:text>Umfang: </xsl:text>
                <xsl:value-of select="//tei:measure[@type = 'leafs']"/>
                <xsl:text> Blätter</xsl:text>
            </p>
            <p>
                <xsl:text>Blattgröße: </xsl:text>
                <xsl:value-of select="//tei:measureGrp/tei:height"/>
                <xsl:text>mm x </xsl:text>
                <xsl:value-of select="//tei:measureGrp/tei:width"/>
                <xsl:text>mm</xsl:text>
            </p>
            <!-- maschinell - inkonsistente Bezeichnung
            <xsl:for-each select="//tei:extent/following-sibling::*">
                <p>
                    <xsl:value-of select="node-name(.)"/>
                    <xsl:text>: </xsl:text>
                    <xsl:value-of select="."/>
                </p>
            </xsl:for-each>-->
            <p>
                <xsl:text>Material: </xsl:text>
                <xsl:value-of select="//tei:extent/tei:material"/>
            </p>
            <p>
                <xsl:text>Foliation: </xsl:text>
                <xsl:value-of select="//tei:foliation"/>
            </p>
            <p>
                <xsl:text>Bindung: </xsl:text>
                <xsl:value-of select="//tei:collation"/>
            </p>
            <p>
                <xsl:text>Zustand: </xsl:text>
                <xsl:value-of select="//tei:condition/tei:desc"/>
            </p>
            <p style="font-weight:bold">
                <xsl:text>Layout-Description</xsl:text>
            </p>
            <p>
                <xsl:text>Spalten: </xsl:text>
                <xsl:value-of select="//tei:layout/@columns"/>
                <xsl:text>; Zeilen: </xsl:text>
                <xsl:value-of select="//tei:layout/@writtenLines"/>
            </p>
            <p>
                <xsl:text>Schriftraum: </xsl:text>
                <xsl:value-of select="//tei:measure/tei:height"/>
                <xsl:text>mm x </xsl:text>
                <xsl:value-of select="//tei:layout/tei:measure/tei:width"/>
                <xsl:text>mm</xsl:text>
            </p>
            <p>
                <xsl:text>Beschreibung: </xsl:text>
                <xsl:value-of select="//tei:layout/tei:desc"/>
            </p>
        </section>
        <section id="handDesc" class="subheader">
            <p style="font-weight:bold">
                <xsl:text>Hand-Description</xsl:text>
            </p>
            <xsl:for-each select="//tei:handNote">
                <p>
                    <xsl:value-of select="@xml:id"/>
                    <xsl:text>: </xsl:text>
                    <xsl:value-of select="tei:locus"/>
                </p>
                <p>
                    <xsl:text>Beschreibung: </xsl:text>
                    <xsl:value-of select="tei:desc"/>
                </p>
            </xsl:for-each>
        </section>
        <section id="history" class="subheader">
            <p>
                <xsl:text>Entstehungszeit: </xsl:text>
                <xsl:value-of select="//tei:origDate"/>
            </p>
            <p>
                <xsl:text>Enstehungsort: </xsl:text>
                <xsl:value-of select="//tei:origPlace"/>
            </p>
            <p>
                <xsl:text>Provenienz: </xsl:text>
                <xsl:value-of select="//tei:provenance"/>
            </p>
            <!-- maschinell - inkonsistente Bezeichnung
            <xsl:for-each select="//tei:history/child::*">
                <p>
                    <xsl:value-of select="node-name(.)"/>
                    <xsl:text>: </xsl:text>
                    <xsl:value-of select="."/>
                </p>
            </xsl:for-each> -->
        </section>
    </xsl:template>


    <!-- Encoding-Description -->
    <xsl:template match="tei:encodingDesc" mode="encoding">
        <section id="editorialDecl" class="subheader">
            <xsl:for-each select="tei:editorialDecl/tei:p">
                <p style="font-weight:bold">
                    <xsl:value-of select="@ana"/>
                </p>
                <ul>
                    <xsl:for-each select="tei:list/tei:item">
                        <li>
                            <xsl:value-of select="."/>
                        </li>
                    </xsl:for-each>
                </ul>
            </xsl:for-each>
        </section>
        <section id="charDecl" class="subheader">
            <p style="font-weight:bold">
                <xsl:text>Character Declaration</xsl:text>
            </p>
            <p>
                <xsl:text>Das Zeicheninventar mit unmittelbarer Entsprechung in der ASCII-Tabelle wird hier nicht explizit aufgeführt.</xsl:text>
            </p>
            <table>
                <thead>
                    <tr>
                        <th>Beschreibung</th>
                        <th>Typ</th>
                        <th>Normalisierte Form</th>
                        <th>Unicode-Codepoint</th>
                        <th>Unicode-Tabelle</th>
                        <th>Unicode-Symbol</th>
                        <th>Referenz</th>
                    </tr>
                </thead>
                <tbody>
                    <xsl:for-each select="tei:charDecl/tei:glyph">
                        <tr>
                            <td>
                                <xsl:value-of select="tei:desc"/>
                            </td>
                            <td>
                                <xsl:value-of select="@ana"/>
                            </td>
                            <td>
                                <xsl:value-of select="tei:mapping[@type = 'normalized']"/>
                            </td>
                            <td>
                                <xsl:value-of select="tei:mapping[@type = 'unicode_codepoint']"/>
                            </td>
                            <td>
                                <xsl:value-of
                                    select="tei:mapping[@type = 'unicode_codepoint']/@subtype"/>
                            </td>
                            <td>
                                <xsl:value-of select="tei:mapping[@type = 'unicode_symbol']"/>
                            </td>
                            <td>
                                <xsl:choose>
                                    <xsl:when test="@source">
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="@resp"/></xsl:attribute>
                                        <xsl:value-of select="@resp"/>
                                        <xsl:text>, </xsl:text>
                                        <xsl:value-of select="@source"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="@resp"/></xsl:attribute>
                                        <xsl:value-of select="@resp"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </td>
                        </tr>
                    </xsl:for-each>
                </tbody>
            </table>
        </section>
    </xsl:template>

</xsl:stylesheet>
