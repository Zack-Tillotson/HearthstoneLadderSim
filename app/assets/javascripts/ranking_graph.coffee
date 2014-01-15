#= require actor

class App.RankingGraph

  initialize: (actors) ->

    data = _.map actors.slice(1, actors.length - 1), (actor) ->
      {x: actor.strength, y: 1}

    @graph = new Rickshaw.Graph(
      element: $("#graph")[0]
      width: 960
      height: 500
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

    )

    @graph.render()
    @

  update: (actors) ->
    data = _.map actors.slice(0, actors.length - 1), (actor) ->
      {x: actor.strength, y: actor.getRank()}

    @graph.series[0].data = data
    @graph.render()
