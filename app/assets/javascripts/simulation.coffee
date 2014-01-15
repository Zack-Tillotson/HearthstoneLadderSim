#= require actor

class App.Simulation

  initialize: (options) ->
    @numActors = options.numActors - options.numActors % 2
    @actors = (new App.Actor().initialize(strength: num) for num in [0...@numActors])
    @rankingGraph= new App.RankingGraph().initialize(@actors)

  doRound: ->

    # Match each actor with a similar actor
    @actors.sort (a, b) ->
      if a.getRank() is b.getRank()
        Math.random() * 2 - 1
      else
        a.getRank() - b.getRank()

    # In each matchup determine a winner and loser
    for i in [0...@actors.length] by 2
      @doMatchup @actors[i], @actors[i + 1]

  printStats: ->
    vis = _.sortBy @actors, "strength"
    console.log "#{actor.strength}: #{actor.stars} => #{actor.wins} / #{actor.wins + actor.losses}" for actor in vis

  doMatchup: (a, b) ->

    isWinnerA = a.strength > b.strength

    a.recordGame(b, isWinnerA)
    b.recordGame(a, !isWinnerA)

  doRounds: (number) ->
    @doRound() for i in [0...number]

    # Update stats and visualizations
    @actors.sort (a, b) ->
      a.strength - b.strength

    @rankingGraph.update(@actors)
