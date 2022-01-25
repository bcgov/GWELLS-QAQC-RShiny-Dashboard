helptext_overview <- function(){
  "The purpose of this application is to assist Groundwater Data Specialists with the Ministry of Environment's Aquifer and Watershed Science team with their responsibilities pertaining to Quality Assurance/Quality Control (QA/QC) of groundwater data within the Province of BC’s groundwater well database (accessible through the 
<a href='https://apps.nrs.gov.bc.ca/gwells/'>GWELLS application</a>).<br>
  The application uses publicly available records that are updated nightly.<br>
  If you have any questions about the content presented within this application please contact GWELLS@gov.bc.ca. "
  
}

helptext_summaryTable1 <- function(){
  "This table summarizes the number of compliance or QA/QC issues by region for the wells added to GWELLS within the specified date range.<br>
<ul>
<li>Post- WSA wells represent those with construction, alteration or decommission dates after the February 29, 2016 (Water Sustainability Act implementation).</li>
<li>Pre-WSA indicate all work dates (construction, alteration decommission) prior to February 29, 2016 or missing all work dates.</li>
<li>Missing information columns summarizes the number of wells captured in the data tables on the Tabs called Past-WSA Wells and Pre-WSA Wells.</li>
<li>The Mislocated column summarizes the number of wells included in the table on the tab called Mislocated Wells.</li>
<li>The Cross-Referenced column estimates the number of wells that have been cross-referenced and associated with a Groundwater License Application or a Domestic Well Registration Form. Cross-Referenced wells were identified by searching for specific text string within the GWELLS comments field and numbers are likely an underestimate.</li>
<li>The Artesian column summarizes the number of wells that have 'Yes' selected under the Artesian Conditions field in GWELL.</li>
  </ul>"
}

helptext_post_wsa_wells <- function(){
  "Table 1 shows wells that may be missing essential information which were constructed, altered or decommissioned after to February 29, 2016. The wells displayed in the table meet the above criteria and were added to GWELLS between the specified date range and have a WTN within the user specified range.  "
}

helptext_mislocated_wells <- function(){
  "Table 2 shows wells that have high probability of incorrect location coordinates. The quality of the accuracy of the well location coordinates was evaluated by comparing them to the location description information using the <a href='https://www2.gov.bc.ca/gov/content/data/geographic-data-services/location-services/geocoder'>BC Address Geocoder API</a>.  The BC Address Geocoder API was used to generate the following location accuracy metrics: <br>
<br>
<ol>
<li>      <b>Geocode Distance</b>: The distance between two points (400 m or greater) using the Geocoder API and GWELLS Lat/Long.</li>
<li>    <b>Distance to matching PID</b>: >25, the higher the value the more likely for location error. </li>
<li>      <b>Score address</b>: 0 < score_address ≤ 80. Less than 80 – check. If closer to 100, likely a match to the address given. </li>
<li>      <b>Score city</b>: 0 < score_city ≤ 20. Less than 80 – check. If closer to 100, likely a match to the city given.    </li>
</ol>  
  <b>Work type:</b> <br>
    <b>No date</b> refers that there is no construction/alteration/decommission date available."  
}

helptext_pre_wsa_wells <- function(){
  "Table 3 shows wells that may be missing essential information which were constructed, altered or decommissioned prior to February 29, 2016 (pre-Water Sustainability Act) or that have no information regarding their construction, alternation or decommissioning dates. The wells displayed in the table meet the above criteria and were added to GWELLS between the user specified date range and have a WTN within the user specified range."
}

helptext_region_summary <- function(){
  "Count of well records added to GWELLS within the specified date range identified by Natural Resource Region, well class, and intended well use, <br>
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

helptext_map <- function(){
  "This map on this page displays new wells (by WTN) that were added to the GWELLS database within the user specified date range and have a WTN within the user specified range. If more than 5000 wells are requested then only the first 5000 are displayed on the map.<br>
  Click on a on the icon of a well to display information about the well including WTN, Well Class, Date added to GWELLS and the Natural Resource Region it's located in.<br>
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
  "Chart showing count of well records added to GWELLS within the specified date range identified by intended well use and well class.<br>
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