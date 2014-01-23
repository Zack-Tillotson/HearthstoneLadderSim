class App.Actor
  initialize: (options) ->
    @strength = options.strength
    @playRate = options.playRate or .5
    @stars = 0
    @lastNGames = []
    @n = 100
    @

  recordGame: (opp, isWin) ->
    if isWin
      if @stars < 100
        @stars++
    else
      if @stars > 0
        @stars--
    if (@lastNGames.unshift opp.strength) > @n
      @lastNGames.pop()

  getRank: ->
    if @stars < 4 then return 20 # 3
    if @stars < 8 then return 19
    if @stars < 12 then return 18
    if @stars < 16 then return 17
    if @stars < 20 then return 16 # 3
    if @stars < 25 then return 15 # 4
    if @stars < 30 then return 14
    if @stars < 35 then return 13
    if @stars < 40 then return 12
    if @stars < 45 then return 11 # 4
    if @stars < 51 then return 10 # 5
    if @stars < 57 then return 9
    if @stars < 63 then return 8
    if @stars < 69 then return 7
    if @stars < 75 then return 6
    if @stars < 81 then return 5
    if @stars < 87 then return 4
    if @stars < 93 then return 3
    if @stars < 99 then return 2
    return 1

  getAvgOppStrength: ->
    if @lastNGames.length > 0
      tot = _.reduce @lastNGames, (memo, obj) ->
        memo + obj
      , 0
      tot / @lastNGames.length
    else
      0
