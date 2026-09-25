<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:inv="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
  xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
  xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2">

<xsl:output method="html" encoding="UTF-8" indent="yes" doctype-public="-//W3C//DTD HTML 4.01//EN"/>

<!-- Country label from CustomizationID / country code -->
<xsl:template name="countryLabel">
  <xsl:variable name="cid" select="//cbc:CustomizationID"/>
  <xsl:variable name="cc"  select="//cbc:IdentificationCode[1]"/>
  <xsl:choose>
    <xsl:when test="contains($cid,'ro.ro')  or $cc='RO'">Romania</xsl:when>
    <xsl:when test="contains($cid,'be')     or $cc='BE'">Belgio</xsl:when>
    <xsl:when test="contains($cid,'no')     or $cc='NO'">Norvegia</xsl:when>
    <xsl:when test="contains($cid,'sk')     or $cc='SK'">Slovacchia</xsl:when>
    <xsl:when test="contains($cid,'hr')     or $cc='HR'">Croazia</xsl:when>
    <xsl:when test="contains($cid,'de')     or $cc='DE'">Germania</xsl:when>
    <xsl:when test="contains($cid,'dk')     or $cc='DK'">Danimarca</xsl:when>
    <xsl:when test="contains($cid,'fi')     or $cc='FI'">Finlandia</xsl:when>
    <xsl:when test="contains($cid,'ie')     or $cc='IE'">Irlanda</xsl:when>
    <xsl:when test="contains($cid,'lu')     or $cc='LU'">Lussemburgo</xsl:when>
    <xsl:when test="contains($cid,'nl')     or $cc='NL'">Paesi Bassi</xsl:when>
    <xsl:when test="contains($cid,'se')     or $cc='SE'">Svezia</xsl:when>
    <xsl:when test="contains($cid,'at')     or $cc='AT'">Austria</xsl:when>
    <xsl:when test="contains($cid,'pt')     or $cc='PT'">Portogallo</xsl:when>
    <xsl:when test="contains($cid,'uk')     or $cc='GB'">Regno Unito</xsl:when>
    <xsl:when test="contains($cid,'au')     or $cc='AU'">Australia</xsl:when>
    <xsl:when test="contains($cid,'nz')     or $cc='NZ'">Nuova Zelanda</xsl:when>
    <xsl:when test="contains($cid,'sg')     or $cc='SG'">Singapore</xsl:when>
    <xsl:when test="contains($cid,'my')     or $cc='MY'">Malaysia</xsl:when>
    <xsl:when test="contains($cid,'ae')     or $cc='AE'">Emirati Arabi</xsl:when>
    <xsl:when test="contains($cid,'sa')     or $cc='SA'">Arabia Saudita</xsl:when>
    <xsl:when test="contains($cid,'om')     or $cc='OM'">Oman</xsl:when>
    <xsl:when test="contains($cid,'co')     or $cc='CO'">Colombia</xsl:when>
    <xsl:when test="contains($cid,'si')     or $cc='SI'">Slovenia</xsl:when>
    <xsl:otherwise>Peppol BIS</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="/">
  <xsl:variable name="inv" select="//inv:Invoice|//Invoice"/>
  <html lang="it">
  <head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>UBL Invoice — <xsl:value-of select="$inv/cbc:ID"/> — <xsl:value-of select="$inv//cac:AccountingSupplierParty//cbc:Name[1]"/></title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,600&amp;family=IBM+Plex+Mono:wght@400;600&amp;family=Inter:wght@400;500;600;700&amp;display=swap"/>
    <style>
