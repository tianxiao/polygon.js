Display = require './display'
triangulate = require './earclipping'

class Application

  constructor: ->
    @pts = []
    @initDisplay()
    @assignEventHandlers()
    @requestAnimationFrame()

  initDisplay: ->
    try
      c = $('canvas').get 0
      gl = c.getContext 'experimental-webgl', antialias: true
      throw new Error() if not gl
    catch error
      msg = 'Alas, your browser does not support WebGL.'
      $('canvas').replaceWith "<p class='error'>#{msg}</p>"
    if gl
      width = parseInt $('canvas').css('width')
      height = parseInt $('canvas').css('height')
      @display = new Display(gl, width, height)

  requestAnimationFrame: ->
    onTick = => @tick()
    window.requestAnimationFrame onTick, @canvas

  tick: ->
    @requestAnimationFrame()
    @display?.render()

  onResize: ->
    #tbd

  injectPoints: ->
    @display.setPoints @pts
    indices = triangulate @pts
    @display.setTriangles indices

  onClick: (x, y) ->
      @pts.push new vec2(x, y)
      @injectPoints() if @display?

  removePoint: ->
      return if @pts.length < 1
      @pts.pop()
      @injectPoints() if @display?

  assignEventHandlers: ->
    $(window).resize => @onResize()

    $(document).keydown (e) =>
      @removePoint() if e.keyCode is 68
      @nextMode() if e.keyCode is 13

    # (0,0) is upper-left corner.
    $('canvas').click (e) =>
      p = $('canvas').position()
      x = e.offsetX
      y = e.offsetY
      @onClick x, y

module.exports = Application
