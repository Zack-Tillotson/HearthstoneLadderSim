$(document).ready ->

  (window.sim = new App.Simulation()).initialize {
    numActors: $('#numplayers').val()
    deterministic: $('#deterministic').prop 'checked'
    fullParticipation: $('#fullpart').prop 'checked'
    proportionalPlayRate: $('#propart').prop 'checked'
  }

  $('#start').on 'click', ->
    if window.sim.interval
      clearInterval window.sim.interval
    $('#status').html "playing"
    $('#start').attr "disabled", "true"
    $('#pause, #faster, #slower').removeAttr "disabled"
    window.sim.interval = setInterval ->
      window.sim.simulateRounds 1
      $('#roundvalue').html(window.sim.round)
    , window.sim.speed

  $('#pause').on 'click', ->
    $('#status').html "paused"
    $('#pause, #faster, #slower').attr "disabled", "true"
    $('#start').removeAttr "disabled"
    if window.sim.interval
      clearInterval window.sim.interval
      window.sim.interval = null

  $('#faster').on 'click', ->
    if window.sim.interval
      clearInterval window.sim.interval
      window.sim.speed *= .75
      window.sim.interval = setInterval ->
        window.sim.simulateRounds 1
        $('#roundvalue').html(window.sim.round)
      , window.sim.speed

  $('#slower').on 'click', ->
    if window.sim.interval
      clearInterval window.sim.interval
      window.sim.speed /= .75
      window.sim.interval = setInterval ->
        window.sim.simulateRounds 1
        $('#roundvalue').html(window.sim.round)
      , window.sim.speed

  # Don't reset the configuration, just the simulation
  $('#reset').on 'click', ->
    window.sim.initialize()
    $('#roundvalue').html window.sim.round

  # Reset the simulation to default values
  $('#resetoptions').on 'click', ->
    $('#numplayers').val "100"
    $('#deterministic').prop 'checked', true
    $('#fullpart').prop 'checked', true
    $('#propart').prop 'checked', false
    window.sim.initialize(
      numActors: $('#numplayers').val()
      deterministic: $('#deterministic').prop 'checked'
      fullParticipation: $('#fullpart').prop 'checked'
      proportionalPlayRate: $('#propart').prop 'checked'
    )
    $('#roundvalue').html window.sim.round

  $('#jump1').on 'click', ->
    window.sim.simulateRounds 1
    $('#roundvalue').html(window.sim.round)

  $('#jump50').on 'click', ->
    window.sim.simulateRounds 50
    $('#roundvalue').html(window.sim.round)

  $('#jump500').on 'click', ->
    window.sim.simulateRounds 500
    $('#roundvalue').html(window.sim.round)

  $('#numplayers,#deterministic,#fullpart,#propart').on "change", ->
    window.sim.initialize
      numActors: $('#numplayers').val()
      deterministic: $('#deterministic').prop 'checked'
      fullParticipation: $('#fullpart').prop 'checked'
      proportionalPlayRate: $('#propart').prop 'checked'

  $(".main").onepage_scroll
    sectionContainer: "section"
    easing: "ease"
    animationTime: 1000
    pagination: true
    updateURL: false
    beforeMove: ->
      if window.sim.interval
        $('#status').html "paused"
        $('#start').removeAttr "disabled"
        $('#pause, #faster, #slower').attr "disabled", "true"
        clearInterval window.sim.interval
        window.sim.interval = null
    afterMove: ->
    loop: false
    responsiveFallback: 900

  $("nav .pages a").on "click", (e) ->
    $('.main').moveTo $(e.target).attr('datapage')
    return false

  _.each $('.desc'), (item) ->
    $(item).css "top", ($(item).parent().height() - $(item).height())/2

  _.each $('.pics'), (item) ->
    $(item).css "top", ($(item).parent().height() - $(item).height())/2
