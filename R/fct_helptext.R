helptext_overview <- function(){
  
  "<h1>About</h1><br>
  The purpose of this application is to assist Groundwater Data Specialists within the Ministry of Environment's Aquifer and Watershed Science team with their responsibilities pertaining to Quality Assurance/Quality Control (QA/QC) of groundwater data within the Province's groundwater well database (accessible through the 
<a href='https://apps.nrs.gov.bc.ca/gwells/'>GWELLS application</a>).<br>
  The application uses publicly available records that are updated nightly.  This app was launched on December 13, 2021. All records that were in GWELLS prior to that date were assigned “Date Added” December 13, 2021. To view the full dataset set the date range to December 13, 2021 to present.<br>
  The 'Download' button appears after the `Generate Tables and Figures` button is pressed.<br>
  If you have any questions about the content presented within this application please contact <a href='mailto:GWELLS@gov.bc.ca'>GWELLS@gov.bc.ca</a>."
  
}

helptext_summaryTable1 <- function(){
  "This table summarizes the number of compliance or QA/QC issues by Natural Resource Region for the wells added to GWELLS within the specified date range.<br>
<ul>
<li>Post- WSA wells represent those with construction, alteration or decommission dates after the February 29, 2016 (Water Sustainability Act implementation).</li>
<li>Pre-WSA indicate all work dates (construction, alteration decommission) prior to February 29, 2016 or missing all work dates.</li>
<li>The Missing Information column summarizes the number of wells captured in Table 1 and Table 3 on the tabs called Post-WSA Wells and Pre-WSA Wells.</li>
<li>The Mislocated column summarizes the number of wells included in Table 2 on the tab called Mislocated Wells.</li>
<li>The Cross-Referenced column estimates the number of wells that have been cross-referenced by internal staff and associated with a Groundwater License Application or a Domestic Well Registration Form. Cross-Referenced wells were identified by searching for specific text strings within the GWELLS comments field and numbers are likely an underestimate.</li>
<li>The Artesian column summarizes the number of wells that have 'Yes' selected under the Artesian Conditions field in GWELLS.</li>
  </ul>"
}

helptext_post_wsa_wells <- function(){
  "Table 1 identifies wells that may be missing essential public information which were constructed, altered or decommissioned after to February 29, 2016 (post-Water Sustainability Act implementation). The wells displayed in the table meet the above criteria and were added to GWELLS between the specified date range and have a WTN within the user specified range.  "
}

helptext_mislocated_wells <- function(){
  "Table 2 identifies wells that have high probability of incorrect location coordinates. The accuracy of the well location coordinates was evaluated by comparing them to the location description information using the <a href='https://www2.gov.bc.ca/gov/content/data/geographic-data-services/location-services/geocoder'>BC Address Geocoder API</a>.  The BC Address Geocoder API was used to generate the following location accuracy metrics: <br>
<br>
<ol>
<li>      <b>Geocode Distance</b>: The distance from well to result of geocode (value 99999 indicates no result). Wells with Geocode distance of 400 m or greater are displayed in this table.</li>
<li>    <b>Distance to matching PID</b>: The distance from well to BC Parcel Fabric Polygon with matching Parcel Identifier (PID).  A higher value indicates higher probability of a location error.  NULL indicates no matching PID found.  Wells with Distance to matching PID of 25 m or greater are displayed in this table. </li>
<li>      <b>Score address</b>: Token Set Ratio score for matching wells address to reverse geocoded address (street number/name/direction). A lower score indicates a higher probability of a location error. Wells with Address Scores less than 80 are displayed in this table.</li>
<li>      <b>Score city</b>: Token Set Ratio score for matching wells city to reverse geocoded locality. A lower score indicates a higher probability of a location error. This table is not filtered by City Score.  </li>
</ol>  
<p>The Token Set Ratio is a metric with values between 0 and 100 that's determined by matching the address or city text strings using Fuzzy String Matching. Work Type refers to well construction, alteration, or decommissioning as identified by the work dates. No date indicates that no work dates are available for any type of work. The wells displayed in the table meet the above criteria and were added to GWELLS between the specified date range and have a WTN within the user specified range.</p>
"
}

helptext_pre_wsa_wells <- function(){
  "Table 3 identifies wells that may be missing essential information which were constructed, altered or decommissioned prior to February 29, 2016 (pre-Water Sustainability Act implementation) or that have no information regarding their construction, alternation or decommissioning dates. The wells displayed in the table meet the above criteria and were added to GWELLS between the user specified date range and have a WTN within the user specified range."
}

helptext_region_summary <- function(){
  "The Regional Summary table identified the counts of well records added to GWELLS within the specified date range identified by Natural Resource Region, well class, and intended well use. <br>
  <br>
<b>Well Class Codes</b><br>
WATR_SPPLY = Water Supply<br>
UNK        = Unknown<br>
MONITOR    = Monitoring<br>
DEW_DRA    = Dewatering and Drainage<br>
CLS_LP_GEO = Closed Loop Geoexchange<br>
GEOTECH    = Geotechnical<br>
REMEDIATE  = Remediation<br>
INJECTION  = Injection<br>
RECHARGE   = Recharge<br>
<br>
<b>Intended Well Use Codes for Water Supply Class Wells</b><br>
DOM        = Private Domestic<br>
UNK_USE    = Unknown Use<br>
DWS        = Water Supply System <br>
COM        = Commercial and Industrial<br>
IRR        = Irrigation <br>
OTHER      = Other<br>
TST        = Test<br>
OBS        = Observation Well<br>
OP_LP_GEO  = Open Loop Geoexchange<br>
Non-Water Supply = N/A not a Water Supply Well<br>
"
}

helptext_map <- function(){
  "Ths map displays new wells (by WTN) that were added to the GWELLS database within the user specified date range and have a WTN within the user specified range. If more than 5000 wells are requested then only the first 5000 are displayed on the map.<br>
  Click on the icon of a well to display information about the well including WTN, Well Class, Date added to GWELLS and the Natural Resource Region it's located in.<br>
<br>
<b>Well Class Codes</b><br>
WATR_SPPLY = Water Supply<br>
UNK        = Unknown<br>
MONITOR    = Monitoring<br>
DEW_DRA    = Dewatering and Drainage<br>
CLS_LP_GEO = Closed Loop Geoexchange<br>
GEOTECH    = Geotechnical<br>
REMEDIATE  = Remediation<br>
INJECTION  = Injection<br>
RECHARGE   = Recharge
"
}

helptext_bar_chart <- function(){
  "This chart presents the number of well records added to GWELLS within the specified date range identified by their well class and intended well use.<br>
  <br>
<b>Well Class Codes</b><br>
WATR_SPPLY = Water Supply<br>
UNK        = Unknown<br>
MONITOR    = Monitoring<br>
DEW_DRA    = Dewatering and Drainage<br>
CLS_LP_GEO = Closed Loop Geoexchange<br>
GEOTECH    = Geotechnical<br>
REMEDIATE  = Remediation<br>
INJECTION  = Injection<br>
RECHARGE   = Recharge<br>
<br>
<b>Intended Well Use Codes for Water Supply Class Wells</b><br>
DOM        = Private Domestic<br>
UNK_USE    = Unknown Use<br>
DWS        = Water Supply System <br>
COM        = Commercial and Industrial<br>
IRR        = Irrigation <br>
OTHER      = Other<br>
TST        = Test<br>
OBS        = Observation Well<br>
OP_LP_GEO  = Open Loop Geoexchange<br>
Non-Water Supply = N/A not a Water Supply Well<br>
"
}