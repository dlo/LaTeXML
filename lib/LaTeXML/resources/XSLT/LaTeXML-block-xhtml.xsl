<?xml version="1.0" encoding="utf-8"?>
<!--
/=====================================================================\
|  LaTeXML-block-xhtml.xsl                                            |
|  Converting various block-level elements to xhtml                   |
|=====================================================================|
| Part of LaTeXML:                                                    |
|  Public domain software, produced as part of work done by the       |
|  United States Government & not subject to copyright in the US.     |
|=====================================================================|
| Bruce Miller <bruce.miller@nist.gov>                        #_#     |
| http://dlmf.nist.gov/LaTeXML/                              (o o)    |
\=========================================================ooo==U==ooo=/
-->
<xsl:stylesheet
    version     = "1.0"
    xmlns:xsl   = "http://www.w3.org/1999/XSL/Transform"
    xmlns:ltx   = "http://dlmf.nist.gov/LaTeXML"
    xmlns:func  = "http://exslt.org/functions"
    xmlns:f     = "http://dlmf.nist.gov/LaTeXML/functions"
    extension-element-prefixes="func f"
    exclude-result-prefixes = "ltx func f">

  <xsl:param name="SIMPLIFY_HTML"></xsl:param>

  <!-- ======================================================================
       Various Block-level elements:
       ltx:p, ltx:equation, ltx:equationgroup, ltx:quote, ltx:block,
       ltx:listing, ltx:itemize, ltx:enumerate, ltx:description
       ====================================================================== -->

  <!-- These shouldn't display -->
  <xsl:template match="ltx:tags/ltx:tag[@role]"/>

  <xsl:template match="ltx:tag">
    <xsl:param name="context"/>
    <xsl:element name="span" namespace="{$html_ns}">
      <xsl:variable name="innercontext" select="'inline'"/><!-- override -->
      <xsl:call-template name="add_attributes"/>
      <xsl:apply-templates select="." mode="begin">
        <xsl:with-param name="context" select="$innercontext"/>
      </xsl:apply-templates>
      <xsl:value-of select="@open"/>
      <xsl:apply-templates>
        <xsl:with-param name="context" select="$innercontext"/>
      </xsl:apply-templates>
      <xsl:value-of select="@close"/>
      <xsl:apply-templates select="." mode="end">
        <xsl:with-param name="context" select="$innercontext"/>
      </xsl:apply-templates>
    </xsl:element>
  </xsl:template>

  <!-- Most of these templates generate block-level elements but may appear
       in inline mode; they use f:blockelement so that they will generate
       a valid 'span' element instead.
       See the CONTEXT discussion in LaTeXML-common -->

  <xsl:preserve-space elements="ltx:p"/>
  <xsl:template match="ltx:p">
    <xsl:param name="context"/>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:element name="{f:blockelement($context,'p')}" namespace="{$html_ns}">
      <xsl:variable name="innercontext" select="'inline'"/><!-- override -->
      <xsl:call-template name="add_id"/>
      <xsl:call-template name="add_attributes"/>
      <xsl:apply-templates select="." mode="begin">
        <xsl:with-param name="context" select="$innercontext"/>
      </xsl:apply-templates>
      <xsl:apply-templates>
        <xsl:with-param name="context" select="$innercontext"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="." mode="end">
        <xsl:with-param name="context" select="$innercontext"/>
      </xsl:apply-templates>
    </xsl:element>
  </xsl:template>

  <xsl:strip-space elements="ltx:quote"/>

  <xsl:template match="ltx:quote">
    <xsl:param name="context"/>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:element name="{f:blockelement($context,'blockquote')}" namespace="{$html_ns}">
      <xsl:call-template name="add_id"/>
      <xsl:call-template name="add_attributes"/>
      <xsl:apply-templates select="." mode="begin">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:apply-templates>
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="." mode="end">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:text>&#x0A;</xsl:text>
    </xsl:element>
  </xsl:template>

  <xsl:strip-space elements="ltx:block"/>

  <xsl:template match="ltx:block">
    <xsl:param name="context"/>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:element name="{f:blockelement($context,'div')}" namespace="{$html_ns}">
      <xsl:call-template name="add_id"/>
      <xsl:call-template name="add_attributes"/>
      <xsl:apply-templates select="." mode="begin">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:apply-templates>
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="." mode="end">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:text>&#x0A;</xsl:text>
    </xsl:element>
  </xsl:template>

  <xsl:strip-space elements="ltx:listing"/>

  <xsl:template match="ltx:listing">
    <xsl:param name="context"/>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:element name="{f:blockelement($context,'div')}" namespace="{$html_ns}">
      <xsl:call-template name="add_id"/>
      <xsl:call-template name="add_attributes">
      </xsl:call-template>
      <xsl:apply-templates select="." mode="begin">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:apply-templates>
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="." mode="end">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:text>&#x0A;</xsl:text>
    </xsl:element>
  </xsl:template>

  <xsl:template match="ltx:listing" mode="classes">
    <xsl:param name="context"/>
    <xsl:apply-templates select="." mode="base-classes"/>
    <xsl:text> ltx_listing</xsl:text>
  </xsl:template>

  <xsl:template match="ltx:listing[@data]" mode="begin">
    <xsl:param name="context"/>
    <xsl:element name="{f:blockelement($context,'div')}" namespace="{$html_ns}">
      <xsl:attribute name="class">ltx_listing_data</xsl:attribute>
      <xsl:element name="a" namespace="{$html_ns}">
        <xsl:call-template name="add_data_attribute">
          <xsl:with-param name="name" select="'href'"/>
        </xsl:call-template>
        <xsl:if test="$USE_HTML5='true'">
          <xsl:attribute name="download"/>
        </xsl:if>
        <xsl:text>&#x2B07;</xsl:text>
      </xsl:element>
    </xsl:element>
  </xsl:template>


  <xsl:preserve-space elements="ltx:listingline"/>
  <xsl:template match="ltx:listingline">
    <xsl:param name="context"/>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:element name="{f:blockelement($context,'div')}" namespace="{$html_ns}">
      <xsl:call-template name="add_id"/>
      <xsl:call-template name="add_attributes"/>
      <xsl:apply-templates select="." mode="begin">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:apply-templates>
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="." mode="end">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:text>&#x0A;</xsl:text>
    </xsl:element>

  </xsl:template>
  <!-- ======================================================================
       Equation structures
       ====================================================================== -->

  <!-- Equation formatting parameters.
       [how should these be controlled? cmdline? processing-instructions?]

       The alignment capability blurs the line between the HTML structure & CSS.
       Some things are getting hardcoded that really should be in CSS.
  -->

  <!-- Should alignments like eqnarray, align, be respected, or more semantically presented?-->
  <xsl:param name="USE_ALIGNED_EQUATIONS" select="true()"/>

  <xsl:param name="classPI">
    <xsl:value-of select="//processing-instruction()[local-name()='latexml'][contains(.,'class')]"/>
  </xsl:param>
  <!-- Equation numbers on left, or default right? -->
  <xsl:template match="ltx:equation/ltx:tags/ltx:tag | ltx:equationgroup/ltx:tags/ltx:tag">
    <xsl:param name="context"/>
    <xsl:element name="span" namespace="{$html_ns}">
      <xsl:variable name="innercontext" select="'inline'"/>
      <xsl:attribute name="class">ltx_tag ltx_tag_<xsl:value-of select="local-name(../..)"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="f:if(ancestor-or-self::*[contains(@class,'ltx_leqno')],'ltx_align_left','ltx_align_right')"/></xsl:attribute>
      <xsl:apply-templates>
        <xsl:with-param name="context" select="$innercontext"/>
      </xsl:apply-templates>
    </xsl:element>
  </xsl:template>

  <!-- ======================================================================
       Basic templates, dispatching on aligned or unaligned forms-->

  <xsl:strip-space elements="ltx:equation ltx:equationgroup"/>

  <xsl:template match="ltx:equationgroup">
    <xsl:param name="context"/>
    <xsl:choose>
      <xsl:when test="$USE_ALIGNED_EQUATIONS">
        <xsl:apply-templates select="." mode="aligned">
          <xsl:with-param name="context" select="$context"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="unaligned">
          <xsl:with-param name="context" select="$context"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="ltx:equation">
    <xsl:param name="context"/>
    <xsl:choose>
      <xsl:when test="$USE_ALIGNED_EQUATIONS">
        <xsl:apply-templates select="." mode="aligned">
          <xsl:with-param name="context" select="$context"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="unaligned">
          <xsl:with-param name="context" select="$context"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ======================================================================
       Unaligned templates -->

  <xsl:template match="*" mode="unaligned-begin"/>

  <xsl:template match="*" mode="unaligned-end"/>

  <xsl:template match="ltx:equationgroup" mode="unaligned">
    <xsl:param name="context"/>
    <xsl:param name="eqnopos"
               select="f:if(ancestor-or-self::*[contains(@class,'ltx_leqno')],'left','right')"/>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:element name="{f:blockelement($context,'div')}" namespace="{$html_ns}">
      <xsl:call-template name="add_id"/>
      <xsl:call-template name="add_attributes">
        <xsl:with-param name="extra_classes" select="'ltx_eqn_div'"/>
      </xsl:call-template>
      <xsl:apply-templates select="." mode="begin">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="." mode="unaligned-begin">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:if test="ltx:tags and not(descendant::ltx:equation[ltx:tags]) and $eqnopos='left'">
        <xsl:apply-templates select="ltx:tags">
          <xsl:with-param name="context" select="$context"/>
        </xsl:apply-templates>
      </xsl:if>
      <xsl:apply-templates select="ltx:equationgroup | ltx:equation | ltx:p">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:if test="ltx:tags and not(descendant::ltx:equation[ltx:tags]) and $eqnopos='right'">
        <xsl:apply-templates select="ltx:tags">
          <xsl:with-param name="context" select="$context"/>
        </xsl:apply-templates>
      </xsl:if>
      <xsl:apply-templates select="." mode="constraints">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="." mode="unaligned-end">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="." mode="end">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:text>&#x0A;</xsl:text>
    </xsl:element>
  </xsl:template>

  <xsl:template match="ltx:equation" mode="unaligned">
    <xsl:param name="context"/>
    <xsl:param name="eqnopos"
               select="f:if(ancestor-or-self::*[contains(@class,'ltx_leqno')],'left','right')"/>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:element name="{f:blockelement($context,'div')}" namespace="{$html_ns}">
      <xsl:call-template name="add_id"/>
      <xsl:call-template name="add_attributes">
        <xsl:with-param name="extra_classes" select="'ltx_eqn_div'"/>
      </xsl:call-template>
      <xsl:apply-templates select="." mode="begin">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="." mode="unaligned-begin">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:if test="ltx:tags and $eqnopos='left'">
        <xsl:apply-templates select="ltx:tags">
          <xsl:with-param name="context" select="$context"/>
        </xsl:apply-templates>
      </xsl:if>
      <xsl:element name="span" namespace="{$html_ns}">
        <xsl:variable name="context" select="'inline'"/><!-- override -->
        <!-- This should cover: ltx:Math, ltx:MathFork, ltx:text & Misc
             (ie. all of equation_model EXCEPT Meta & EquationMeta) -->
        <xsl:apply-templates select="ltx:Math | ltx:MathFork | ltx:text
                                     | ltx:inline-block | ltx:verbatim | ltx:break
                                     | ltx:graphics | ltx:svg | ltx:rawhtml | ltx:inline-para
                                     | ltx:tabular | ltx:picture" >
          <xsl:with-param name="context" select="$context"/>
        </xsl:apply-templates>
      </xsl:element>
      <xsl:if test="ltx:tags and $eqnopos='right'">
        <xsl:apply-templates select="ltx:tags">
          <xsl:with-param name="context" select="$context"/>
        </xsl:apply-templates>
      </xsl:if>
      <xsl:apply-templates select="." mode="constraints">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="." mode="unaligned-end">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="." mode="end">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:text>&#x0A;</xsl:text>
      </xsl:element>
  </xsl:template>

  <xsl:template match="ltx:equationgroup|ltx:equation" mode="constraints">
    <xsl:param name="context"/>
    <xsl:apply-templates select="ltx:constraint[not(@hidden='true')]">
      <xsl:with-param name="context" select="$context"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- by default (not inside an aligned equationgroup) -->
  <xsl:template match="ltx:MathFork">
    <xsl:param name="context"/>
    <xsl:apply-templates select="ltx:Math[1]">
      <xsl:with-param name="context" select="$context"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- ======================================================================
       Aligned templates -->

  <!-- typical table arrangement for numbered equation w/constraint:
       (Note that number is vertically centered across the equation rows, but NOT the constraint)
       (Note that the equation rows will be wrapped in a tbody as attachment for the id)
       _______________________________
       |     | pad | lhs | =rhs | pad |
       | (1) |_____|_____|______|_____|
       |     | pad |     | =rhs | pad |
       |_____|_____|_____|______|_____|
       |                   constraint |
       |______ _______________________|

       typical arrangement for numbered equations in equationgroup
       (ignores the number (if any) on the equationgroup)
       (Note that each set of equation rows will be wrapped in a tbody as attachment for the id)
       _______________________________
       |     | pad | lhs | =rhs | pad |
       | (1) |_____|_____|______|_____|
       |     | pad |     | =rhs | pad |
       |_____|_____|_____|______|_____|
       |                   constraint |
       |_____ ________________________|
       |     | pad | lhs | =rhs | pad |
       | (2) |_____|_____|______|_____|
       |     | pad |     | =rhs | pad |
       |_____|_____|_____|______|_____|
       |                   constraint |
       |_____ ________________________|

       typical arrangement for unnumbered equations in numbered equationgroup
       (Note that the equation number is centered across all content, including any constraints)
       (Note that the rows of eqach equation cannot be wrapped in a tbody,
       since the equationnumber column must span all rows; it cannot span across tbody's!)
       _______________________________
       |     | pad | lhs | =rhs | pad |
       |     |_____|_____|______|_____|
       |     | pad |     | =rhs | pad |
       |     |_____|_____|______|_____|
       |     |             constraint |
       | (1) |________________________|
       |     | pad | lhs | =rhs | pad |
       |     |_____|_____|______|_____|
       |     | pad |     | =rhs | pad |
       |     |_____|_____|______|_____|
       |     |             constraint |
       |_____|________________________|

   The equation number is on the left if the document has class=ltx_leqno;
   Otherwise the equation number will be on the right (w/ obvious change to above diagrams).

   Also, there can be more than 2 columns (eg with AMS's align).
   Moreover, there can be columns missing, esp. with AMS align.
   So, the right padding column may use colspan to fill in the missing columns,
   so that any rightmost columns (eg the equation number) are still correctly positioned.

   In general, we will try to wrap each equation & equationgroup in a tbody.
   However, when an equationgroup is numbered, the column for the equation number
   spans several rows ($spanned) which cannot cros tbody boundaries. Thus we must
   omit the tbody wrapper in those cases.
   We will also try to put the ID for an equation or equationgroup on the outer table
   or the tightest tbody container within it. When the tbody is omitted, the ID will go on
   the first row for an equation or an empty row for an equationgroup.
  -->

  <func:function name="f:countcolumns">
    <xsl:param name="equation"/>
    <func:result>
      <xsl:value-of select="sum(ltx:MathFork/ltx:MathBranch[1]/ltx:tr[1]/ltx:td/@colspan)
                            + count(ltx:MathFork/ltx:MathBranch[1]/ltx:tr[1]/ltx:td[not(@colspan)])
                            + sum(ltx:MathFork/ltx:MathBranch[1]/ltx:td/@colspan)
                            + count(ltx:MathFork/ltx:MathBranch[1]/ltx:td[not(@colspan)])
                            + count(ltx:MathFork/ltx:MathBranch[1][not(ltx:tr or ltx:td)])
                            + count(ltx:Math)"/>
    </func:result>
  </func:function>

  <func:function name="f:maxcolumns">
    <xsl:param name="equations"/>
    <xsl:for-each select="$equations">
      <xsl:sort select="f:countcolumns(.)" data-type="number" order="descending"/>
      <xsl:if test="position()=1">
        <func:result><xsl:value-of select="f:countcolumns(.)"/></func:result>
      </xsl:if>
    </xsl:for-each>
  </func:function>

  <!-- These are the top-level templates for handling aligned equationgroups,
       with nested equations or possibly equationgroups.
       It establishes an outer table into which the contained equationgroups
       and equations are set. -->
  <xsl:template match="ltx:equationgroup" mode="aligned">
    <xsl:param name="context"/>
    <xsl:param name="ncolumns"
               select="f:maxcolumns(ltx:equation | ltx:equationgroup/ltx:equation)"/>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:element name="{f:blockelement($context,'table')}" namespace="{$html_ns}">
      <xsl:call-template name="add_id"/>
      <xsl:call-template name="add_attributes">
        <xsl:with-param name="extra_classes" select="'ltx_eqn_table'"/>
      </xsl:call-template>
      <xsl:text>&#x0A;</xsl:text>
      <xsl:apply-templates select="." mode="begin">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="." mode="aligned-begin">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="." mode="inalignment">
        <xsl:with-param name="ncolumns" select="$ncolumns"/>
        <xsl:with-param name="spanned" select="false()"/>
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="." mode="aligned-end">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="." mode="end">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:text>&#x0A;</xsl:text>
    </xsl:element>
  </xsl:template>

  <!-- Top-level aligned single equation establishes a table into which the equations
       rows are set. -->
  <xsl:template match="ltx:equation" mode="aligned">
    <xsl:param name="context"/>
    <xsl:param name="ncolumns" select="f:countcolumns(.)"/>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:element name="{f:blockelement($context,'table')}" namespace="{$html_ns}">
      <xsl:call-template name="add_id"/>
      <xsl:call-template name="add_attributes">
        <xsl:with-param name="extra_classes" select="'ltx_eqn_table'"/>
      </xsl:call-template>
      <xsl:apply-templates select="." mode="begin">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="." mode="aligned-begin">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:text>&#x0A;</xsl:text>
      <xsl:apply-templates select="." mode="inalignment">
        <xsl:with-param name="ncolumns" select="$ncolumns"/>
        <xsl:with-param name="spanned" select="false()"/>
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="." mode="aligned-end">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="." mode="end">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:text>&#x0A;</xsl:text>
    </xsl:element>
  </xsl:template>

  <xsl:template match="*" mode="aligned-begin"/>
  <xsl:template match="*" mode="aligned-end"/>

  <!-- ======================================================================
       Generate the padding column (td) for a (potentially) numbered row
       in an aligned equationgroup|equation.
       May contain refnum ltx:tag for eqation or containing equationgroup.
       And, may be omitted entirely, if not 1st row of a numbered equationgroup,
       since that column has a rowspan for the entire numbered sequence.
       Note that even though this will be a td within a tr generated by an equation,
       it MAY be displaying the refnum of a containing equationgroup!
       [this mangled nesting keeps us from being able to use tbody!]
  -->
  <xsl:template name="eqnumtd">
    <xsl:param name="context"/>
    <xsl:param name="side"/>                                   <!-- left or right -->
    <xsl:param name="eqnopos"
               select="f:if(ancestor-or-self::*[contains(@class,'ltx_leqno')],'left','right')"/>
    <xsl:choose>
      <!-- Wrong side: Nothing -->
      <xsl:when test="$eqnopos != $side"/>
      <!-- equationgroup is numbered, but no numbered contained equations or equationgroups! -->
      <xsl:when test="ancestor-or-self::ltx:equationgroup[position()=1][ltx:tags][not(descendant::ltx:equationgroup/ltx:tags | descendant::ltx:equation/ltx:tags)]">
        <!-- place number only for 1st row -->
        <xsl:if test="(ancestor-or-self::ltx:tr and not(preceding-sibling::ltx:tr))
                      or (not(ancestor-or-self::ltx:tr) and not(preceding-sibling::ltx:equation))">
          <!-- for the containing equationgroup, count the rows in MathFork'd equations,
               the MathFork'd equations w/ only implicit row, the equations that aren't MathFork'd,
               and any constraints within equations -->
          <xsl:variable name="nrows"
                        select="count(
                                ancestor-or-self::ltx:equationgroup[position()=1][ltx:tags]/descendant::ltx:equation/ltx:MathFork/ltx:MathBranch[1]/ltx:tr
                                | ancestor-or-self::ltx:equationgroup[position()=1][ltx:tags]/descendant::ltx:equation[ltx:MathFork/ltx:MathBranch[1]/ltx:td]
                                | ancestor-or-self::ltx:equationgroup[position()=1][ltx:tags]/descendant::ltx:equation[ltx:Math or ltx:MathFork/ltx:MathBranch[not(ltx:tr or ltx:td)]]
                                | ancestor-or-self::ltx:equationgroup[position()=1][ltx:tags]/descendant::ltx:equation/ltx:constraint
                                )"/>
          <xsl:text>&#x0A;</xsl:text>
          <xsl:element name="{f:blockelement($context,'td')}" namespace="{$html_ns}">
            <xsl:attribute name="rowspan"><xsl:value-of select="$nrows"/></xsl:attribute>
            <xsl:attribute name="class">
              <xsl:value-of select="concat('ltx_eqn_cell ltx_eqn_eqno ltx_align_middle ltx_align_',$side)"/>
            </xsl:attribute>
            <xsl:apply-templates
                select="ancestor-or-self::ltx:equationgroup[position()=1]/ltx:tags/ltx:tag[not(@role)]">
              <xsl:with-param name="context" select="$context"/>
            </xsl:apply-templates>
            </xsl:element>
        </xsl:if>                                              <!--Else NOTHING (rowspan'd!) -->
      </xsl:when>
      <!-- equation is numbered! (but not equationgroup, if any) -->
      <xsl:when test="ancestor-or-self::ltx:equation[position()=1][ltx:tags]">
        <!-- place number only for 1st row -->
        <xsl:if test="(ancestor-or-self::ltx:tr and not(preceding-sibling::ltx:tr))
                      or not(ancestor-or-self::ltx:tr)">
          <!-- Count the MathFork rows, the MathForks w/only implicit row,
               or if not MathFork'd at all; but NOT any constraints.-->
          <xsl:variable name="nrows"
                        select="count(
                                ancestor-or-self::ltx:equation[position()=1][ltx:tags]
                                /ltx:MathFork/ltx:MathBranch[1]/ltx:tr
                                | ancestor-or-self::ltx:equation[position()=1][ltx:tags]
                                [ltx:MathFork/ltx:MathBranch[1]/ltx:td]
                                | ancestor-or-self::ltx:equation[position()=1][ltx:tags]
                                [ltx:Math or ltx:MathFork/ltx:MathBranch[not(ltx:tr or ltx:td)]]
                                )"/>
          <xsl:text>&#x0A;</xsl:text>
          <xsl:element name="{f:blockelement($context,'td')}" namespace="{$html_ns}">
            <xsl:attribute name="rowspan"><xsl:value-of select="$nrows"/></xsl:attribute>
            <xsl:attribute name="class">
              <xsl:value-of select="concat('ltx_eqn_cell ltx_eqn_eqno ltx_align_middle ltx_align_',$side)"/>
            </xsl:attribute>
            <xsl:apply-templates select="ancestor-or-self::ltx:equation[position()=1]/ltx:tags/ltx:tag[not(@role)]">
              <xsl:with-param name="context" select="$context"/>
            </xsl:apply-templates>
          </xsl:element>
        </xsl:if>                                                      <!--Else NOTHING (rowspan'd!) -->
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- Handle the equation left side, possibly including equation number -->
  <xsl:template name="eq-left">
    <xsl:param name="context"/>
    <xsl:param name="eqpos"
               select="f:if(ancestor-or-self::*[contains(@class,'ltx_fleqn')],'left','center')"/>
    <xsl:call-template name="eqnumtd">                         <!--Place left number, if any -->
      <xsl:with-param name="context" select="$context"/>
      <xsl:with-param name='side' select="'left'"/>
    </xsl:call-template>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:element name="{f:blockelement($context,'td')}" namespace="{$html_ns}">
      <xsl:attribute name="class">
      <xsl:value-of select="concat('ltx_eqn_cell ltx_eqn_',$eqpos,'_padleft')"/></xsl:attribute>
    </xsl:element>
  </xsl:template>

  <!-- Handle the equation right side, possibly including equation number,
       and any extra padding "columns" needed to complete the row. -->
  <xsl:template name="eq-right">
    <xsl:param name="context"/>
    <xsl:param name="eqpos"
               select="f:if(ancestor-or-self::*[contains(@class,'ltx_fleqn')],'left','center')"/>
    <xsl:param name="extrapad" select="0"/>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:element name="{f:blockelement($context,'td')}" namespace="{$html_ns}">
      <xsl:attribute name="class">
      <xsl:value-of select="concat('ltx_eqn_cell ltx_eqn_',$eqpos,'_padright')"/></xsl:attribute>
      <xsl:if test="$extrapad > 0">
        <xsl:attribute name="colspan">
          <xsl:value-of select="$extrapad+1"/>
        </xsl:attribute>
      </xsl:if>
    </xsl:element>
    <xsl:call-template name="eqnumtd">
      <xsl:with-param name="context" select="$context"/>
      <xsl:with-param name='side' select="'right'"/>
    </xsl:call-template>
  </xsl:template>

  <!-- ======================================================================
       Synthesizing rows & columns out for aligned equations and equationgroups
  -->
  <xsl:template match="*" mode="inalignment-begin">
    <xsl:param name="context"/>
    <xsl:param name="ncolumns"/>
    <xsl:param name="spanned"/>
  </xsl:template>
  <xsl:template match="*" mode="inalignment-end">
    <xsl:param name="context"/>
    <xsl:param name="ncolumns"/>
    <xsl:param name="spanned"/>
  </xsl:template>

  <!-- for intertext type entries; these just span he content columns. -->
  <xsl:template match="ltx:p" mode="inalignment">
    <xsl:param name="context"/>
    <xsl:param name="ncolumns"/>
    <xsl:param name="spanned"/>
    <xsl:param name="eqpos"
               select="f:if(ancestor-or-self::*[contains(@class,'ltx_fleqn')],'left','center')"/>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:choose>
      <xsl:when test="$spanned">
        <xsl:apply-templates select="." mode="ininalignment">
          <xsl:with-param name="context" select="$context"/>
          <xsl:with-param name="ncolumns" select="$ncolumns"/>
          <xsl:with-param name="spanned" select="$spanned"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="{f:blockelement($context,'tbody')}" namespace="{$html_ns}">
          <xsl:apply-templates select="." mode="ininalignment">
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="ncolumns" select="$ncolumns"/>
            <xsl:with-param name="spanned" select="$spanned"/>
          </xsl:apply-templates>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="ltx:p" mode="ininalignment">
    <xsl:param name="context"/>
    <xsl:param name="ncolumns"/>
    <xsl:param name="spanned"/>
    <xsl:element name="{f:blockelement($context,'tr')}" namespace="{$html_ns}">
      <xsl:attribute name="class">ltx_eqn_row ltx_align_baseline</xsl:attribute>
      <xsl:element name="{f:blockelement($context,'td')}" namespace="{$html_ns}">
        <xsl:attribute name="class">ltx_eqn_cell ltx_align_left</xsl:attribute>
        <xsl:attribute name="style">white-space:normal;</xsl:attribute>
        <xsl:attribute name="colspan">
          <xsl:value-of select="3+$ncolumns"/>
        </xsl:attribute>
        <xsl:apply-templates select="." mode="begin">
          <xsl:with-param name="context" select="$context"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="." mode="inalignment-begin">
          <xsl:with-param name="ncolumns" select="$ncolumns"/>
          <xsl:with-param name="context" select="$context"/>
          <xsl:with-param name="spanned" select="$spanned"/>
        </xsl:apply-templates>
        <xsl:apply-templates>
          <xsl:with-param name="context" select="$context"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="." mode="inalignment-end">
          <xsl:with-param name="ncolumns" select="$ncolumns"/>
          <xsl:with-param name="context" select="$context"/>
          <xsl:with-param name="spanned" select="$spanned"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="." mode="end">
          <xsl:with-param name="context" select="$context"/>
        </xsl:apply-templates>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <!-- equationgroups, possibly nested, already within a table context.
       We'll wrap in a tbody (with ID), unless we're already spanned by an equation number. -->
  <xsl:template match="ltx:equationgroup" mode="inalignment">
    <xsl:param name="context"/>
    <xsl:param name="ncolumns"/>
    <xsl:param name="spanned"/> <!--If this group is (row)spanned by an equation number column. -->
    <xsl:choose>
      <!-- IF we can't wrap with tbody, or don't need to (have no id & all children will wrap)-->
      <xsl:when test="$spanned or (not(child::ltx:tags) and not(parent::ltx:equationgroup and @fragid))">
        <!-- but without tbody, if id hasn't been handled (by html:table), add dummy row -->
        <xsl:if test="@fragid and parent::ltx:equationgroup">
          <xsl:element name="{f:blockelement($context,'tr')}" namespace="{$html_ns}">
          <xsl:call-template name="add_id"/>
          <xsl:attribute name="class">ltx_eqn_row</xsl:attribute>
            <xsl:element name="{f:blockelement($context,'td')}" namespace="{$html_ns}"> <!--Empty, too
-->
              <xsl:attribute name="class">ltx_eqn_cell</xsl:attribute>
              <xsl:attribute name="colspan"><xsl:value-of select="$ncolumns+3"/></xsl:attribute>
            </xsl:element>
          </xsl:element>
        </xsl:if>
        <xsl:apply-templates select="." mode="ininalignment">
          <xsl:with-param name="ncolumns" select="$ncolumns"/>
          <xsl:with-param name="context" select="$context"/>
          <xsl:with-param name="spanned" select="$spanned"/>
        </xsl:apply-templates>
      </xsl:when>
      <!-- otherwise, wrap equationgroup in a tbody -->
      <xsl:otherwise>
        <xsl:element name="{f:blockelement($context,'tbody')}" namespace="{$html_ns}">
          <!-- If id hasn't been handled (by html:table), put it on tbody -->
          <xsl:if test="@fragid and parent::ltx:equationgroup">
            <xsl:call-template name="add_id"/>
          </xsl:if>
          <xsl:apply-templates select="." mode="ininalignment">
            <xsl:with-param name="ncolumns" select="$ncolumns"/>
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="spanned" select="child::ltx:tags"/>
          </xsl:apply-templates>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- innermost equationgroup; simply handle the content equations/equationgroups -->
  <xsl:template match="ltx:equationgroup" mode="ininalignment">
    <xsl:param name="context"/>
    <xsl:param name="ncolumns"/>
    <xsl:param name="spanned"/>
    <xsl:apply-templates select="." mode="inalignment-begin">
      <xsl:with-param name="ncolumns" select="$ncolumns"/>
      <xsl:with-param name="context" select="$context"/>
      <xsl:with-param name="spanned" select="$spanned"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="ltx:equationgroup | ltx:equation | ltx:p" mode="inalignment">
      <xsl:with-param name="ncolumns" select="$ncolumns"/>
      <xsl:with-param name="context" select="$context"/>
      <xsl:with-param name="spanned" select="$spanned"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="." mode="aligned-constraints">
      <xsl:with-param name="ncolumns" select="$ncolumns"/>
      <xsl:with-param name="context" select="$context"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="." mode="inalignment-end">
      <xsl:with-param name="ncolumns" select="$ncolumns"/>
      <xsl:with-param name="context" select="$context"/>
      <xsl:with-param name="spanned" select="$spanned"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- equation already within a table context.
       We'll wrap in a tbody (with ID), unless we're already spanned by an equation number. -->
  <xsl:template match="ltx:equation" mode="inalignment">
    <xsl:param name="context"/>
    <xsl:param name="ncolumns"/>
    <xsl:param name="spanned"/> <!--If this equation is (row)spanned by an equation number column. -->
    <!-- The main issue here is whether to wrap with a tbody (putting any id there),
         and whether the id has already been placed on an outer table
         else just transforming the content, leaving any id to the 1st row -->
    <xsl:text>&#x0A;</xsl:text>
    <xsl:choose>
      <!-- Equation contained within a (spanning) numbered eqngroup, so can't wrap w/tbody -->
      <xsl:when test="$spanned">
        <xsl:apply-templates select="." mode="ininalignment">
          <xsl:with-param name="ncolumns" select="$ncolumns"/>
          <xsl:with-param name="context" select="$context"/>
          <xsl:with-param name="need_id" select="true()"/>
          <xsl:with-param name="spanned" select="$spanned"/>
        </xsl:apply-templates>
      </xsl:when>
      <!-- Otherwise, ALWAYS wrap equation in a tbody -->
      <xsl:otherwise>
        <xsl:element name="{f:blockelement($context,'tbody')}" namespace="{$html_ns}">
          <!-- If id hasn't been handled (by outer html:table) put it on the tbody -->
          <xsl:if test="@fragid and parent::ltx:equationgroup">
            <xsl:call-template name="add_id"/>
          </xsl:if>
          <xsl:apply-templates select="." mode="ininalignment">
            <xsl:with-param name="ncolumns" select="$ncolumns"/>
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="need_id" select="false()"/>
            <xsl:with-param name="spanned" select="child::ltx:tags"/>
          </xsl:apply-templates>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- innermost equation, already within a table and tbody.
       This is template must sort through all the MathFork's and recover the rows & columns -->
  <xsl:template match="ltx:equation" mode="ininalignment">
    <xsl:param name="context"/>
    <xsl:param name="ncolumns"/>
    <xsl:param name="need_id"/> <!--Need to put id in best, first row. -->
    <xsl:param name="spanned"/>
    <xsl:param name="eqpos"
               select="f:if(ancestor-or-self::*[contains(@class,'ltx_fleqn')],'left','center')"/>
    <xsl:choose>
      <!-- Case 1: (possibly) Multi-line equation -->
      <xsl:when test="ltx:MathFork/ltx:MathBranch[1]/ltx:tr">
        <xsl:element name="{f:blockelement($context,'tr')}" namespace="{$html_ns}">
          <!-- Note that the id is only going on the 1st row! -->
          <xsl:if test="$need_id">
            <xsl:call-template name="add_id"/>
          </xsl:if>
          <xsl:call-template name="add_attributes">
            <xsl:with-param name="extra_classes" select="'ltx_eqn_row ltx_align_baseline'"/>
          </xsl:call-template>
          <xsl:apply-templates select="." mode="inalignment-begin">
            <xsl:with-param name="ncolumns" select="$ncolumns"/>
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="spanned" select="$spanned"/>
          </xsl:apply-templates>
          <xsl:call-template name="eq-left">
            <xsl:with-param name="context" select="$context"/>
          </xsl:call-template>
          <xsl:apply-templates select="ltx:MathFork/ltx:MathBranch[1]/ltx:tr[1]/ltx:td"
                               mode="inalignment">
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="spanned" select="$spanned"/>
          </xsl:apply-templates>
          <xsl:call-template name="eq-right">
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="extrapad" select="$ncolumns - f:countcolumns(ltx:MathFork/ltx:MathBranch[1]/tr[1])"/>
          </xsl:call-template>
        </xsl:element>
        <xsl:for-each select="ltx:MathFork/ltx:MathBranch[1]/ltx:tr[position() &gt; 1]">
          <xsl:text>&#x0A;</xsl:text>
          <xsl:element name="{f:blockelement($context,'tr')}" namespace="{$html_ns}">
            <xsl:attribute name="class">ltx_eqn_row ltx_align_baseline</xsl:attribute>
            <xsl:call-template name="eq-left">
              <xsl:with-param name="context" select="$context"/>
            </xsl:call-template>
            <xsl:apply-templates select="ltx:td" mode="inalignment">
              <xsl:with-param name="context" select="$context"/>
              <xsl:with-param name="spanned" select="$spanned"/>
            </xsl:apply-templates>
            <xsl:call-template name="eq-right">
              <xsl:with-param name="context" select="$context"/>
              <!-- count carefully, here -->
              <xsl:with-param name="extrapad" select="$ncolumns - sum(ltx:td/@colspan) - count(ltx:td[not(@colspan)])"/>
            </xsl:call-template>
          </xsl:element>
        </xsl:for-each>
      </xsl:when>
      <!-- Case 2: Single line, (possibly) multiple columns -->
      <xsl:when test="ltx:MathFork/ltx:MathBranch[1]">
        <xsl:element name="{f:blockelement($context,'tr')}" namespace="{$html_ns}">
          <xsl:if test="$need_id"> <!--Don't duplicate id! -->
            <xsl:call-template name="add_id"/>
          </xsl:if>
          <xsl:call-template name="add_attributes">
            <xsl:with-param name="extra_classes" select="'ltx_eqn_row ltx_align_baseline'"/>
          </xsl:call-template>
          <xsl:apply-templates select="." mode="inalignment-begin">
            <xsl:with-param name="ncolumns" select="$ncolumns"/>
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="spanned" select="$spanned"/>
          </xsl:apply-templates>
          <xsl:call-template name="eq-left">
            <xsl:with-param name="context" select="$context"/>
          </xsl:call-template>
          <xsl:apply-templates select="ltx:MathFork/ltx:MathBranch[1]/*"
                               mode="inalignment">
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="spanned" select="$spanned"/>
          </xsl:apply-templates>
          <xsl:call-template name="eq-right">
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="extrapad" select="$ncolumns - f:countcolumns(ltx:MathFork/ltx:MathBranch[1])"/>
          </xsl:call-template>
        </xsl:element>
      </xsl:when>
      <!-- Case : default; just an unaligned equation, presumably within a group-->
      <xsl:otherwise>
        <xsl:element name="{f:blockelement($context,'tr')}" namespace="{$html_ns}">
          <xsl:if test="$need_id"> <!--Don't duplicate id! -->
            <xsl:call-template name="add_id"/>
          </xsl:if>
          <xsl:call-template name="add_attributes">
            <xsl:with-param name="extra_classes" select="'ltx_eqn_row ltx_align_baseline'"/>
          </xsl:call-template>
          <xsl:apply-templates select="." mode="inalignment-begin">
            <xsl:with-param name="ncolumns" select="$ncolumns"/>
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="spanned" select="$spanned"/>
          </xsl:apply-templates>
          <xsl:call-template name="eq-left">
            <xsl:with-param name="context" select="$context"/>
          </xsl:call-template>
          <xsl:text>&#x0A;</xsl:text>
          <xsl:element name="{f:blockelement($context,'td')}" namespace="{$html_ns}">
            <xsl:attribute name="class">
              <xsl:value-of select="concat('ltx_eqn_cell ltx_align_',$eqpos)"/>
            </xsl:attribute>
            <xsl:if test="$ncolumns > 1">
              <xsl:attribute name="colspan"><xsl:value-of select="$ncolumns"/></xsl:attribute>
            </xsl:if>
            <!-- Hopefully, ltx:MathFork has been handled by the above cases;
                 This should cover: ltx:Math, ltx:text & Misc
                 (ie. all of equation_model EXCEPT Meta & EquationMeta) -->
            <xsl:apply-templates select="ltx:Math | ltx:text
                                         | ltx:inline-block | ltx:verbatim | ltx:break
                                         | ltx:graphics | ltx:svg | ltx:rawhtml | ltx:inline-para
                                         | ltx:tabular | ltx:picture" >
              <xsl:with-param name="context" select="$context"/>
            </xsl:apply-templates>
          </xsl:element>
          <xsl:call-template name="eq-right">
            <xsl:with-param name="context" select="$context"/>
            <!-- no extra columns, since we've already made the equation span -->
          </xsl:call-template>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="." mode="aligned-constraints">
      <xsl:with-param name="ncolumns" select="$ncolumns"/>
      <xsl:with-param name="context" select="$context"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="." mode="inalignment-end">
      <xsl:with-param name="ncolumns" select="$ncolumns"/>
      <xsl:with-param name="context" select="$context"/>
      <xsl:with-param name="spanned" select="$spanned"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="ltx:equationgroup|ltx:equation" mode="aligned-constraints">
    <xsl:param name="context"/>
    <xsl:param name="ncolumns"/>
    <xsl:param name="eqpos"
               select="f:if(ancestor-or-self::*[contains(@class,'ltx_fleqn')],'left','center')"/>
    <xsl:if test="ltx:constraint[not(@hidden='true')]">
      <xsl:text>&#x0A;</xsl:text>
      <xsl:element name="{f:blockelement($context,'tr')}" namespace="{$html_ns}">
          <xsl:attribute name="class">ltx_eqn_row</xsl:attribute>
        <xsl:element name="{f:blockelement($context,'td')}" namespace="{$html_ns}">
          <xsl:attribute name="class">ltx_eqn_cell ltx_align_right</xsl:attribute>
          <!-- the $ncolumns of math, plus whatever endpadding, but NOT the number-->
          <xsl:attribute name="colspan">
            <xsl:value-of select="$ncolumns+2 + f:if(ancestor-or-self::ltx:equation[ltx:tags/ltx:tag[not(@role)]],1,0)"/>
          <!--<xsl:value-of select="$ncolumns+2"/>-->
          </xsl:attribute>
          <xsl:apply-templates select="." mode="constraints">
            <xsl:with-param name="context" select="$context"/>
          </xsl:apply-templates>
        </xsl:element>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="ltx:constraint">
    <xsl:param name="context"/>
    <xsl:element name="span" namespace="{$html_ns}">
      <xsl:variable name="context" select="'inline'"/><!-- override -->
      <xsl:call-template name="add_id"/>
      <xsl:call-template name="add_attributes"/>
      <xsl:apply-templates>
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
    </xsl:element>
  </xsl:template>

  <!-- NOTE: This is pretty wacky.  Maybe we should move the text inside the equation? -->
  <xsl:template match="ltx:td" mode="inalignment">
    <xsl:param name="context"/>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:element name="{f:blockelement($context,'td')}" namespace="{$html_ns}">
      <xsl:if test="@colspan">
        <xsl:attribute name="colspan"><xsl:value-of select="@colspan"/></xsl:attribute>
      </xsl:if>
      <xsl:call-template name="add_attributes">
        <xsl:with-param name="extra_classes" select="'ltx_eqn_cell'"/>
        <xsl:with-param name="extra_style">
          <xsl:if test="ancestor::ltx:equationgroup/@rowsep">
              <xsl:value-of select="concat('padding-top:',f:half(ancestor::ltx:equationgroup/@rowsep),';')"/>
              <xsl:value-of select="concat('padding-bottom:',f:half(ancestor::ltx:equationgroup/@rowsep),';')"/>
            </xsl:if>
          </xsl:with-param>
      </xsl:call-template>
      <xsl:apply-templates>
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:if test="(self::* = ../ltx:td[position()=last()])
                    and (parent::* = ../../ltx:tr[position()=last()])
                    and ancestor::ltx:MathFork/following-sibling::*[position()=1][self::ltx:text]">
        <!-- if we're the last td in the last tr in an equation followed by a text,
             insert the text here!-->
        <xsl:apply-templates select="ancestor::ltx:MathFork/following-sibling::ltx:text[1]/node()">
          <xsl:with-param name="context" select="$context"/>
        </xsl:apply-templates>
      </xsl:if>
    </xsl:element>
  </xsl:template>

  <xsl:template match="ltx:Math" mode="inalignment">
    <xsl:param name="context"/>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:element name="{f:blockelement($context,'td')}" namespace="{$html_ns}">
      <xsl:call-template name="add_attributes">
        <xsl:with-param name="extra_classes" select="'ltx_eqn_cell ltx_align_center'"/>
      </xsl:call-template>
      <xsl:apply-templates select=".">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:if test="ancestor::ltx:MathFork/following-sibling::*[position()=1][self::ltx:text]">
        <!-- if we're followed by a text, insert the text here!-->
        <xsl:apply-templates select="ancestor::ltx:MathFork/following-sibling::ltx:text[1]/node()">
          <xsl:with-param name="context" select="$context"/>
        </xsl:apply-templates>
      </xsl:if>
    </xsl:element>
  </xsl:template>

  <xsl:template match="ltx:text" mode="inequationgroup"/>

  <!-- ======================================================================
       Various Lists
       ====================================================================== -->

  <xsl:strip-space elements="ltx:itemize ltx:enumerate ltx:description ltx:item
                             ltx:inline-itemize ltx:inline-enumerate ltx:inline-description ltx:inline-item"/>
  <xsl:template match="ltx:itemize">
    <xsl:param name="context"/>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:element name="{f:blockelement($context,'ul')}" namespace="{$html_ns}">
      <xsl:call-template name="add_id"/>
      <xsl:call-template name="add_attributes"/>
      <xsl:apply-templates select="." mode="begin">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:apply-templates>
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="." mode="end">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:text>&#x0A;</xsl:text>
    </xsl:element>
  </xsl:template>

  <xsl:template match="ltx:enumerate">
    <xsl:param name="context"/>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:element name="{f:blockelement($context,'ol')}" namespace="{$html_ns}">
      <xsl:call-template name="add_id"/>
      <xsl:call-template name="add_attributes"/>
      <xsl:apply-templates select="." mode="begin">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:apply-templates>
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="." mode="end">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:text>&#x0A;</xsl:text>
    </xsl:element>
  </xsl:template>

  <xsl:template match="ltx:description">
    <xsl:param name="context"/>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:element name="{f:blockelement($context,'dl')}" namespace="{$html_ns}">
      <xsl:call-template name="add_id"/>
      <xsl:call-template name="add_attributes"/>
      <xsl:apply-templates select="." mode="begin">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:apply-templates mode='description'>
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="." mode="end">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:text>&#x0A;</xsl:text>
    </xsl:element>
  </xsl:template>

  <xsl:template match="ltx:item">
    <xsl:param name="context"/>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:choose>
      <xsl:when test="$SIMPLIFY_HTML">
        <xsl:element name="{f:blockelement($context,'li')}" namespace="{$html_ns}">
          <xsl:call-template name="add_id"/>
          <xsl:call-template name="add_attributes"/>
          <xsl:apply-templates select="." mode="begin">
            <xsl:with-param name="context" select="$context"/>
          </xsl:apply-templates>
          <xsl:apply-templates select="*[local-name() != 'tags']">
            <xsl:with-param name="context" select="$context"/>
          </xsl:apply-templates>
          <xsl:apply-templates select="." mode="end">
            <xsl:with-param name="context" select="$context"/>
          </xsl:apply-templates>
        </xsl:element>
      </xsl:when>
      <xsl:when test="child::ltx:tags">
        <xsl:element name="{f:blockelement($context,'li')}" namespace="{$html_ns}">
          <xsl:call-template name="add_id"/>
          <xsl:call-template name="add_attributes">
            <xsl:with-param name="extra_style">
              <xsl:value-of select="'list-style-type:none;'"/>
              <xsl:if test="@itemsep">
                <xsl:value-of select="concat('padding-top:',@itemsep,';')"/>
              </xsl:if>
            </xsl:with-param>
          </xsl:call-template>
          <xsl:apply-templates select="." mode="begin">
            <xsl:with-param name="context" select="$context"/>
          </xsl:apply-templates>
          <xsl:apply-templates select="ltx:tags/ltx:tag[not(@role)]">
            <xsl:with-param name="context" select="$context"/>
          </xsl:apply-templates>
          <xsl:text> </xsl:text>
          <xsl:apply-templates select="*[local-name() != 'tags']">
            <xsl:with-param name="context" select="$context"/>
          </xsl:apply-templates>
          <xsl:apply-templates select="." mode="end">
            <xsl:with-param name="context" select="$context"/>
          </xsl:apply-templates>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="{f:blockelement($context,'li')}" namespace="{$html_ns}">
          <xsl:call-template name="add_id"/>
          <!-- if there's no ltx:tags, it's presumably intentional -->
          <xsl:call-template name="add_attributes">
            <xsl:with-param name="extra_style">
              <xsl:value-of select="'list-style-type:none;'"/>
              <xsl:if test="@itemsep">
                <xsl:value-of select="concat('padding-top:',@itemsep,';')"/>
              </xsl:if>
            </xsl:with-param>
          </xsl:call-template>
          <xsl:apply-templates select="." mode="begin">
            <xsl:with-param name="context" select="$context"/>
          </xsl:apply-templates>
          <xsl:apply-templates>
            <xsl:with-param name="context" select="$context"/>
          </xsl:apply-templates>
          <xsl:apply-templates select="." mode="end">
            <xsl:with-param name="context" select="$context"/>
          </xsl:apply-templates>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="ltx:item" mode="description">
    <xsl:param name="context"/>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:element name="{f:blockelement($context,'dt')}" namespace="{$html_ns}">
      <xsl:call-template name="add_id"/>
      <xsl:call-template name="add_attributes"/>
      <xsl:apply-templates select="ltx:tags/ltx:tag[not(@role)]">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
    </xsl:element>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:element name="{f:blockelement($context,'dd')}" namespace="{$html_ns}">
      <xsl:call-template name="add_attributes"/>
      <xsl:apply-templates select="." mode="begin">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="*[local-name() != 'tags']">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="." mode="end">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
    </xsl:element>
  </xsl:template>

  <!-- Tricky, perhaps: ltx:tag is typically within a title or caption
       so it's the GRANDPARENT's type we want to use here!-->
  <xsl:template match="ltx:tag" mode="classes">
    <xsl:param name="context"/>
    <xsl:apply-templates select="." mode="base-classes"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="concat('ltx_tag_',local-name(../..))"/>
  </xsl:template>

  <!-- Inline forms of the above simply generate running text. -->
  <xsl:template match="ltx:inline-itemize | ltx:inline-enumerate | ltx:inline-description">
    <xsl:param name="context"/>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:element name="span" namespace="{$html_ns}">
      <xsl:variable name="innercontext" select="'inline'"/><!-- override -->
      <xsl:call-template name="add_id"/>
      <xsl:call-template name="add_attributes"/>
      <xsl:apply-templates select="." mode="begin">
        <xsl:with-param name="context" select="$innercontext"/>
      </xsl:apply-templates>
      <xsl:apply-templates>
        <xsl:with-param name="context" select="$innercontext"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="." mode="end">
        <xsl:with-param name="context" select="$innercontext"/>
      </xsl:apply-templates>
      <xsl:text>&#x0A;</xsl:text>
    </xsl:element>
  </xsl:template>

  <xsl:template match="ltx:inline-item">
    <xsl:param name="context"/>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:choose>
      <xsl:when test="child::ltx:tags">
        <xsl:element name="span" namespace="{$html_ns}">
          <xsl:variable name="innercontext" select="'inline'"/><!-- override -->
          <xsl:call-template name="add_id"/>
          <xsl:call-template name="add_attributes"/>
          <xsl:apply-templates select="." mode="begin">
            <xsl:with-param name="context" select="$innercontext"/>
          </xsl:apply-templates>
          <xsl:apply-templates select="ltx:tags/ltx:tag[not(@role)]">
            <xsl:with-param name="context" select="$innercontext"/>
          </xsl:apply-templates>
          <xsl:text> </xsl:text>
          <xsl:apply-templates select="*[local-name() != 'tags']">
            <xsl:with-param name="context" select="$innercontext"/>
          </xsl:apply-templates>
          <xsl:apply-templates select="." mode="end">
            <xsl:with-param name="context" select="$innercontext"/>
          </xsl:apply-templates>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="span" namespace="{$html_ns}">
          <xsl:variable name="innercontext" select="'inline'"/><!-- override -->
          <xsl:call-template name="add_id"/>
          <xsl:call-template name="add_attributes"/>
          <xsl:apply-templates select="." mode="begin">
            <xsl:with-param name="context" select="$innercontext"/>
          </xsl:apply-templates>
          <xsl:element name="span" namespace="{$html_ns}">
            <xsl:attribute name="class">ltx_tag</xsl:attribute>
            <xsl:text>&#x2022;</xsl:text>
          </xsl:element>
          <xsl:text> </xsl:text>
          <xsl:apply-templates>
            <xsl:with-param name="context" select="$innercontext"/>
          </xsl:apply-templates>
          <xsl:apply-templates select="." mode="end">
            <xsl:with-param name="context" select="$innercontext"/>
          </xsl:apply-templates>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ======================================================================
       Support for column splitting
       ====================================================================== -->

  <!-- Given a list of items, split it into 2 columns.
       $wrapper names the element to wrap each half of the items
       [We'd really like to call a template, but xslt1 can't call variable templates! Sigh...]
       $items is the list of items
       $miditem is the cut-off position -->
  <xsl:template name="split-columns">
    <xsl:param name="context"/>
    <xsl:param name="wrapper"/>
    <xsl:param name="items"/>
    <xsl:param name="miditem"/>

    <xsl:text>&#x0A;</xsl:text>
    <xsl:choose>
      <xsl:when test="($miditem &lt; count($items)) or not(parent::ltx:chapter)">
        <xsl:element name="div" namespace="{$html_ns}">
          <xsl:call-template name="add_id"/>
          <xsl:attribute name='class'>ltx_page_columns</xsl:attribute>
          <xsl:text>&#x0A;</xsl:text>
          <xsl:element name="div" namespace="{$html_ns}">
            <xsl:attribute name='class'>ltx_page_column1</xsl:attribute>
            <xsl:text>&#x0A;</xsl:text>
            <xsl:element name="{$wrapper}" namespace="{$html_ns}">
              <xsl:call-template name="add_attributes"/>
              <xsl:apply-templates select="." mode="begin">
                <xsl:with-param name="context" select="$context"/>
              </xsl:apply-templates>
              <xsl:apply-templates select="$items[position() &lt; $miditem]">
                <xsl:with-param name="context" select="$context"/>
              </xsl:apply-templates>
              <xsl:apply-templates select="." mode="end">
                <xsl:with-param name="context" select="$context"/>
              </xsl:apply-templates>
              <xsl:text>&#x0A;</xsl:text>
            </xsl:element>
            <xsl:text>&#x0A;</xsl:text>
          </xsl:element>
          <xsl:text>&#x0A;</xsl:text>
          <xsl:element name="div" namespace="{$html_ns}">
            <xsl:attribute name='class'>ltx_page_column2</xsl:attribute>
            <xsl:text>&#x0A;</xsl:text>
            <xsl:element name="{$wrapper}" namespace="{$html_ns}">
              <xsl:call-template name="add_attributes"/>
              <xsl:apply-templates select="." mode="begin">
                <xsl:with-param name="context" select="$context"/>
              </xsl:apply-templates>
              <xsl:apply-templates select="$items[not(position() &lt; $miditem)]">
                <xsl:with-param name="context" select="$context"/>
              </xsl:apply-templates>
              <xsl:apply-templates select="." mode="end">
                <xsl:with-param name="context" select="$context"/>
              </xsl:apply-templates>
              <xsl:text>&#x0A;</xsl:text>
            </xsl:element>
            <xsl:text>&#x0A;</xsl:text>
          </xsl:element>
          <xsl:text>&#x0A;</xsl:text>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="{$wrapper}" namespace="{$html_ns}">
          <xsl:call-template name="add_attributes"/>
          <xsl:apply-templates select="." mode="begin">
            <xsl:with-param name="context" select="$context"/>
          </xsl:apply-templates>
          <xsl:apply-templates select="$items">
            <xsl:with-param name="context" select="$context"/>
          </xsl:apply-templates>
          <xsl:apply-templates select="." mode="end">
            <xsl:with-param name="context" select="$context"/>
          </xsl:apply-templates>
          <xsl:text>&#x0A;</xsl:text>
        </xsl:element>
        <xsl:text>&#x0A;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="ltx:pagination">
    <xsl:param name="context"/>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:element name="div" namespace="{$html_ns}">
      <xsl:call-template name="add_id"/>
      <xsl:call-template name="add_attributes"/>
      <xsl:apply-templates select="." mode="begin">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="." mode="end">
        <xsl:with-param name="context" select="$context"/>
      </xsl:apply-templates>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
