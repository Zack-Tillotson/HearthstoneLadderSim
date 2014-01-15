class App.Actor
  initialize: (options) ->
    @strength = options.strength
    @stars = 0
    @wins = 0
    @losses = 0
    @

  recordGame: (opp, isWin) ->
    if isWin
      @wins++
      if @stars < 100
        @stars++
    else 
      @losses++
      if @stars > 0
        @stars--

  getRank: ->
    if @stars < 3 then return 1 # 3
    if @stars < 6 then return 2
    if @stars < 9 then return 3
    if @stars < 12 then return 4
    if @stars < 15 then return 5 # 3
    if @stars < 19 then return 6 # 4
    if @stars < 23 then return 7
    if @stars < 27 then return 8
    if @stars < 31 then return 9
    if @stars < 35 then return 10 # 4
    if @stars < 40 then return 11 # 5
    if @stars < 45 then return 12
    if @stars < 50 then return 13
    if @stars < 55 then return 14
    if @stars < 65 then return 15
    if @stars < 70 then return 16
    if @stars < 75 then return 17
    if @stars < 80 then return 18
    if @stars < 85 then return 19
    if @stars < 90 then return 20
    if @stars < 95 then return 21
    return 22
