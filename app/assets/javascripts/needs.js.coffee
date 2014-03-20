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
    marker.innerHTML = '<img src="' + @args.image_url + '" width="30" height="30">' # @args.title
    { content: marker }


@buildMap = (markers)->
  handler = Gmaps.build(
    'Google', { builders: { Marker: RichMarkerBuilder}, markers:
          clusterer: 
            gridSize: 50
            maxZoom: 25
            styles: [
              textSize: 18
              textColor: '#FFFFFF'
              backgroundColor: '#000000'
              url: 'https://s3.amazonaws.com/church_of/assets/map_assets/blue_circle.png'
              height: 60
              width: 60
            ] } #dependency injection
    
  ) 
  #then standard use
  handler.buildMap { provider: { maxZoom: 16, zoom: 13, center: new google.maps.LatLng(38.040584, -84.503716), mapTypeId: google.maps.MapTypeId.ROADMAP, styles:    [{'featureType':'water','stylers':[{'visibility':'on'},{'color':'#acbcc9'}]},{'featureType':'landscape','stylers':[{'color':'#f2e5d4'}]},{'featureType':'road.highway','elementType':'geometry','stylers':[{'color':'#c5c6c6'}]},{'featureType':'road.arterial','elementType':'geometry','stylers':[{'color':'#e4d7c6'}]},{'featureType':'road.local','elementType':'geometry','stylers':[{'color':'#fbfaf7'}]},{'featureType':'poi.park','elementType':'geometry','stylers':[{'color':'#c5dac6'}]},{'featureType':'administrative','stylers':[{'visibility':'on'},{'lightness':33}]},{'featureType':'road'},{'featureType':'poi.park','elementType':'labels','stylers':[{'visibility':'on'},{'lightness':20}]},{},{'featureType':'road','stylers':[{'lightness':20}]}]
         
    }, internal: {id: 'custom_style'} }, ->
    markers = handler.addMarkers(markers)
    # handler.bounds.extendWith(markers)
    handler.fitMapToBounds()
