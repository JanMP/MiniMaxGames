import MiniMaxGame from "@/assets/MiniMaxGame.coffee"

{ random, floor } = Math
rnd = (min, max) -> floor(random() * (max-min+1)) + min
shuffle = (arr) ->
  return [] if arr is []
  i = rnd 0, arr.length-1
  pick = arr[i]
  if arr.length > 1
    arr[i..i] = []
    [pick].concat shuffle arr
  else pick

export default new MiniMaxGame
  maxDepth : 8
  initBoardFkt : ->
    @winningPieces = []
    [1..7].map (column) ->
      [1..6]. map (row) -> 0
  getLegalMovesFkt : (board, player) ->
    if @evaluateBoardFkt(board) is 0
      (column for column in [1..7] when board[column-1][5] is 0)
    else []
  makeMoveFkt : (board, player, move) ->
    findRow = ->
      row = board[move-1]
      for field, index in board[move-1]
        if field is 0 then return index
    board[move-1][findRow()] = player
  evaluateBoardFkt : (board, weight) ->
    every = (arr, fkt) ->
      for ele in arr
        return false unless fkt ele
      true
    evaluate4 = (startC, startR, stepC, stepR) =>
      if (first = board[startC][startR]) is 0
        return 0
      pieces = (board[startC+i*stepC][startR+i*stepR ] for i in [0..3])
      if (every pieces, (piece) -> piece is first)
        @winningPieces = ("#{startC+i*stepC}#{startR+i*stepR}" for i in [0..3])
        first * weight
      else
        0
    evalDir = (startColumns, startRows, stepC, stepR) ->
      for startColumn in startColumns
        for startRow in startRows
          result = evaluate4 startColumn, startRow, stepC, stepR
          if result isnt 0 then return result
      return 0
    #horizontal
    result = evalDir [0..3], [0..5], 1, 0
    if result isnt 0 then return result
    #vertical
    result = evalDir [0..6], [0..2], 0, 1
    if result isnt 0 then return result
    #diagonal up
    result = evalDir [0..3], [0..2], 1, 1
    if result isnt 0 then return result
    #diagonal up
    result = evalDir [0..3], [3..5], 1, -1
    if result isnt 0 then return result
    return 0
