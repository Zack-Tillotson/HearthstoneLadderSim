#= require actor

class App.Simulation

  initialize: (options = {}) ->

    @numActors = (options.numActors - options.numActors % 2) if options.numActors
    @deterministicWinning = options.deterministic if options.deterministic
    @fullParticipation = options.fullParticipation if options.fullParticipation
    @proportionalPlayRate = options.proportionalPlayRate if options.proportionalPlayRate
    @container1 = options.container1 if options.container1
    @container2 = options.container2 if options.container2

    @actors = (new App.Actor().initialize(
        strength: num / (@numActors - 1) # [0,1] with higher being better
        playRate: num / (@numActors - 1) # Proportion of rounds played, ignored if full participation or using nonproportional play rate
    ) for num in [0...@numActors])
    @round = 0
    @playRate = .5
    @speed = 250 # Default iteration wait time

    @rankingGraph = new App.RankingGraph().initialize(actors: @actors, container: @container1)
    @skillDiffGraph = new App.SkillDiffGraph().initialize(actors: @actors, container: @container2)

  doRound: ->
    console.log "doRound", @

    # Choose which actors are participating this round
    participants = @actors
    if not @fullParticipation
      if @proportionalPlayRate
        participants = _.filter participants, (a) -> a.playRate > Math.random()
      else
        participants = _.filter participants, (a) -> .5 > Math.random()

    # Match each participant with a similarly ranked participant
    participants.sort (a, b) ->
      if a.getRank() is b.getRank()
        Math.random() * 2 - 1
      else
        a.getRank() - b.getRank()

    # In each matchup determine a winner and loser
    for i in [0...participants.length - participants.length % 2] by 2
      @doMatchup participants[i], participants[i + 1]

    @round++

  doMatchup: (a, b) ->

    isWinnerA = @isWinnerA(a, b)

    a.recordGame(b, isWinnerA)
    b.recordGame(a, not isWinnerA)

  isWinnerA: (a, b) ->
    try
      if @deterministicWinning
        a.strength > b.strength
      else
        a.strength + Math.random() > b.strength + Math.random()
    catch e
      console.log "ERRROR!", a, b

  simulateRounds: (number) ->

    @doRound() for i in [0...number]

    @actors.sort (a, b) ->
      a.strength - b.strength

    @rankingGraph.update(@actors)
    @skillDiffGraph.update(@actors)
