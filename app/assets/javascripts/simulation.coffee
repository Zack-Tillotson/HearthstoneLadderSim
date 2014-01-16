#= require actor

class App.Simulation

  initialize: (options = {}) ->
    @numActors = (options.numActors - options.numActors % 2) if options.numActors
    @actors = (new App.Actor().initialize(strength: num) for num in [0...@numActors])
    @round = 0
    @rankingGraph = new App.RankingGraph().initialize(actors: @actors, container: '#container1')
    @oppSkillGraph = new App.OppSkillGraph().initialize(actors: @actors, container: '#container2')
    @skillDiffGraph = new App.SkillDiffGraph().initialize(actors: @actors, container: '#container3')

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

    @round++

  doMatchup: (a, b) ->

    isWinnerA = @chooseWinner a, b

    a.recordGame(b, isWinnerA)
    b.recordGame(a, !isWinnerA)

  chooseWinner: (a, b) ->
    a.strength + Math.random() * Math.pow(@numActors, .5) > b.strength + Math.random() * Math.pow(@numActors, .5)
    #a.strength > b.strength

  simulateRounds: (number) ->

    @doRound() for i in [0...number]

    @actors.sort (a, b) ->
      a.strength - b.strength

    @rankingGraph.update(@actors)
    @oppSkillGraph.update(@actors)
    @skillDiffGraph.update(@actors)
