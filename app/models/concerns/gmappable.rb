module Gmappable
  extend ActiveSupport::Concern

  def static_map
    StaticMap::Image.new(
      {
        size: '200x100',
        sensor: false,
        markers: [{
          latitude: self.lat,
          longitude: self.lng,
          color: "red",
          label: "Y"}],
        maptype: 'road',
        zoom: self.zoom,
        title: self.name,
        alt:  self.name
      }
    )
  end

  def small_static_map
    StaticMap::Image.new(
      {
        size: '120x120',
        sensor: false,
        markers: [{
          latitude: self.lat,
          longitude: self.lng,
          color: "red",
          label: "Y"}],
        maptype: 'road',
        zoom: self.zoom-2,
        title: self.name,
        alt:  self.name,
        name: self.name
      }
    )
  end

  def latlng
    "#{lat},#{lng}"
  end

  def gmap_opts
    {center:self.latlng, zoom:self.zoom}.to_json
  end

  def gmap_marker_opts
    {position:self.latlng,animation: 'google.maps.Animation.DROP'}.to_json
  end
end