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

    @graph = new Rickshaw.Graph
      element: $(@container).find(@graphSelector)[0]
      width: $(@container).find(@graphSelector).width() - 50
      height: $(@container).find(@graphSelector).height()
      renderer: 'bar'
      min: 0
      max: 20
      series: [
        {
          "color": "red"
          "name": "Average Skill Difference, Last N Games"
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
      {x: actor.strength, y: Math.abs(actor.getAvgOppStrength() - actor.getRank())}

    avgvalue = _.reduce(actors, (mem, actor) ->
      mem + actor.getAvgOppStrength()
    , 0)/actors.length

    @graph.series[0].data = data
    @graph.render()
