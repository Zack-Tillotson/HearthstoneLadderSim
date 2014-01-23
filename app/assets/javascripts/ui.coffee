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
    window.sim.interval = setInterval ->
      window.sim.simulateRounds 1
      $('#roundvalue').html(window.sim.round)
    , window.sim.speed

  $('#pause').on 'click', ->
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
    if window.sim.interval
      clearInterval window.sim.interval
      window.sim.interval = null
    window.sim.initialize()
    $('#roundvalue').html window.sim.round

  # Reset the simulation to default values
  $('#optionsreset').on 'click', ->
    $('#numplayers').val "100"
    $('#deterministic').prop 'checked', true
    $('#fullpart').prop 'checked', false
    $('#propart').prop 'checked', true
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
