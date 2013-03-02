<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
  version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:msxml="urn:schemas-microsoft-com:xslt"
  xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" 
  exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">


<xsl:output method="html" omit-xml-declaration="yes"/>

<xsl:param name="currentPage"/>

<xsl:template match="/">

	<xsl:variable name="mapData" select="umbraco.library:Split($currentPage/eventLocation,',')"/>

	<xsl:variable name="mapLat" select="$mapData/value[position() = 1]" />
	<xsl:variable name="mapLong" select="$mapData/value[position() = 2]" />
	<xsl:variable name="mapZoom" select="$mapData/value[position() = 3]" />
	
	<script>
		<![CDATA[
		
		function initialize() {
          var myStyles = [
                  {
                    "stylers": [
                      { "hue": "#31363c" },
                      { "saturation": -90 }
                    ]
                  },{
                    "featureType": "landscape",
                    "elementType": "geometry",
                    "stylers": [
                      { "visibility": "off" }
                    ]
                  },{
                    "featureType": "transit",
                    "elementType": "geometry",
                    "stylers": [
                      { "visibility": "simplified" }
                    ]
                  },{
                    "featureType": "poi.business",
                    "elementType": "labels",
                    "stylers": [
                      { "visibility": "off" }
                    ]
                  }
                ];
          
          var myLatlng = new google.maps.LatLng(]]><xsl:value-of select="$mapLat" /><![CDATA[,]]><xsl:value-of select="$mapLong" /><![CDATA[);
          var mapOptions = {
              zoom: ]]><xsl:value-of select="$mapZoom" /><![CDATA[,
              center: myLatlng,
              scrollwheel: false,
              navigationControl: false,
              mapTypeControl: false,
              scaleControl: false,
              streetViewControl: true,
              zoomControl: true,
              zoomControlOptions: {
                position: google.maps.ControlPosition.TOP_RIGHT
              },
              draggable: true,
              mapTypeId: google.maps.MapTypeId.ROADMAP
          }
          var map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);
          // set map style
          map.setOptions({styles: myStyles});
          
          var image = new google.maps.MarkerImage(
                  '/css/images/marker.png',
                  // This marker is 30 pixels wide by 44 pixels tall.
                  new google.maps.Size(30, 44),
                  // The origin for this image is 0,0.
                  new google.maps.Point(0,0),
                  // The anchor for this image is the base of the flagpole at 21,57.
                  new google.maps.Point(15, 44)
              ),
              shadow = new google.maps.MarkerImage(
                  '/css/images/marker_shadow.png',
                  new google.maps.Size(54, 44),
                  new google.maps.Point(0,0),
                  new google.maps.Point(15, 44)
              );
          var marker = new google.maps.Marker({
              map: map,
              position: myLatlng,
              animation: google.maps.Animation.DROP,
              title:'',
              icon: image,
              shadow: shadow
          });
          
          google.maps.event.addListener(marker, 'dblclick', function() {
            map.setZoom(17);
            map.setCenter(marker.getPosition());
          });
          
          var alignBtn = document.getElementById('re-align');
          alignBtn.addEventListener('click', function(e) {
            map.panTo(marker.getPosition());
          });
		}
		
		function loadScript() {
			var script = document.createElement("script");
			script.type = "text/javascript";
			script.src = "http://maps.googleapis.com/maps/api/js?key=AIzaSyAMaPZajy2bHYsLqcfZ_q-wbqYztpzWI00&sensor=false&callback=initialize";
			document.body.appendChild(script);
		}
		
		window.onload = loadScript;		
		
		]]>
	</script>
    <span id="re-align">Go to event</span>
</xsl:template>

</xsl:stylesheet>