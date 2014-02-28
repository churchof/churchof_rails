# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class RichMarkerBuilder extends Gmaps.Google.Builders.Marker #inherit from builtin builder
  #override create_marker method
  create_marker: ->
    options = _.extend @marker_options(), @rich_marker_options()
    @serviceObject = new RichMarker options #assign marker to @serviceObject

  rich_marker_options: ->
    marker = document.createElement("div")
    marker.setAttribute 'class', 'marker_container'
    marker.innerHTML = @args.title
    { content: marker }


@buildMap = (markers)->
	handler = Gmaps.build 'Google', { builders: { Marker: RichMarkerBuilder} } #dependency injection

	#then standard use
	handler.buildMap { provider: {}, internal: {id: 'map'} }, ->
	  markers = handler.addMarkers(markers)
	  handler.bounds.extendWith(markers)
	  handler.fitMapToBounds()