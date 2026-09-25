<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rsm="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100"
  xmlns:ram="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100"
  xmlns:udt="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100"
  xmlns:qdt="urn:un:unece:uncefact:data:standard:QualifiedDataType:100">

<xsl:output method="html" encoding="UTF-8" indent="yes" doctype-public="-//W3C//DTD HTML 4.01//EN"/>

<xsl:template match="/">
  <html lang="it">
  <head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Factur-X / ZUGFeRD CII — <xsl:value-of select="//rsm:ExchangedDocument/ram:ID|//ExchangedDocument/ID"/> — <xsl:value-of select="//ram:SellerTradeParty/ram:Name|//SellerTradeParty/Name"/></title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,600&amp;family=IBM+Plex+Mono:wght@400;600&amp;family=Inter:wght@400;500;600;700&amp;display=swap"/>
    <style>
*{box-sizing:border-box;margin:0;padding:0}
html{background:#f0f0f0}
body{font-family:'Inter',sans-serif;font-size:13px;color:#161616;padding:20px}
.inv{max-width:860px;margin:0 auto;background:#fff;padding:32px 36px;box-shadow:0 1px 6px rgba(0,0,0,.08)}
h1{font-family:'Fraunces',serif;font-size:26px;font-weight:600;margin-bottom:4px}
.badge{display:inline-block;font-family:'IBM Plex Mono',monospace;font-size:9px;font-weight:700;padding:2px 7px;border-radius:3px;text-transform:uppercase;letter-spacing:.05em;background:#ede9fe;color:#4c1d95;margin-bottom:14px}
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
.totals{margin-left:auto;width:260px}
.trow{display:flex;justify-content:space-between;padding:4px 0;font-size:12px;border-bottom:1px solid #eee}
.trow.grand{border:none;font-weight:700;font-size:15px;padding-top:8px}
.trow .lbl{color:#666}
.trow .val{font-family:'IBM Plex Mono',monospace}
.notes{margin-top:14px;padding:10px 12px;background:#f5f5f5;border-left:3px solid #ccc;font-size:11.5px;color:#666}
footer{margin-top:24px;padding-top:10px;border-top:1px solid #e0e0e0;font-size:9px;color:#aaa;text-align:center;font-family:'IBM Plex Mono',monospace}
@media print{html{background:#fff}body{padding:0}.inv{box-shadow:none}@page{margin:16mm;size:A4}}
    </style>
  </head>
  <body>
  <div class="inv">
    <xsl:apply-templates select="//rsm:CrossIndustryInvoice|//CrossIndustryInvoice"/>
    <footer>E-Invoicing Tracker · Resa visiva Factur-X / ZUGFeRD CII — il documento originale è il file XML</footer>
  </div>
  </body>
  </html>
</xsl:template>

<xsl:template match="rsm:CrossIndustryInvoice|CrossIndustryInvoice">
  <xsl:variable name="exdoc"  select=".//rsm:ExchangedDocument|.//ExchangedDocument"/>
  <xsl:variable name="supply" select=".//ram:SupplyChainTradeTransaction|.//SupplyChainTradeTransaction"/>
  <xsl:variable name="hdr"    select="$supply//ram:ApplicableHeaderTradeAgreement|$supply//ApplicableHeaderTradeAgreement"/>
  <xsl:variable name="dlv"    select="$supply//ram:ApplicableHeaderTradeDelivery|$supply//ApplicableHeaderTradeDelivery"/>
  <xsl:variable name="sett"   select="$supply//ram:ApplicableHeaderTradeSettlement|$supply//ApplicableHeaderTradeSettlement"/>
  <xsl:variable name="seller" select="$hdr//ram:SellerTradeParty|$hdr//SellerTradeParty"/>
  <xsl:variable name="buyer"  select="$hdr//ram:BuyerTradeParty|$hdr//BuyerTradeParty"/>
  <xsl:variable name="cur"    select="$sett/ram:InvoiceCurrencyCode|$sett/InvoiceCurrencyCode"/>

  <xsl:variable name="typeCode" select="$exdoc/ram:TypeCode|$exdoc/TypeCode"/>
  <xsl:variable name="rawDate"  select="$exdoc/ram:IssueDateTime//udt:DateTimeString|$exdoc/IssueDateTime/DateTimeString"/>

  <xsl:variable name="profile" select="//rsm:ExchangedDocumentContext//ram:GuidelineSpecifiedDocumentContextParameter/ram:ID|//ExchangedDocumentContext//GuidelineSpecifiedDocumentContextParameter/ID"/>

  <div class="hd">
    <div>
      <h1>
        <xsl:choose>
          <xsl:when test="$typeCode='380'">Fattura commerciale</xsl:when>
          <xsl:when test="$typeCode='381'">Nota di credito</xsl:when>
          <xsl:when test="$typeCode='383'">Nota di addebito</xsl:when>
          <xsl:when test="$typeCode='389'">Fattura a saldo</xsl:when>
          <xsl:otherwise>Documento (<xsl:value-of select="$typeCode"/>)</xsl:otherwise>
        </xsl:choose>
      </h1>
      <span class="badge">
        <xsl:choose>
          <xsl:when test="contains($profile,'zugferd') or contains($profile,'ZUGFeRD')">ZUGFeRD · Germania</xsl:when>
          <xsl:when test="contains($profile,'factur-x') or contains($profile,'Factur-X') or contains($profile,'facturx')">Factur-X · Francia</xsl:when>
          <xsl:otherwise>CII UN/CEFACT</xsl:otherwise>
        </xsl:choose>
      </span>
    </div>
    <div>
      <div class="docnum">N. <xsl:value-of select="$exdoc/ram:ID|$exdoc/ID"/></div>
      <div class="docmeta">
        <xsl:choose>
          <xsl:when test="string-length($rawDate) >= 8">
            <xsl:value-of select="substring($rawDate,1,4)"/>-<xsl:value-of select="substring($rawDate,5,2)"/>-<xsl:value-of select="substring($rawDate,7,2)"/>
          </xsl:when>
          <xsl:otherwise><xsl:value-of select="$rawDate"/></xsl:otherwise>
        </xsl:choose>
      </div>
    </div>
  </div>

  <div class="parties">
    <div class="party">
      <div class="plabel">Venditore (Seller)</div>
      <div class="pname"><xsl:value-of select="$seller/ram:Name|$seller/Name"/></div>
      <xsl:if test="$seller//ram:ID|$seller//ID">
        <div class="pvat">ID: <xsl:value-of select="$seller//ram:ID|$seller//ID"/></div>
      </xsl:if>
      <xsl:if test="$seller//ram:SpecifiedTaxRegistration/ram:ID|$seller//SpecifiedTaxRegistration/ID">
        <div class="pvat">VAT: <xsl:value-of select="$seller//ram:SpecifiedTaxRegistration/ram:ID|$seller//SpecifiedTaxRegistration/ID"/></div>
      </xsl:if>
      <xsl:if test="$seller//ram:PostcodeCode|$seller//PostcodeCode">
        <div class="paddr"><xsl:value-of select="$seller//ram:LineOne|$seller//LineOne"/> — <xsl:value-of select="$seller//ram:PostcodeCode|$seller//PostcodeCode"/> <xsl:value-of select="$seller//ram:CityName|$seller//CityName"/>, <xsl:value-of select="$seller//ram:CountryID|$seller//CountryID"/></div>
      </xsl:if>
    </div>
    <div class="party">
      <div class="plabel">Acquirente (Buyer)</div>
      <div class="pname"><xsl:value-of select="$buyer/ram:Name|$buyer/Name"/></div>
      <xsl:if test="$buyer//ram:ID|$buyer//ID">
        <div class="pvat">ID: <xsl:value-of select="$buyer//ram:ID|$buyer//ID"/></div>
      </xsl:if>
      <xsl:if test="$buyer//ram:SpecifiedTaxRegistration/ram:ID|$buyer//SpecifiedTaxRegistration/ID">
        <div class="pvat">VAT: <xsl:value-of select="$buyer//ram:SpecifiedTaxRegistration/ram:ID|$buyer//SpecifiedTaxRegistration/ID"/></div>
      </xsl:if>
    </div>
  </div>

  <xsl:if test="$supply//ram:IncludedSupplyChainTradeLineItem|$supply//IncludedSupplyChainTradeLineItem">
    <div class="stitle">Righe fattura (Line items)</div>
    <table>
      <thead>
        <tr>
          <th>#</th><th>Descrizione</th><th class="r">Qtà</th><th class="r">Prezzo unit.</th><th class="r">IVA %</th><th class="r">Totale <xsl:value-of select="$cur"/></th>
        </tr>
      </thead>
      <tbody>
        <xsl:for-each select="$supply//ram:IncludedSupplyChainTradeLineItem|$supply//IncludedSupplyChainTradeLineItem">
          <tr>
            <td><xsl:value-of select=".//ram:AssociatedDocumentLineDocument/ram:LineID|.//AssociatedDocumentLineDocument/LineID"/></td>
            <td class="desc"><xsl:value-of select=".//ram:SpecifiedTradeProduct/ram:Name|.//SpecifiedTradeProduct/Name"/></td>
            <td class="r">
              <xsl:value-of select=".//ram:BilledQuantity|.//BilledQuantity"/>
              <xsl:if test=".//ram:BilledQuantity/@unitCode">&#160;<xsl:value-of select=".//ram:BilledQuantity/@unitCode"/></xsl:if>
            </td>
            <td class="r"><xsl:value-of select=".//ram:NetPriceProductTradePrice/ram:ChargeAmount|.//NetPriceProductTradePrice/ChargeAmount"/></td>
            <td class="r"><xsl:value-of select=".//ram:SpecifiedLineTradeSettlement//ram:ApplicableTradeTax/ram:RateApplicablePercent|.//SpecifiedLineTradeSettlement//ApplicableTradeTax/RateApplicablePercent"/>%</td>
            <td class="r"><xsl:value-of select=".//ram:SpecifiedLineTradeSettlement//ram:SpecifiedTradeSettlementLineMonetarySummation/ram:LineTotalAmount|.//SpecifiedLineTradeSettlement//SpecifiedTradeSettlementLineMonetarySummation/LineTotalAmount"/></td>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:if>

  <xsl:if test="$sett//ram:ApplicableTradeTax|$sett//ApplicableTradeTax">
    <div class="stitle">Riepilogo IVA</div>
    <table>
      <thead>
        <tr><th>Tipo / Aliquota</th><th class="r">Base imponibile</th><th class="r">IVA</th></tr>
      </thead>
      <tbody>
        <xsl:for-each select="$sett//ram:ApplicableTradeTax|$sett//ApplicableTradeTax">
          <tr>
            <td><xsl:value-of select="ram:TypeCode|TypeCode"/>&#160;<xsl:value-of select="ram:RateApplicablePercent|RateApplicablePercent"/>%</td>
            <td class="r"><xsl:value-of select="ram:BasisAmount|BasisAmount"/></td>
            <td class="r"><xsl:value-of select="ram:CalculatedAmount|CalculatedAmount"/></td>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:if>

  <xsl:variable name="summary" select="$sett//ram:SpecifiedTradeSettlementHeaderMonetarySummation|$sett//SpecifiedTradeSettlementHeaderMonetarySummation"/>
  <div class="totals">
    <xsl:if test="$summary/ram:LineTotalAmount|$summary/LineTotalAmount">
      <div class="trow"><span class="lbl">Totale righe</span><span class="val"><xsl:value-of select="$summary/ram:LineTotalAmount|$summary/LineTotalAmount"/>&#160;<xsl:value-of select="$cur"/></span></div>
    </xsl:if>
    <xsl:if test="$summary/ram:TaxTotalAmount|$summary/TaxTotalAmount">
      <div class="trow"><span class="lbl">IVA</span><span class="val"><xsl:value-of select="$summary/ram:TaxTotalAmount|$summary/TaxTotalAmount"/>&#160;<xsl:value-of select="$cur"/></span></div>
    </xsl:if>
    <div class="trow grand">
      <span class="lbl">Totale documento</span>
      <span class="val"><xsl:value-of select="$summary/ram:GrandTotalAmount|$summary/GrandTotalAmount"/>&#160;<xsl:value-of select="$cur"/></span>
    </div>
    <xsl:if test="$summary/ram:DuePayableAmount|$summary/DuePayableAmount">
      <div class="trow"><span class="lbl">Da pagare</span><span class="val"><xsl:value-of select="$summary/ram:DuePayableAmount|$summary/DuePayableAmount"/>&#160;<xsl:value-of select="$cur"/></span></div>
    </xsl:if>
  </div>

  <xsl:if test="$exdoc/ram:IncludedNote//ram:Content|$exdoc/IncludedNote//Content">
    <div class="notes"><strong>Note:</strong> <xsl:value-of select="$exdoc/ram:IncludedNote//ram:Content|$exdoc/IncludedNote//Content"/></div>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
