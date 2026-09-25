<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:k="http://crd.gov.pl/wzor/2023/06/29/12648/">

<xsl:output method="html" encoding="UTF-8" indent="yes" doctype-public="-//W3C//DTD HTML 4.01//EN"/>

<xsl:template match="/">
  <html lang="it">
  <head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>KSeF — <xsl:value-of select="//k:P_2|//P_2"/> — <xsl:value-of select="//k:Podmiot1//k:Nazwa|//k:Podmiot1//k:NazwaPelna"/></title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,600&amp;family=IBM+Plex+Mono:wght@400;600&amp;family=Inter:wght@400;500;600;700&amp;display=swap"/>
    <style>
*{box-sizing:border-box;margin:0;padding:0}
html{background:#f0f0f0}
body{font-family:'Inter',sans-serif;font-size:13px;color:#161616;padding:20px}
.inv{max-width:860px;margin:0 auto;background:#fff;padding:32px 36px;box-shadow:0 1px 6px rgba(0,0,0,.08)}
h1{font-family:'Fraunces',serif;font-size:26px;font-weight:600;margin-bottom:4px}
.badge{display:inline-block;font-family:'IBM Plex Mono',monospace;font-size:9px;font-weight:700;padding:2px 7px;border-radius:3px;text-transform:uppercase;letter-spacing:.05em;background:#fef3c7;color:#92400e;margin-bottom:14px}
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
.notes{margin-top:14px;padding:10px 12px;background:#f5f5f5;border-left:3px solid #ccc;font-size:11.5px;color:#666}
footer{margin-top:24px;padding-top:10px;border-top:1px solid #e0e0e0;font-size:9px;color:#aaa;text-align:center;font-family:'IBM Plex Mono',monospace}
@media print{html{background:#fff}body{padding:0}.inv{box-shadow:none}@page{margin:16mm;size:A4}}
    </style>
  </head>
  <body>
  <div class="inv">
    <xsl:apply-templates select="//k:Faktura"/>
    <footer>E-Invoicing Tracker · Resa visiva KSeF FA — il documento originale è il file XML</footer>
  </div>
  </body>
  </html>
</xsl:template>

<xsl:template match="k:Faktura">
  <xsl:variable name="fa"  select="k:Fa"/>
  <xsl:variable name="p1"  select="k:Podmiot1/k:DaneIdentyfikacyjne"/>
  <xsl:variable name="p2"  select="k:Podmiot2/k:DaneIdentyfikacyjne"/>
  <xsl:variable name="cur" select="$fa/k:KodWaluty"/>

  <div class="hd">
    <div>
      <h1>Faktura VAT</h1>
      <span class="badge">KSeF · Polonia</span>
    </div>
    <div>
      <div class="docnum">N. <xsl:value-of select="$fa/k:P_2"/></div>
      <div class="docmeta"><xsl:value-of select="$fa/k:P_1"/></div>
      <xsl:if test="k:Naglowek/k:NumerKSeF">
        <div class="docmeta">KSeF: <xsl:value-of select="k:Naglowek/k:NumerKSeF"/></div>
      </xsl:if>
    </div>
  </div>

  <div class="parties">
    <div class="party">
      <div class="plabel">Sprzedawca (Venditore)</div>
      <div class="pname">
        <xsl:value-of select="$p1/k:NazwaPelna"/>
        <xsl:if test="not($p1/k:NazwaPelna)"><xsl:value-of select="$p1/k:Nazwa"/></xsl:if>
      </div>
      <div class="pvat">NIP: <xsl:value-of select="$p1/k:NIP"/></div>
    </div>
    <div class="party">
      <div class="plabel">Nabywca (Acquirente)</div>
      <div class="pname">
        <xsl:value-of select="$p2/k:NazwaPelna"/>
        <xsl:if test="not($p2/k:NazwaPelna)"><xsl:value-of select="$p2/k:Nazwa"/></xsl:if>
      </div>
      <div class="pvat">NIP: <xsl:value-of select="$p2/k:NIP"/></div>
    </div>
  </div>

  <xsl:if test="$fa/k:FaWiersz">
    <div class="stitle">Pozycje faktury (Righe fattura)</div>
    <table>
      <thead>
        <tr>
          <th>#</th>
          <th>Nazwa towaru / usługi</th>
          <th class="r">Ilość</th>
          <th class="r">Cena jedn. netto</th>
          <th class="r">VAT %</th>
          <th class="r">Wartość netto <xsl:value-of select="$cur"/></th>
        </tr>
      </thead>
      <tbody>
        <xsl:for-each select="$fa/k:FaWiersz">
          <tr>
            <td><xsl:value-of select="k:NrWierszaFa"/></td>
            <td class="desc">
              <xsl:value-of select="k:NazwaTowaru"/>
              <xsl:if test="not(k:NazwaTowaru)"><xsl:value-of select="k:NazwaUslugi"/></xsl:if>
              <xsl:if test="not(k:NazwaTowaru) and not(k:NazwaUslugi)"><xsl:value-of select="k:P_7"/></xsl:if>
            </td>
            <td class="r">
              <xsl:value-of select="k:Ilosc"/>
              <xsl:if test="not(k:Ilosc)"><xsl:value-of select="k:P_8A"/><xsl:if test="not(k:P_8A)"><xsl:value-of select="k:P_8B"/></xsl:if></xsl:if>
              <xsl:if test="k:JednostkaOpisu|k:P_8C">&#160;<xsl:value-of select="k:JednostkaOpisu|k:P_8C"/></xsl:if>
            </td>
            <td class="r">
              <xsl:value-of select="k:CenaJedNetto"/>
              <xsl:if test="not(k:CenaJedNetto)"><xsl:value-of select="k:P_9A"/></xsl:if>
            </td>
            <td class="r">
              <xsl:value-of select="k:StawkaPodatku"/>
              <xsl:if test="not(k:StawkaPodatku)"><xsl:value-of select="k:P_12"/></xsl:if>%
            </td>
            <td class="r">
              <xsl:value-of select="k:WartoscNetto"/>
              <xsl:if test="not(k:WartoscNetto)"><xsl:value-of select="k:P_11"/></xsl:if>
            </td>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:if>

  <!-- VAT summary — FA(3) PodatekNalezny or FA(2) P_13_x/P_14_x -->
  <xsl:if test="$fa/k:PodatekNalezny or $fa/k:P_13_1 or $fa/k:P_13_2 or $fa/k:P_13_3">
    <div class="stitle">Podsumowanie VAT (Riepilogo IVA)</div>
    <table>
      <thead>
        <tr><th>Stawka VAT</th><th class="r">Podstawa</th><th class="r">Kwota VAT</th></tr>
      </thead>
      <tbody>
        <xsl:for-each select="$fa/k:PodatekNalezny">
          <tr>
            <td><xsl:value-of select="k:StawkaPodatku"/>%</td>
            <td class="r"><xsl:value-of select="k:PodstawaOpodatkowania"/></td>
            <td class="r"><xsl:value-of select="k:KwotaPodatku"/></td>
          </tr>
        </xsl:for-each>
        <xsl:if test="$fa/k:P_13_1"><tr><td>23%</td><td class="r"><xsl:value-of select="$fa/k:P_13_1"/></td><td class="r"><xsl:value-of select="$fa/k:P_14_1"/></td></tr></xsl:if>
        <xsl:if test="$fa/k:P_13_2"><tr><td>8%</td><td class="r"><xsl:value-of select="$fa/k:P_13_2"/></td><td class="r"><xsl:value-of select="$fa/k:P_14_2"/></td></tr></xsl:if>
        <xsl:if test="$fa/k:P_13_3"><tr><td>5%</td><td class="r"><xsl:value-of select="$fa/k:P_13_3"/></td><td class="r"><xsl:value-of select="$fa/k:P_14_3"/></td></tr></xsl:if>
        <xsl:if test="$fa/k:P_13_4"><tr><td>0%</td><td class="r"><xsl:value-of select="$fa/k:P_13_4"/></td><td class="r">0,00</td></tr></xsl:if>
      </tbody>
    </table>
  </xsl:if>

  <div class="totals">
    <xsl:if test="$fa/k:P_13_1 or $fa/k:P_13_2">
      <div class="trow"><span class="lbl">Imponibile (netto)</span><span class="val"><xsl:value-of select="$fa/k:P_13_1 + $fa/k:P_13_2 + $fa/k:P_13_3"/>&#160;<xsl:value-of select="$cur"/></span></div>
    </xsl:if>
    <div class="trow grand">
      <span class="lbl">Kwota do zapłaty (Totale)</span>
      <span class="val"><xsl:value-of select="$fa/k:P_15"/>&#160;<xsl:value-of select="$cur"/></span>
    </div>
  </div>

  <xsl:if test="$fa/k:StopkaFaktury">
    <div class="notes"><strong>Note:</strong> <xsl:value-of select="$fa/k:StopkaFaktury"/></div>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
