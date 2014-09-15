class RichMarkerBuilder extends Gmaps.Google.Builders.Marker #inherit from builtin builder
  #override create_marker method
  create_marker: ->
    options = _.extend @marker_options(), @rich_marker_options()
    @serviceObject = new RichMarker options #assign marker to @serviceObject

  rich_marker_options: ->
    marker = document.createElement("div")
    marker.setAttribute 'class', 'marker_container'
    
    string = "https://s3.amazonaws.com/church_of/assets/skill_icons/715-globe%402x.png"
    if @args.image_url  
      string = @args.image_url
    marker.innerHTML = '<img src="' + string + '" width="30" height="30">' # @args.title
    { content: marker }


  # override method
  create_infowindow: ->
    return null unless _.isString @args.custom_infowindow
    boxText = document.createElement("div")
    boxText.setAttribute("class", 'marker_info_box') #to customize
    boxText.innerHTML = @args.custom_infowindow
    @infowindow = new InfoBox(@infobox(boxText))

    # add @bind_infowindow() for < 2.1

  infobox: (boxText)->
    content: boxText
    pixelOffset: new google.maps.Size(-140, 0)
    boxStyle:
      width: "280px"

@buildMap = (markers, fit)->
  handler = Gmaps.build(
    'Google', { builders: { Marker: RichMarkerBuilder}, markers:
          clusterer: 
            gridSize: 50
            maxZoom: 25
            styles: [
              textSize: 18
              textColor: '#FFFFFF'
              backgroundColor: '#000000'
              url: 'https://s3.amazonaws.com/church_of/assets/map_assets/green_circle.png'
              height: 60
              width: 60
            ] } #dependency injection
    
  ) 
  #then standard use
  handler.buildMap { provider: { scrollwheel: false, panControl: true, maxZoom: 16, minZoom: 11, zoom: 13, center: new google.maps.LatLng(38.040584, -84.503716), mapTypeId: google.maps.MapTypeId.ROADMAP, disableDefaultUI: true, zoomControl: true, zoomControlOptions: { style: google.maps.ZoomControlStyle.LARGE }, styles:    [{'featureType':'water','stylers':[{'visibility':'on'},{'color':'#acbcc9'}]},{'featureType':'landscape','stylers':[{'color':'#f2e5d4'}]},{'featureType':'road.highway','elementType':'geometry','stylers':[{'color':'#c5c6c6'}]},{'featureType':'road.arterial','elementType':'geometry','stylers':[{'color':'#e4d7c6'}]},{'featureType':'road.local','elementType':'geometry','stylers':[{'color':'#fbfaf7'}]},{'featureType':'poi.park','elementType':'geometry','stylers':[{'color':'#c5dac6'}]},{'featureType':'administrative','stylers':[{'visibility':'on'},{'lightness':33}]},{'featureType':'road'},{'featureType':'poi.park','elementType':'labels','stylers':[{'visibility':'on'},{'lightness':20}]},{},{'featureType':'road','stylers':[{'lightness':20}]}]
         
    }, internal: {id: 'custom_style'} }, ->
    markers = handler.addMarkers(markers)
    if fit
      handler.bounds.extendWith(markers)
    handler.fitMapToBounds()

# This doesnt work so just reloading the page everytime.
@replaceMap = (markers)->
  handler.removeMarkers(markers)
