$(document).ready ->

  (window.sim = new App.Simulation()).initialize {numActors: 100}

  $('#startstop').on 'click', ->
    if window.sim.interval
      clearInterval window.sim.interval
      window.sim.interval = null
    else
      window.sim.interval = setInterval ->
        window.sim.simulateRounds 1
      , 100
    $("#startstop").toggleClass "active", window.sim.interval?

  $('#reset').on 'click', ->
    if window.sim.interval
      clearInterval window.sim.interval
      window.sim.interval = null
    window.sim.initialize()
