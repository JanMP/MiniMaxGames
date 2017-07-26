_ = require "lodash"

export default class MiniMaxGame

  constructor: (options) ->
    # () -> board
    @initBoardFkt = options.initBoardFkt
    # (board, player) -> [move]
    @getLegalMovesFkt = options.getLegalMovesFkt
    # (board, player, move) ->
    @makeMoveFkt = options.makeMoveFkt
    # (board) -> number
    @evaluateBoardFkt = options.evaluateBoardFkt
    @maxDepth = options.maxDepth ? 10
    @initBoard()

  initBoard : (firstPlayer = 1) ->
    @currentPlayer = firstPlayer
    @winner = 0
    @board = @initBoardFkt()
    this

  getLegalMoves : =>
    @getLegalMovesFkt @board, @currentPlayer

  switchPlayer : ->
    @currentPlayer = @currentPlayer * -1
    this

  evaluateBoard : ->
    @evaluateBoardFkt @board

  makeMove : (move) ->
    @makeMoveFkt @board, @currentPlayer, move
    result = @evaluateBoard()
    if result is 0
      @switchPlayer()
    else
      @winner = result
    this

  getBestMove :  ->
    #the recursive funktion:
    minimax = (board, depth, player) =>
      legalMoves = @getLegalMovesFkt board, player
      value = @evaluateBoardFkt(board)
      if depth is 0 or legalMoves.length is 0
        return { value : @evaluateBoardFkt(board) }
      bestValue = -1*player*Infinity
      bestMove = undefined
      for move in legalMoves
        tempBoard = _.clone board
        @makeMoveFkt tempBoard, player, move
        value = minimax(tempBoard, depth-1, -1*player).value
        if player*value >= player*bestValue
          bestValue = value
          bestMove = move
      return {value : bestValue, move : bestMove}

    minimax(@board, @maxDepth, @currentPlayer)
