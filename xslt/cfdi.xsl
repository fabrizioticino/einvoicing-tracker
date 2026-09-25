<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:cfdi="http://www.sat.gob.mx/cfd/4"
  xmlns:tfd="http://www.sat.gob.mx/TimbreFiscalDigital">

<xsl:output method="html" encoding="UTF-8" indent="yes" doctype-public="-//W3C//DTD HTML 4.01//EN"/>

<xsl:template match="/">
  <html lang="it">
  <head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>CFDI 4.0 — <xsl:value-of select="//cfdi:Comprobante/@Folio|//@Folio"/> — <xsl:value-of select="//cfdi:Emisor/@Nombre|//Emisor/@Nombre"/></title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,600&amp;family=IBM+Plex+Mono:wght@400;600&amp;family=Inter:wght@400;500;600;700&amp;display=swap"/>
    <style>
*{box-sizing:border-box;margin:0;padding:0}
html{background:#f0f0f0}
body{font-family:'Inter',sans-serif;font-size:13px;color:#161616;padding:20px}
.inv{max-width:860px;margin:0 auto;background:#fff;padding:32px 36px;box-shadow:0 1px 6px rgba(0,0,0,.08)}
h1{font-family:'Fraunces',serif;font-size:26px;font-weight:600;margin-bottom:4px}
.badge{display:inline-block;font-family:'IBM Plex Mono',monospace;font-size:9px;font-weight:700;padding:2px 7px;border-radius:3px;text-transform:uppercase;letter-spacing:.05em;background:#fce7f3;color:#831843;margin-bottom:14px}
.hd{display:flex;justify-content:space-between;align-items:flex-start;border-bottom:2px solid #161616;padding-bottom:16px;margin-bottom:20px;gap:20px}
.docnum{font-family:'IBM Plex Mono',monospace;font-size:15px;font-weight:600;text-align:right}
.docmeta{font-family:'IBM Plex Mono',monospace;font-size:10px;color:#666;text-align:right;margin-top:3px}
.parties{display:flex;gap:20px;background:#f5f5f5;padding:14px 16px;border-radius:5px;margin-bottom:20px}
.party{flex:1}
.plabel{font-size:9px;font-weight:700;text-transform:uppercase;letter-spacing:.08em;color:#888;font-family:'IBM Plex Mono',monospace;margin-bottom:3px}
.pname{font-weight:700;font-size:13.5px;margin-bottom:2px}
.pvat{font-family:'IBM Plex Mono',monospace;font-size:10.5px;color:#666;margin-top:2px}
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
.tfd{margin-top:16px;padding:10px 12px;background:#f5f5f5;font-family:'IBM Plex Mono',monospace;font-size:9px;color:#888;border-radius:4px;word-break:break-all}
.tfd strong{color:#444;display:block;margin-bottom:3px}
footer{margin-top:24px;padding-top:10px;border-top:1px solid #e0e0e0;font-size:9px;color:#aaa;text-align:center;font-family:'IBM Plex Mono',monospace}
@media print{html{background:#fff}body{padding:0}.inv{box-shadow:none}@page{margin:16mm;size:A4}}
    </style>
  </head>
  <body>
  <div class="inv">
    <xsl:apply-templates select="//cfdi:Comprobante|//Comprobante"/>
    <footer>E-Invoicing Tracker · Resa visiva CFDI 4.0 — el comprobante original es el archivo XML con sello SAT</footer>
  </div>
  </body>
  </html>
</xsl:template>

<xsl:template match="cfdi:Comprobante|Comprobante">
  <xsl:variable name="emisor"  select="cfdi:Emisor|Emisor"/>
  <xsl:variable name="receptor" select="cfdi:Receptor|Receptor"/>
  <xsl:variable name="concepto" select="cfdi:Conceptos/cfdi:Concepto|Conceptos/Concepto"/>
  <xsl:variable name="impTras" select="cfdi:Impuestos/cfdi:Traslados/cfdi:Traslado|Impuestos/Traslados/Traslado"/>
  <xsl:variable name="tfd" select=".//tfd:TimbreFiscalDigital"/>

  <xsl:variable name="tipoDoc" select="@TipoDeComprobante"/>

  <div class="hd">
    <div>
      <h1>
        <xsl:choose>
          <xsl:when test="$tipoDoc='I'">Comprobante de ingreso</xsl:when>
          <xsl:when test="$tipoDoc='E'">Nota de crédito (egreso)</xsl:when>
          <xsl:when test="$tipoDoc='T'">Traslado</xsl:when>
          <xsl:when test="$tipoDoc='N'">Nómina</xsl:when>
          <xsl:when test="$tipoDoc='P'">Pago</xsl:when>
          <xsl:otherwise>CFDI (<xsl:value-of select="$tipoDoc"/>)</xsl:otherwise>
        </xsl:choose>
      </h1>
      <span class="badge">CFDI 4.0 · Messico</span>
    </div>
    <div>
      <div class="docnum">
        <xsl:if test="@Serie">Serie <xsl:value-of select="@Serie"/>&#160;</xsl:if>
        Folio <xsl:value-of select="@Folio"/>
      </div>
      <div class="docmeta"><xsl:value-of select="substring(@Fecha,1,10)"/></div>
      <div class="docmeta">Moneda: <xsl:value-of select="@Moneda"/></div>
    </div>
  </div>

  <div class="parties">
    <div class="party">
      <div class="plabel">Emisor (Fornitore)</div>
      <div class="pname"><xsl:value-of select="$emisor/@Nombre"/></div>
      <div class="pvat">RFC: <xsl:value-of select="$emisor/@Rfc"/></div>
      <div class="pvat">Régimen: <xsl:value-of select="$emisor/@RegimenFiscal"/></div>
    </div>
    <div class="party">
      <div class="plabel">Receptor (Acquirente)</div>
      <div class="pname"><xsl:value-of select="$receptor/@Nombre"/></div>
      <div class="pvat">RFC: <xsl:value-of select="$receptor/@Rfc"/></div>
      <div class="pvat">Uso CFDI: <xsl:value-of select="$receptor/@UsoCFDI"/></div>
    </div>
  </div>

  <xsl:if test="$concepto">
    <div class="stitle">Conceptos (Righe fattura)</div>
    <table>
      <thead>
        <tr>
          <th>#</th><th>Descripción</th><th class="r">Cantidad</th><th class="r">Precio unit.</th><th class="r">Descuento</th><th class="r">Importe <xsl:value-of select="@Moneda"/></th>
        </tr>
      </thead>
      <tbody>
        <xsl:for-each select="$concepto">
          <tr>
            <td><xsl:value-of select="position()"/></td>
            <td class="desc">
              <xsl:value-of select="@Descripcion"/>
              <xsl:if test="@ClaveProdServ">
                <span style="font-family:'IBM Plex Mono',monospace;font-size:9px;color:#888;margin-left:6px"><xsl:value-of select="@ClaveProdServ"/></span>
              </xsl:if>
            </td>
            <td class="r"><xsl:value-of select="@Cantidad"/>&#160;<xsl:value-of select="@ClaveUnidad"/></td>
            <td class="r"><xsl:value-of select="@ValorUnitario"/></td>
            <td class="r"><xsl:if test="@Descuento"><xsl:value-of select="@Descuento"/></xsl:if></td>
            <td class="r"><xsl:value-of select="@Importe"/></td>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:if>

  <xsl:if test="$impTras">
    <div class="stitle">Impuestos — Traslados (IVA)</div>
    <table>
      <thead>
        <tr><th>Impuesto / Tasa</th><th class="r">Base</th><th class="r">Importe</th></tr>
      </thead>
      <tbody>
        <xsl:for-each select="$impTras">
          <tr>
            <td><xsl:value-of select="@Impuesto"/>&#160;<xsl:value-of select="format-number(@TasaOCuota * 100, '##0.##')"/>%</td>
            <td class="r"><xsl:value-of select="@Base"/></td>
            <td class="r"><xsl:value-of select="@Importe"/></td>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:if>

  <div class="totals">
    <xsl:if test="@SubTotal">
      <div class="trow"><span class="lbl">SubTotal</span><span class="val"><xsl:value-of select="@SubTotal"/>&#160;<xsl:value-of select="@Moneda"/></span></div>
    </xsl:if>
    <xsl:if test="@Descuento">
      <div class="trow"><span class="lbl">Descuento</span><span class="val">-<xsl:value-of select="@Descuento"/>&#160;<xsl:value-of select="@Moneda"/></span></div>
    </xsl:if>
    <xsl:if test="cfdi:Impuestos/@TotalImpuestosTrasladados|Impuestos/@TotalImpuestosTrasladados">
      <div class="trow"><span class="lbl">IVA</span><span class="val"><xsl:value-of select="cfdi:Impuestos/@TotalImpuestosTrasladados|Impuestos/@TotalImpuestosTrasladados"/>&#160;<xsl:value-of select="@Moneda"/></span></div>
    </xsl:if>
    <div class="trow grand">
      <span class="lbl">Total</span>
      <span class="val"><xsl:value-of select="@Total"/>&#160;<xsl:value-of select="@Moneda"/></span>
    </div>
  </div>

  <xsl:if test="$tfd">
    <div class="tfd">
      <strong>Timbre Fiscal Digital (UUID SAT)</strong>
      <xsl:value-of select="$tfd/@UUID"/>
      <xsl:if test="$tfd/@FechaTimbrado">
        <br/>Timbrado: <xsl:value-of select="substring($tfd/@FechaTimbrado,1,10)"/>
      </xsl:if>
      <xsl:if test="$tfd/@NoCertificadoSAT">
        &#160;· Cert. SAT: <xsl:value-of select="$tfd/@NoCertificadoSAT"/>
      </xsl:if>
    </div>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
