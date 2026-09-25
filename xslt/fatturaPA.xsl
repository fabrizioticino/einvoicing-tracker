<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:p="http://ivaservizi.agenziaentrate.gov.it/docs/xsd/fatture/v1.2">

<xsl:output method="html" encoding="UTF-8" indent="yes" doctype-public="-//W3C//DTD HTML 4.01//EN"/>

<xsl:template match="/">
  <html lang="it">
  <head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>FatturaPA — <xsl:value-of select="//Numero"/> — <xsl:value-of select="//CedentePrestatore//Denominazione"/></title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,600&amp;family=IBM+Plex+Mono:wght@400;600&amp;family=Inter:wght@400;500;600;700&amp;display=swap"/>
    <style>
*{box-sizing:border-box;margin:0;padding:0}
html{background:#f0f0f0}
body{font-family:'Inter',sans-serif;font-size:13px;color:#161616;padding:20px}
.inv{max-width:860px;margin:0 auto;background:#fff;padding:32px 36px;box-shadow:0 1px 6px rgba(0,0,0,.08)}
h1{font-family:'Fraunces',serif;font-size:26px;font-weight:600;margin-bottom:4px}
.badge{display:inline-block;font-family:'IBM Plex Mono',monospace;font-size:9px;font-weight:700;padding:2px 7px;border-radius:3px;text-transform:uppercase;letter-spacing:.05em;background:#d1fae5;color:#065f46;margin-bottom:14px}
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
.notes{margin-top:14px;padding:10px 12px;background:#f5f5f5;border-left:3px solid #ccc;font-size:11.5px;color:#666;border-radius:0 4px 4px 0}
.pagamento{margin-top:12px;font-size:11.5px;color:#666}
.pagamento strong{color:#161616}
footer{margin-top:24px;padding-top:10px;border-top:1px solid #e0e0e0;font-size:9px;color:#aaa;text-align:center;font-family:'IBM Plex Mono',monospace}
@media print{html{background:#fff}body{padding:0}.inv{box-shadow:none}@page{margin:16mm;size:A4}}
    </style>
  </head>
  <body>
  <div class="inv">
    <xsl:apply-templates select="//p:FatturaElettronica|//FatturaElettronica"/>
    <footer>E-Invoicing Tracker · Resa visiva FatturaPA — il documento originale è il file XML</footer>
  </div>
  </body>
  </html>
</xsl:template>

<xsl:template match="p:FatturaElettronica|FatturaElettronica">
  <xsl:variable name="dgd" select=".//DatiGeneraliDocumento"/>
  <xsl:variable name="cp"  select=".//CedentePrestatore"/>
  <xsl:variable name="cc"  select=".//CessionarioCommittente"/>

  <div class="hd">
    <div>
      <h1>
        <xsl:choose>
          <xsl:when test="$dgd/TipoDocumento='TD01'">Fattura</xsl:when>
          <xsl:when test="$dgd/TipoDocumento='TD04'">Nota di credito</xsl:when>
          <xsl:when test="$dgd/TipoDocumento='TD05'">Nota di debito</xsl:when>
          <xsl:when test="$dgd/TipoDocumento='TD06'">Parcella</xsl:when>
          <xsl:when test="$dgd/TipoDocumento='TD16'">Fattura (integrazione RC)</xsl:when>
          <xsl:when test="$dgd/TipoDocumento='TD17'">Autofattura</xsl:when>
          <xsl:when test="$dgd/TipoDocumento='TD24'">Fattura differita</xsl:when>
          <xsl:otherwise>Documento (<xsl:value-of select="$dgd/TipoDocumento"/>)</xsl:otherwise>
        </xsl:choose>
      </h1>
      <span class="badge">FatturaPA · Italia</span>
    </div>
    <div>
      <div class="docnum">N. <xsl:value-of select="$dgd/Numero"/></div>
      <div class="docmeta"><xsl:value-of select="$dgd/Data"/></div>
      <div class="docmeta">Prog. <xsl:value-of select=".//ProgressivoInvio"/> · SDI <xsl:value-of select=".//CodiceDestinatario"/></div>
    </div>
  </div>

  <div class="parties">
    <div class="party">
      <div class="plabel">Cedente / Prestatore</div>
      <div class="pname">
        <xsl:value-of select="$cp//Denominazione"/>
        <xsl:if test="not($cp//Denominazione)">
          <xsl:value-of select="$cp//Nome"/>&#160;<xsl:value-of select="$cp//Cognome"/>
        </xsl:if>
      </div>
      <div class="pvat">P.IVA: <xsl:value-of select="$cp//IdFiscaleIVA/IdCodice"/><xsl:if test="$cp//CodiceFiscale"> · CF: <xsl:value-of select="$cp//CodiceFiscale"/></xsl:if></div>
      <div class="paddr"><xsl:value-of select="$cp//Sede/Indirizzo"/><xsl:if test="$cp//Sede/NumeroCivico">, <xsl:value-of select="$cp//Sede/NumeroCivico"/></xsl:if> — <xsl:value-of select="$cp//Sede/CAP"/> <xsl:value-of select="$cp//Sede/Comune"/> (<xsl:value-of select="$cp//Sede/Provincia"/>)</div>
    </div>
    <div class="party">
      <div class="plabel">Cessionario / Committente</div>
      <div class="pname">
        <xsl:value-of select="$cc//Denominazione"/>
        <xsl:if test="not($cc//Denominazione)">
          <xsl:value-of select="$cc//Nome"/>&#160;<xsl:value-of select="$cc//Cognome"/>
        </xsl:if>
      </div>
      <div class="pvat">P.IVA: <xsl:value-of select="$cc//IdFiscaleIVA/IdCodice"/><xsl:if test="$cc//CodiceFiscale"> · CF: <xsl:value-of select="$cc//CodiceFiscale"/></xsl:if></div>
      <div class="paddr"><xsl:value-of select="$cc//Sede/Indirizzo"/><xsl:if test="$cc//Sede/NumeroCivico">, <xsl:value-of select="$cc//Sede/NumeroCivico"/></xsl:if> — <xsl:value-of select="$cc//Sede/CAP"/> <xsl:value-of select="$cc//Sede/Comune"/></div>
    </div>
  </div>

  <xsl:if test=".//DettaglioLinee">
    <div class="stitle">Righe fattura</div>
    <table>
      <thead>
        <tr>
          <th>#</th><th>Descrizione</th><th class="r">Qtà</th><th class="r">Prezzo unit.</th><th class="r">IVA %</th><th class="r">Totale <xsl:value-of select="$dgd/Divisa"/></th>
        </tr>
      </thead>
      <tbody>
        <xsl:for-each select=".//DettaglioLinee">
          <tr>
            <td><xsl:value-of select="NumeroLinea"/></td>
            <td class="desc"><xsl:value-of select="Descrizione"/></td>
            <td class="r"><xsl:value-of select="Quantita"/><xsl:if test="UnitaMisura">&#160;<xsl:value-of select="UnitaMisura"/></xsl:if></td>
            <td class="r"><xsl:value-of select="PrezzoUnitario"/></td>
            <td class="r"><xsl:value-of select="AliquotaIVA"/>%<xsl:if test="Natura"> (<xsl:value-of select="Natura"/>)</xsl:if></td>
            <td class="r"><xsl:value-of select="PrezzoTotale"/></td>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:if>

  <xsl:if test=".//DatiRiepilogo">
    <div class="stitle">Riepilogo IVA</div>
    <table>
      <thead>
        <tr><th>Aliquota</th><th class="r">Imponibile</th><th class="r">Imposta</th><th>Rif. normativo</th></tr>
      </thead>
      <tbody>
        <xsl:for-each select=".//DatiRiepilogo">
          <tr>
            <td><xsl:value-of select="AliquotaIVA"/>%<xsl:if test="Natura"> — <xsl:value-of select="Natura"/></xsl:if></td>
            <td class="r"><xsl:value-of select="ImponibileImporto"/></td>
            <td class="r"><xsl:value-of select="Imposta"/></td>
            <td style="font-size:10px;color:#888"><xsl:value-of select="RiferimentoNormativo"/></td>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:if>

  <div class="totals">
    <xsl:if test="$dgd/ImportoTotaleDocumento">
      <div class="trow grand">
        <span class="lbl">Totale documento</span>
        <span class="val"><xsl:value-of select="$dgd/ImportoTotaleDocumento"/>&#160;<xsl:value-of select="$dgd/Divisa"/></span>
      </div>
    </xsl:if>
  </div>

  <xsl:if test=".//DettaglioPagamento">
    <div class="pagamento">
      <strong>Pagamento:</strong>
      <xsl:for-each select=".//DettaglioPagamento">
        &#160;<xsl:value-of select="ModalitaPagamento"/>
        <xsl:if test="ImportoPagamento"> · <xsl:value-of select="ImportoPagamento"/></xsl:if>
        <xsl:if test="DataScadenzaPagamento"> · scad. <xsl:value-of select="DataScadenzaPagamento"/></xsl:if>
        <xsl:if test="IBAN"> · IBAN: <xsl:value-of select="IBAN"/></xsl:if>
      </xsl:for-each>
    </div>
  </xsl:if>

  <xsl:if test=".//Causale">
    <div class="notes"><strong>Note:</strong> <xsl:for-each select=".//Causale"><xsl:value-of select="."/>&#160;</xsl:for-each></div>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
