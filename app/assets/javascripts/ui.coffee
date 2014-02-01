$(document).ready ->

  # Full simulation #######################################################################################
  (App.sim = new App.Simulation()).initialize {
    numActors: $('#numplayers').val()
    deterministic: $('#deterministic').prop 'checked'
    fullParticipation: $('#fullpart').prop 'checked'
    proportionalPlayRate: $('#propart').prop 'checked'
    container1: "#container1"
    container2: "#container2"
  }

  App.pauseSim = ->
    if App.sim.interval
      $('#status').html "paused"
      $('#start').removeAttr "disabled"
      $('#pause, #faster, #slower').attr "disabled", "true"
      clearInterval App.sim.interval
      App.sim.interval = null

  App.startSim = ->
    if App.sim.interval
      clearInterval App.sim.interval
    $('#status').html "playing"
    $('#start').attr "disabled", "true"
    $('#pause, #faster, #slower').removeAttr "disabled"
    App.sim.interval = setInterval ->
      App.sim.simulateRounds 1
      $('#roundvalue').html(App.sim.round)
    , App.sim.speed

  $('#start').on 'click', ->
    App.startSim()

  $('#pause').on 'click', ->
    App.pauseSim()

  $('#faster').on 'click', ->
    App.sim.speed *= .75
    App.startSim()

  $('#slower').on 'click', ->
    App.sim.speed /= .75
    App.startSim()

  # Don't reset the configuration, just the simulation
  $('#reset').on 'click', ->
    App.sim.initialize()
    $('#roundvalue').html App.sim.round

  # Reset the simulation to default values
  $('#resetoptions').on 'click', ->
    $('#numplayers').val "100"
    $('#deterministic').prop 'checked', true
    $('#fullpart').prop 'checked', true
    $('#propart').prop 'checked', false
    App.sim.initialize(
      numActors: $('#numplayers').val()
      deterministic: $('#deterministic').prop 'checked'
      fullParticipation: $('#fullpart').prop 'checked'
      proportionalPlayRate: $('#propart').prop 'checked'
    )
    $('#roundvalue').html App.sim.round

  $('#jump1').on 'click', ->
    App.sim.simulateRounds 1
    $('#roundvalue').html(App.sim.round)

  $('#jump50').on 'click', ->
    App.sim.simulateRounds 50
    $('#roundvalue').html(App.sim.round)

  $('#jump500').on 'click', ->
    App.sim.simulateRounds 500
    $('#roundvalue').html(App.sim.round)

  $('#numplayers,#deterministic,#fullpart,#propart').on "change", ->
    App.sim.initialize
      numActors: $('#numplayers').val()
      deterministic: $('#deterministic').prop 'checked'
      fullParticipation: $('#fullpart').prop 'checked'
      proportionalPlayRate: $('#propart').prop 'checked'

  # Front page sim #######################################################################################

  (App.fpsim = new App.Simulation()).initialize {
    numActors: 100
    deterministic: true
    fullParticipation: true
    proportionalPlayRate: false
    container1: "#container3"
    container2: "#container4"
  }

  App.pauseFpSim = ->
    clearInterval App.fpsim.interval if App.fpsim.interval
    App.fpsim.interval = null

  App.startFpSim = ->
    if App.fpsim.interval
      clearInterval App.fpsim.interval
    App.fpsim.interval = setInterval ->
      App.fpsim.simulateRounds 1
      $('#fproundvalue').html(App.fpsim.round)
    , App.fpsim.speed

  App.fpsim.simulateRounds 2000
  App.startFpSim()

  # Second page sim #######################################################################################

  (App.spsim = new App.Simulation()).initialize {
    numActors: 100
    deterministic: true
    fullParticipation: true
    proportionalPlayRate: false
    container1: "#container5"
    container2: "#container6"
  }
  App.spsim.simulateRounds 2000

  App.spsim.speed = 500

  App.pauseSpSim = ->
    clearInterval App.spsim.interval if App.spsim.interval
    App.spsim.interval = null
    $('#spstatus').html("paused")

  App.startSpSim = ->

    if App.spsim.interval
      clearInterval App.spsim.interval

    $('#beforecurrentround').toggleClass "inactive", false
    $('#atcurrentround').toggleClass "inactive", true
    $('#aftercurrentround').toggleClass "inactive", true

    App.spsim.interval = setInterval -> # Step 1 start sim from steady state

      App.spsim.simulateRounds 1

      if App.spsim.round > 2010

        App.spsim.initialize()
        App.spsim.simulateRounds 1
        App.spsim.speed = 250

        $('#beforecurrentround').toggleClass "inactive", true
        $('#atcurrentround').toggleClass "inactive", false
        $('#aftercurrentround').toggleClass "inactive", true

        clearInterval App.spsim.interval # Step 2 Pause after reset

        App.spsim.interval = setInterval ->

          clearInterval App.spsim.interval
          App.spsim.interval = setInterval -> # Step 3 Start up again

            $('#beforecurrentround').toggleClass "inactive", true
            $('#atcurrentround').toggleClass "inactive", true
            $('#aftercurrentround').toggleClass "inactive", false

            if App.spsim.round is 15
              App.pauseSpSim()

              App.spsim.interval = setInterval ->

                App.spsim.simulateRounds 1985
                App.startSpSim()

              , 5000

            else
              App.spsim.simulateRounds 1

          , App.spsim.speed

        , 3000

    , App.spsim.speed

  $('#beforecurrentround').toggleClass "inactive", false
  $('#atcurrentround').toggleClass "inactive", true
  $('#aftercurrentround').toggleClass "inactive", true

  # Other UI stuff #######################################################################################

  $(".main").onepage_scroll
    sectionContainer: "section"
    easing: "ease"
    animationTime: 1000
    pagination: true
    updateURL: false
    beforeMove: (i) ->
      App.pauseSim()
      App.pauseFpSim()
      App.pauseSpSim()
    afterMove: (i) ->
      i = $('.section.active').attr('data-index')
      $("nav li").removeClass("active").find("a[datapage=#{i}]").parent().addClass("active")
      if "#{i}" is "1"
        App.startFpSim()
      if "#{i}" is "2"
        App.spsim.initialize()
        App.spsim.simulateRounds 2000
        App.startSpSim()
    loop: false
    responsiveFallback: 1000

  $("nav .pages a").on "click", (e) ->
    $('.main').moveTo $(e.target).attr('datapage')
    return false

  _.each $('.onepage-wrapper .desc'), (item) ->
    $(item).css "top", ($(item).parent().height() - $(item).height())/2

  _.each $('.onepage-wrapper .graphs'), (item) ->
    $(item).css "top", ($(item).parent().height() - $(item).height())/2

  $('img.highlight').css('width', $('body').height()-150).css('height', $('body').height()-150).css('bottom', '150px').parent().css('top', 'auto')
