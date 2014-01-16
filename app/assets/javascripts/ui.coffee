$(document).ready ->

  (window.sim = new App.Simulation()).initialize {numActors: 100}

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
    window.sim.initialize()
    $('#roundvalue').html(window.sim.round)

  $('#jump1').on 'click', ->
    window.sim.simulateRounds 1
    $('#roundvalue').html(window.sim.round)

  $('#jump50').on 'click', ->
    window.sim.simulateRounds 50
    $('#roundvalue').html(window.sim.round)

  $('#jump500').on 'click', ->
    window.sim.simulateRounds 500
    $('#roundvalue').html(window.sim.round)
