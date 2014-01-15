#= require actor

class App.SkillDiffGraph

  yaxisSelector: '.yaxis'
  graphSelector: '.graph'

  initialize: (options) ->

    @container = options.container
    $(@container).find(@graphSelector).html ""
    $(@container).find(@yaxisSelector).html ""

    actors = options.actors
    data = _.map _.filter(actors, (item) -> item.strength in [10, 30, 50, 70, 90]), (actor) -> 
      {x: actor.strength, y: Math.abs(actor.getAvgOppStrength() - actor.strength)}

    @graph = new Rickshaw.Graph
      element: $(@container).find(@graphSelector)[0]
      height: $(@container).find(@graphSelector).width() * 2 / 3
      width: $(@container).find(@graphSelector).width() - 50
      renderer: 'bar'
      min: 0
      series: [
        {
          "color": "red"
          "name": "Player Rank"
          "data": data
        }
      ]

    @xaxis = new Rickshaw.Graph.Axis.X
      graph: @graph
      orientation: 'top'

    @yaxis = new Rickshaw.Graph.Axis.Y
      graph: @graph
      orientation: 'left'
      element: $(@container).find(@yaxisSelector)[0]

    @graph.render()
    @

  update: (actors) ->
    data = _.map _.filter(actors, (item) -> item.strength in [10, 30, 50, 70, 90]), (actor) -> 
      {x: actor.strength, y: Math.abs(actor.getAvgOppStrength() - actor.strength)}

    avgvalue = _.reduce(actors, (mem, actor) ->
      mem + actor.getAvgOppStrength()
    , 0)/actors.length

    @graph.series[0].data = data
    @graph.render()
