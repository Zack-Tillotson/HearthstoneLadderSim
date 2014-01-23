#= require actor

class App.RankingGraph

  yaxisSelector: '.yaxis'
  graphSelector: '.graph'

  initialize: (options) ->

    @container = options.container
    $(@container).find(@graphSelector).html ""
    $(@container).find(@yaxisSelector).html ""

    actors = options.actors
    data = _.map actors.slice(0, actors.length - 0), (actor) ->
      {x: actor.strength, y: actor.getRank()}

    @graph = new Rickshaw.Graph
      element: $(@container).find(@graphSelector)[0]
      width: $(@container).find(@graphSelector).width() - 50
      height: $(@container).find(@graphSelector).height()
      renderer: 'bar'
      max: 21
      min: .75
      series: [
        {
          "color": "red"
          "name": "Player Rank"
          "data": data
        }
      ]

    @yaxis = new Rickshaw.Graph.Axis.Y
      graph: @graph
      orientation: 'left'
      element: $(@container).find(@yaxisSelector)[0]

    @hoverDetail = new Rickshaw.Graph.HoverDetail
      graph: @graph
      xFormatter: (x) -> "#{x}th Weakest Player"
      yFormatter: (y) -> "#{y}"

    @graph.render()
    @

  update: (actors) ->
    data = _.map actors, (actor) ->
      {x: actor.strength, y: actor.getRank()}

    @graph.series[0].data = data
    @graph.render()
