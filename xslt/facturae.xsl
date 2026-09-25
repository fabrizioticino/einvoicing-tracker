<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fe="http://www.facturae.es/Facturae/2014/v3.2.2/Facturae"
  xmlns:fe31="http://www.facturae.es/Facturae/2009/v3.1/Facturae"
  xmlns:fe32="http://www.facturae.es/Facturae/2007/v3.2/Facturae">

<xsl:output method="html" encoding="UTF-8" indent="yes" doctype-public="-//W3C//DTD HTML 4.01//EN"/>

<xsl:template match="/">
  <html lang="it">
  <head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>FacturaE — <xsl:value-of select="//fe:InvoiceNumber|//InvoiceNumber"/> — <xsl:value-of select="//fe:SellerParty//fe:CorporateName|//SellerParty//CorporateName"/></title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,600&amp;family=IBM+Plex+Mono:wght@400;600&amp;family=Inter:wght@400;500;600;700&amp;display=swap"/>
    <style>
*{box-sizing:border-box;margin:0;padding:0}
html{background:#f0f0f0}
body{font-family:'Inter',sans-serif;font-size:13px;color:#161616;padding:20px}
.inv{max-width:860px;margin:0 auto;background:#fff;padding:32px 36px;box-shadow:0 1px 6px rgba(0,0,0,.08)}
h1{font-family:'Fraunces',serif;font-size:26px;font-weight:600;margin-bottom:4px}
.badge{display:inline-block;font-family:'IBM Plex Mono',monospace;font-size:9px;font-weight:700;padding:2px 7px;border-radius:3px;text-transform:uppercase;letter-spacing:.05em;background:#fee2e2;color:#991b1b;margin-bottom:14px}
.hd{display:flex;justify-content:space-between;align-items:flex-start;border-bottom:2px solid #161616;padding-bottom:16px;margin-bottom:20px;gap:20px}
.docnum{font-family:'IBM Plex Mono',monospace;font-size:15px;font-weight:600;text-align:right}
.docmeta{font-family:'IBM Plex Mono',monospace;font-size:10px;color:#666;text-align:right;margin-top:3px}
.parties{display:flex;gap:20px;background:#f5f5f5;padding:14px 16px;border-radius:5px;margin-bottom:20px}
.party{flex:1}
.plabel{font-size:9px;font-weight:700;text-transform:uppercase;letter-spacing:.08em;color:#888;font-family:'IBM Plex Mono',monospace;margin-bottom:3px}
.pname{font-weight:700;font-size:13.5px;margin-bottom:2px}
.pvat,.paddr{font-family:'IBM Plex Mono',monospace;font-size:10.5px;color:#666;margin-top:2px}
table{width:100%;border-collapse:collapse;margin-bottom:16px;font-size:12px}
thead th{background:#161616;color:#fff;padding:6px 8px;text-align:left;font-family:'IBM Plex Mono',monospace;font-size:9px;letter-spacing:.04em}
.r{text-align:right}
tbody td{padding:6px 8px;border-bottom:1px solid #e0e0e0;color:#555}
tbody td.desc{color:#161616}
tbody tr:nth-child(even) td{background:#fafafa}
.stitle{font-size:9px;font-weight:700;text-transform:uppercase;letter-spacing:.07em;color:#888;font-family:'IBM Plex Mono',monospace;margin:14px 0 6px}
.totals{margin-left:auto;width:240px}
.trow{display:flex;justify-content:space-between;padding:4px 0;font-size:12px;border-bottom:1px solid #eee}
.trow.grand{border:none;font-weight:700;font-size:15px;padding-top:8px}
.trow .lbl{color:#666}
.trow .val{font-family:'IBM Plex Mono',monospace}
footer{margin-top:24px;padding-top:10px;border-top:1px solid #e0e0e0;font-size:9px;color:#aaa;text-align:center;font-family:'IBM Plex Mono',monospace}
@media print{html{background:#fff}body{padding:0}.inv{box-shadow:none}@page{margin:16mm;size:A4}}
    </style>
  </head>
  <body>
  <div class="inv">
    <xsl:apply-templates select="//fe:Facturae|//Facturae"/>
    <footer>E-Invoicing Tracker · Resa visiva FacturaE 3.2 — el documento original es el archivo XML</footer>
  </div>
  </body>
  </html>
</xsl:template>

<xsl:template match="fe:Facturae|Facturae">
  <xsl:variable name="inv" select=".//fe:Invoice|.//Invoice"/>
  <xsl:variable name="cur" select="$inv//fe:InvoiceCurrencyCode|$inv//InvoiceCurrencyCode"/>
  <xsl:variable name="seller" select=".//fe:SellerParty|.//SellerParty"/>
  <xsl:variable name="buyer"  select=".//fe:BuyerParty|.//BuyerParty"/>

  <xsl:variable name="docType" select="$inv//fe:InvoiceDocumentType|$inv//InvoiceDocumentType"/>

  <div class="hd">
    <div>
      <h1>
        <xsl:choose>
          <xsl:when test="$docType='FC'">Factura</xsl:when>
          <xsl:when test="$docType='FA'">Factura simplificada</xsl:when>
          <xsl:when test="$docType='AF'">Nota de crédito</xsl:when>
          <xsl:otherwise>Documento fiscal</xsl:otherwise>
        </xsl:choose>
      </h1>
      <span class="badge">FacturaE 3.2 · Spagna</span>
    </div>
    <div>
      <div class="docnum">N. <xsl:value-of select="$inv//fe:InvoiceNumber|$inv//InvoiceNumber"/></div>
      <div class="docmeta"><xsl:value-of select="$inv//fe:IssueDate|$inv//IssueDate"/></div>
    </div>
  </div>

  <div class="parties">
    <div class="party">
      <div class="plabel">Vendedor (Fornitore)</div>
      <div class="pname">
        <xsl:value-of select="$seller//fe:CorporateName|$seller//CorporateName"/>
        <xsl:if test="not($seller//fe:CorporateName) and not($seller//CorporateName)">
          <xsl:value-of select="$seller//fe:FirstSurname|$seller//FirstSurname"/>&#160;<xsl:value-of select="$seller//fe:FirstName|$seller//FirstName"/>
        </xsl:if>
      </div>
      <div class="pvat">NIF: <xsl:value-of select="$seller//fe:TaxIdentificationNumber|$seller//TaxIdentificationNumber"/></div>
    </div>
    <div class="party">
      <div class="plabel">Comprador (Acquirente)</div>
      <div class="pname">
        <xsl:value-of select="$buyer//fe:CorporateName|$buyer//CorporateName"/>
        <xsl:if test="not($buyer//fe:CorporateName) and not($buyer//CorporateName)">
          <xsl:value-of select="$buyer//fe:FirstSurname|$buyer//FirstSurname"/>&#160;<xsl:value-of select="$buyer//fe:FirstName|$buyer//FirstName"/>
        </xsl:if>
      </div>
      <div class="pvat">NIF: <xsl:value-of select="$buyer//fe:TaxIdentificationNumber|$buyer//TaxIdentificationNumber"/></div>
    </div>
  </div>

  <xsl:if test="$inv//fe:InvoiceLine|$inv//InvoiceLine">
    <div class="stitle">Líneas de factura (Righe)</div>
    <table>
      <thead>
        <tr>
          <th>#</th><th>Descripción</th><th class="r">Cantidad</th><th class="r">Precio unit.</th><th class="r">IVA %</th><th class="r">Importe <xsl:value-of select="$cur"/></th>
        </tr>
      </thead>
      <tbody>
        <xsl:for-each select="$inv//fe:InvoiceLine|$inv//InvoiceLine">
          <xsl:variable name="pos" select="position()"/>
          <tr>
            <td><xsl:value-of select="$pos"/></td>
            <td class="desc"><xsl:value-of select="fe:ItemDescription|ItemDescription"/></td>
            <td class="r"><xsl:value-of select="fe:Quantity|Quantity"/></td>
            <td class="r"><xsl:value-of select="fe:UnitPriceWithoutTax|UnitPriceWithoutTax"/></td>
            <td class="r"></td>
            <td class="r"><xsl:value-of select="fe:GrossAmount|GrossAmount"/></td>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:if>

  <xsl:if test="$inv//fe:TaxesOutputs//fe:Tax|$inv//TaxesOutputs//Tax">
    <div class="stitle">Impuestos (Riepilogo IVA)</div>
    <table>
      <thead>
        <tr><th>Tipo / Aliquota</th><th class="r">Base imponible</th><th class="r">Cuota impuesto</th></tr>
      </thead>
      <tbody>
        <xsl:for-each select="$inv//fe:TaxesOutputs//fe:Tax|$inv//TaxesOutputs//Tax">
          <tr>
            <td><xsl:value-of select="fe:TaxTypeCode|TaxTypeCode"/>&#160;<xsl:value-of select="fe:TaxRate|TaxRate"/>%</td>
            <td class="r"><xsl:value-of select="fe:TaxableBase/fe:TotalAmount|TaxableBase/TotalAmount"/></td>
            <td class="r"><xsl:value-of select="fe:TaxAmount/fe:TotalAmount|TaxAmount/TotalAmount"/></td>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:if>

  <div class="totals">
    <xsl:if test="$inv//fe:TotalGrossAmount|$inv//TotalGrossAmount">
      <div class="trow"><span class="lbl">Base imponible</span><span class="val"><xsl:value-of select="$inv//fe:TotalGrossAmount|$inv//TotalGrossAmount"/>&#160;<xsl:value-of select="$cur"/></span></div>
    </xsl:if>
    <xsl:if test="$inv//fe:TotalTaxOutputs|$inv//TotalTaxOutputs">
      <div class="trow"><span class="lbl">IVA</span><span class="val"><xsl:value-of select="$inv//fe:TotalTaxOutputs|$inv//TotalTaxOutputs"/>&#160;<xsl:value-of select="$cur"/></span></div>
    </xsl:if>
    <div class="trow grand">
      <span class="lbl">Total factura</span>
      <span class="val"><xsl:value-of select="$inv//fe:InvoiceTotal|$inv//InvoiceTotal"/>&#160;<xsl:value-of select="$cur"/></span>
    </div>
  </div>
</xsl:template>

</xsl:stylesheet>
