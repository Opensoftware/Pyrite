$(document).ready(function() {

  fromProjection = new OpenLayers.Projection("EPSG:4326");   // Transform from WGS 1984
  toProjection   = new OpenLayers.Projection("EPSG:900913"); // to Spherical Mercator Projection

  map = new OpenLayers.Map("map");
  map.addLayer(new OpenLayers.Layer.OSM());
  map.events.register("click", map, function(e) {
    var position = map.getLonLatFromPixel(e.xy);
    refreshPosition(position);
    setPointer(map);
  });
  layerMarkers = new OpenLayers.Layer.Markers("Markers");
  map.addLayer(layerMarkers);
  layerMarkers.clearMarkers();
  setPointer(map);
});
