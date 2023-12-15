<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template match="/">
        <html>
            <body>
                <h1> Zespoły: </h1>
                <ol>
                    <xsl:apply-templates select="//ROW" />
                    <br/>
                    <xsl:apply-templates select="." mode="details"/>
                </ol>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="ROW">
        <xsl:if test="NAZWA != ''">
            <li>
                <a href="#{ID_ZESP}">
                    <xsl:value-of select="NAZWA"/>
                </a>
            </li>
        </xsl:if>
    </xsl:template>

    <xsl:template match="ROW" mode="details">
        <div>
            <strong id="{ID_ZESP}">NAZWA:  <xsl:value-of select="NAZWA"/> </strong>
            <br/>
            <strong>ADRES: <xsl:value-of select="ADRES"/> </strong>
            <br/> <br/>
            <xsl:variable name="employeeCount" select="count(PRACOWNICY/ROW[ID_ZESP = current()/ID_ZESP])"/>
            <xsl:if test="$employeeCount > 0">
                <table border="1">
                    <tr>
                        <th>Nazwisko</th>
                        <th>Etat</th>
                        <th>Zatrudniony</th>
                        <th>Placa pod.</th>
                        <th>Szef</th>
                    </tr>
                    <xsl:apply-templates select="PRACOWNICY/ROW" mode="employee_details" >
                        <xsl:sort select="NAZWISKO" />
                    </xsl:apply-templates>
                </table>
            </xsl:if>
            Liczba pracowników: <xsl:value-of select="count(PRACOWNICY/ROW[ID_ZESP = current()/ID_ZESP])"/>
            <br/> <br/>
        </div>
    </xsl:template>

    <xsl:template match="ROW/PRACOWNICY/ROW" mode="employee_details">
        <tr>
            <td><xsl:value-of select="NAZWISKO"/></td>
            <td><xsl:value-of select="ETAT"/></td>
            <td><xsl:value-of select="ZATRUDNIONY"/></td>
            <td><xsl:value-of select="PLACA_POD"/></td>
            <td>
                <xsl:choose>
                    <xsl:when test="ID_SZEFA">
                        <xsl:value-of select="//ROW/PRACOWNICY/ROW[ID_PRAC = current()/ID_SZEFA]/NAZWISKO"/>
                    </xsl:when>
                    <xsl:otherwise>brak</xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
    </xsl:template>
</xsl:stylesheet>
