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

    width = $(@container).find(@graphSelector).width() - 40

    @graph = new Rickshaw.Graph
      element: $(@container).find(@graphSelector)[0]
      width: width
      height: width / 1.6
      renderer: 'line'
      max: 21
      min: .75
      series: [
        {
          "color": "rgba(255,0,0,.7)"
          "name": "Player Rank"
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
      xFormatter: (x) -> "Strength [0,1] = #{parseFloat(Math.round(x * 100) / 100).toFixed(2);}"
      yFormatter: (y) -> "#{y}"

    @graph.render()
    @

  update: (actors) ->
    data = _.map actors, (actor) ->
      {x: actor.strength, y: actor.getRank()}

    @graph.series[0].data = data
    @graph.render()
