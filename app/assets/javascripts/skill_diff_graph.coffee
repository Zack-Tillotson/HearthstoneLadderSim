#= require actor

class App.SkillDiffGraph

  yaxisSelector: '.yaxis'
  graphSelector: '.graph'

  initialize: (options) ->

    @container = options.container
    $(@container).find(@graphSelector).html ""
    $(@container).find(@yaxisSelector).html ""

    actors = options.actors
    data = _.map actors, (actor) -> 
      {x: actor.strength, y: 0}

    width = $(@container).find(@graphSelector).width() - 40

    @graph = new Rickshaw.Graph
      element: $(@container).find(@graphSelector)[0]
      width: width
      height: width / 1.6
      renderer: 'line'
      min: 0
      max: .5
      series: [
        {
          "color": "rgba(255,0,0,.7)"
          "name": "Average Skill Difference, Last N Games"
          "data": data
        }
      ]

    @yaxis = new Rickshaw.Graph.Axis.Y
      graph: @graph
      orientation: 'right'
      element: $(@container).find(@yaxisSelector)[0]

    @xaxis = new Rickshaw.Graph.Axis.X
      graph: @graph
      orientation: 'top'
      tickFormat: (x) ->
        parseFloat(Math.round(x * 100) / 100).toFixed(2)

    @hoverDetail = new Rickshaw.Graph.HoverDetail
      graph: @graph
      xFormatter: (x) -> "#{x}th Weakest Player"
      yFormatter: (y) -> "#{y}"

    @graph.render()
    @

  update: (actors) ->
    data = _.map actors, (actor) -> 
      {x: actor.strength, y: Math.abs(actor.getAvgOppStrength() - actor.strength)}

    avgvalue = _.reduce(actors, (mem, actor) ->
      mem + actor.getAvgOppStrength()
    , 0)/actors.length

    @graph.series[0].data = data
    @graph.render()
