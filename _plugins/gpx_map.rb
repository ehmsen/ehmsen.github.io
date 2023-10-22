module Jekyll
    class GPXMap < Liquid::Tag
        def initialize(tag_name, input, tokens)
            super
            @input = 
            @gpx_file = gpx_file
            @height = height
          end
      
          def render(context)
            <<~EOF
                <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY=" crossorigin=""/>
                <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js" integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo=" crossorigin=""></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/leaflet-gpx/1.7.0/gpx.min.js"></script>

                <script>
                document.addEventListener('DOMContentLoaded', function() {
                    var map = L.map('map');
                    L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
                        maxZoom: 19,
                        attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
                    }).addTo(map);
                    var gpx = #{@gpx_file};
                    new L.GPX(gpx, {async: true}).on('loaded', function(e) {
                        map.fitBounds(e.target.getBounds());
                    }).addTo(map);
                });
                </script>
                <div id="map" style="height:#{@height};"></div>
            EOF
          end
    end
end

Liquid::Template.register_tag('gpx_map', Jekyll::GPXMap)