*{box-sizing:border-box;margin:0;padding:0}
html{background:#f0f0f0}
body{font-family:'Inter',sans-serif;font-size:13px;color:#161616;padding:20px}
.inv{max-width:860px;margin:0 auto;background:#fff;padding:32px 36px;box-shadow:0 1px 6px rgba(0,0,0,.08)}
h1{font-family:'Fraunces',serif;font-size:26px;font-weight:600;margin-bottom:4px}
.badge{display:inline-block;font-family:'IBM Plex Mono',monospace;font-size:9px;font-weight:700;padding:2px 7px;border-radius:3px;text-transform:uppercase;letter-spacing:.05em;background:#dbeafe;color:#1e40af;margin-bottom:14px}
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
    <xsl:apply-templates select="//inv:Invoice|//Invoice"/>
    <footer>E-Invoicing Tracker · Resa visiva UBL Invoice — il documento originale è il file XML</footer>
  </div>
  </body>
  </html>
</xsl:template>

<xsl:template match="inv:Invoice|Invoice">
  <xsl:variable name="cur" select="cbc:DocumentCurrencyCode"/>
  <xsl:variable name="typeCode" select="cbc:InvoiceTypeCode"/>

  <div class="hd">
    <div>
      <h1>
        <xsl:choose>
          <xsl:when test="$typeCode='381'">Nota di credito</xsl:when>
          <xsl:when test="$typeCode='384'">Fattura rettificativa</xsl:when>
          <xsl:when test="$typeCode='389'">Autofattura</xsl:when>
          <xsl:otherwise>Fattura</xsl:otherwise>
        </xsl:choose>
      </h1>
      <span class="badge">UBL · <xsl:call-template name="countryLabel"/></span>
    </div>
    <div>
      <div class="docnum">N. <xsl:value-of select="cbc:ID"/></div>
      <div class="docmeta"><xsl:value-of select="cbc:IssueDate"/></div>
      <xsl:if test="cbc:BuyerReference">
        <div class="docmeta">Rif. acquirente: <xsl:value-of select="cbc:BuyerReference"/></div>
      </xsl:if>
      <xsl:if test="cac:ContractDocumentReference/cbc:ID">
        <div class="docmeta">Contratto: <xsl:value-of select="cac:ContractDocumentReference/cbc:ID"/></div>
      </xsl:if>
    </div>
  </div>

  <div class="parties">
    <div class="party">
      <div class="plabel">Fornitore</div>
      <div class="pname">
        <xsl:value-of select="cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name"/>
        <xsl:if test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name)">
          <xsl:value-of select="cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName"/>
        </xsl:if>
      </div>
      <xsl:if test="cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID">
        <div class="pvat">P.IVA: <xsl:value-of select="cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID"/></div>
      </xsl:if>
      <div class="paddr">
        <xsl:value-of select="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName"/>
        <xsl:if test="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName">, <xsl:value-of select="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName"/></xsl:if>
        <xsl:if test="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode"> (<xsl:value-of select="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode"/>)</xsl:if>
      </div>
    </div>
    <div class="party">
      <div class="plabel">Cliente</div>
      <div class="pname">
        <xsl:value-of select="cac:AccountingCustomerParty/cac:Party/cac:PartyName/cbc:Name"/>
        <xsl:if test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyName/cbc:Name)">
          <xsl:value-of select="cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName"/>
        </xsl:if>
      </div>
      <xsl:if test="cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID">
        <div class="pvat">P.IVA: <xsl:value-of select="cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID"/></div>
      </xsl:if>
      <div class="paddr">
        <xsl:value-of select="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName"/>
        <xsl:if test="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName">, <xsl:value-of select="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName"/></xsl:if>
        <xsl:if test="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode"> (<xsl:value-of select="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode"/>)</xsl:if>
      </div>
    </div>
  </div>

  <xsl:if test="cac:InvoiceLine">
    <div class="stitle">Righe fattura</div>
    <table>
      <thead>
        <tr>
          <th>#</th><th>Descrizione</th><th class="r">Qtà</th><th class="r">Prezzo unit.</th><th class="r">IVA %</th><th class="r">Totale <xsl:value-of select="$cur"/></th>
        </tr>
      </thead>
      <tbody>
        <xsl:for-each select="cac:InvoiceLine">
          <tr>
            <td><xsl:value-of select="cbc:ID"/></td>
            <td class="desc"><xsl:value-of select="cac:Item/cbc:Name"/><xsl:if test="not(cac:Item/cbc:Name)"><xsl:value-of select="cac:Item/cbc:Description"/></xsl:if></td>
            <td class="r"><xsl:value-of select="cbc:InvoicedQuantity"/>&#160;<xsl:value-of select="cbc:InvoicedQuantity/@unitCode"/></td>
            <td class="r"><xsl:value-of select="cac:Price/cbc:PriceAmount"/></td>
            <td class="r"><xsl:value-of select="cac:Item/cac:ClassifiedTaxCategory/cbc:Percent"/>%</td>
            <td class="r"><xsl:value-of select="cbc:LineExtensionAmount"/></td>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:if>

  <xsl:if test="cac:TaxTotal/cac:TaxSubtotal">
    <div class="stitle">Riepilogo IVA</div>
    <table>
      <thead>
        <tr><th>Aliquota</th><th class="r">Imponibile <xsl:value-of select="$cur"/></th><th class="r">Imposta <xsl:value-of select="$cur"/></th><th>Motivo esenzione</th></tr>
      </thead>
      <tbody>
        <xsl:for-each select="cac:TaxTotal/cac:TaxSubtotal">
          <tr>
            <td><xsl:value-of select="cac:TaxCategory/cbc:Percent"/>%<xsl:if test="cac:TaxCategory/cbc:TaxExemptionReasonCode"> — <xsl:value-of select="cac:TaxCategory/cbc:TaxExemptionReasonCode"/></xsl:if></td>
            <td class="r"><xsl:value-of select="cbc:TaxableAmount"/></td>
            <td class="r"><xsl:value-of select="cbc:TaxAmount"/></td>
            <td style="font-size:10px;color:#888"><xsl:value-of select="cac:TaxCategory/cbc:TaxExemptionReason"/></td>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:if>

  <div class="totals">
    <xsl:if test="cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount">
      <div class="trow"><span class="lbl">Imponibile</span><span class="val"><xsl:value-of select="cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount"/>&#160;<xsl:value-of select="$cur"/></span></div>
    </xsl:if>
    <xsl:if test="cac:TaxTotal/cbc:TaxAmount">
      <div class="trow"><span class="lbl">IVA</span><span class="val"><xsl:value-of select="cac:TaxTotal/cbc:TaxAmount"/>&#160;<xsl:value-of select="$cur"/></span></div>
    </xsl:if>
    <div class="trow grand">
      <span class="lbl">Totale</span>
      <span class="val"><xsl:value-of select="cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount"/>&#160;<xsl:value-of select="$cur"/></span>
    </div>
  </div>

  <xsl:if test="cbc:Note">
    <div class="notes"><strong>Note:</strong> <xsl:value-of select="cbc:Note"/></div>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
