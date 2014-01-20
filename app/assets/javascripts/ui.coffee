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
    , 100

  $('#pause').on 'click', ->
    if window.sim.interval
      clearInterval window.sim.interval
      window.sim.interval = null

  $('#reset').on 'click', ->
    if window.sim.interval
      clearInterval window.sim.interval
      window.sim.interval = null
    $('#numplayers').val "100"
    $('#deterministic').prop 'checked', false
    $('#fullpart').prop 'checked', true
    $('#propart').prop 'checked', false
    window.sim.initialize()
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

  $('#numplayers,#deterministic,#fullpart,#propart').on "click", ->
    window.sim.initialize
      numActors: $('#numplayers').val()
      deterministic: $('#deterministic').prop 'checked'
      fullParticipation: $('#fullpart').prop 'checked'
      proportionalPlayRate: $('#propart').prop 'checked'
