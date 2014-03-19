# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class RichMarkerBuilder extends Gmaps.Google.Builders.Marker #inherit from builtin builder
  #override create_marker method
  create_marker: ->
    options = _.extend @marker_options(), @rich_marker_options(), 
    scrollwheel: false,
    navigationControl: false,
    mapTypeControl: false,
    scaleControl: false,
    draggable: false

    @serviceObject = new RichMarker options #assign marker to @serviceObject

  rich_marker_options: ->
    marker = document.createElement("div")
    marker.setAttribute 'class', 'marker_container'
    marker.innerHTML = '<img src="' + @args.image_url + '" alt="Smiley face" width="40" height="40">' # @args.title
    { content: marker }


@buildMap = (markers)->
  handler = Gmaps.build(
    'Google', { builders: { Marker: RichMarkerBuilder}, markers:
          clusterer:
            gridSize: 40
            maxZoom: 10
            styles: [
              textSize: 10
              textColor: '#ff0000'
              url: ''
              height: 26
              width: 30
            ,
              textSize: 14 
              textColor: '#ffff00'
              url: ''
              height: 35
              width: 40
            ,
             textSize: 18 
             textColor: '#0000ff'
             url: ''
             width: 50
             height: 44
            ] } #dependency injection
    
  ) 
  #then standard use
  handler.buildMap { provider: {}, internal: {id: 'custom_style'} }, ->
    markers = handler.addMarkers(markers)
    handler.bounds.extendWith(markers)
    handler.fitMapToBounds()
