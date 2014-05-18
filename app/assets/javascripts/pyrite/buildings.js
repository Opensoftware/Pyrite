function refreshPosition(position) {
  lonlat = new OpenLayers.LonLat(position.lon,position.lat).transform(toProjection,fromProjection);
  $("#latitude").val(lonlat.lat);
  $("#longitude").val(lonlat.lon);
}

function setPointer(map) {
  var lat = $("#latitude").val();
  var lon = $("#longitude").val();
  var zoom = 15;
  if (!(lat.length > 0 || lon.length > 1)) {
    // TODO move that to Settings
    //set default values
    lat = "52.086055"
    lon = "19.177258"
    zoom = 5;
  }
  var lonlat = new OpenLayers.LonLat(lon, lat).transform(fromProjection, toProjection);
  var size = new OpenLayers.Size(21, 25);
  var offset = new OpenLayers.Pixel(-(size.w/2), -size.h);
  var icon = new OpenLayers.Icon('http://www.openstreetmap.org/openlayers/img/marker.png',size,offset);
  layerMarkers.clearMarkers();
  layerMarkers.addMarker(new OpenLayers.Marker(lonlat,icon));
  map.setCenter(lonlat, zoom);
}
