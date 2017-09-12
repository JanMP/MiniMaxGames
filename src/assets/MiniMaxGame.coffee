export default class MiniMaxGame

  constructor: (options) ->
    @useWorker = false
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

  addEventListener : ->
    @useWorker = true
    addEventListener "message", (event) =>
      if event.data?
        switch event.data.cmd
          when "initBoard"
            @initBoard event.data.firstPlayer
            postMessage
              board : @board
              currentPlayer : @currentPlayer
              winner : @winner
              progress : 0
          when "makeMove"
            if (move = event.data.move) in @getLegalMoves()
              @makeMove(move)
              postMessage
                board : @board
                currentPlayer : @currentPlayer
                winner : @winner
                winningPieces : @winningPieces
                progress : 0
          when "makeBestMove"
            bestMove = @getBestMove()
            @makeMove bestMove.move
            postMessage
              board : @board
              currentPlayer : @currentPlayer
              winner : @winner
              winningPieces : @winningPieces
              bestMove : bestMove
              progress : 0
          when "getBoard"
            postMessage board : @board
          when "getCurrentPlayer"
            postMessage currentPlayer : @currentPlayer
          when "getBestMove"
            postMessage bestMove : @getBestMove()
          when "getWinner"
            postMessage winner : @winner
          when "getWinningPieces"
            postMessage winningPieces : @getWinningPieces
          else
            postMessage
              error : "cmd unknown"
              receipt : event.data

  initBoard : (firstPlayer = 1) ->
    @currentPlayer = firstPlayer
    @winner = 0
    @winningPieces = []
    @board = @initBoardFkt()
    this

  getLegalMoves : =>
    @getLegalMovesFkt @board, @currentPlayer

  switchPlayer : ->
    @currentPlayer = @currentPlayer * -1
    this

  evaluateBoard : ->
    @evaluateBoardFkt @board, 1

  makeMove : (move) ->
    @makeMoveFkt @board, @currentPlayer, move
    result = @evaluateBoard()
    if result is 0
      @switchPlayer()
    else
      @winner = Math.sign result
    this

  getBestMove :  ->

    copy = (o) ->
      out = if Array.isArray o then [] else {}
      for key of o
        v = o[key]
        out[key] = if (typeof v) is "object" then copy(v) else v
      return out

    random = (min, max) ->
      Math.floor(Math.random() * (max-min+1)) + min

    shuffle = (arr) ->
      i = random 0, arr.length-1
      pick = arr[i]
      if arr.length > 1
        arr[i..i] = []
        [pick].concat shuffle arr
      else pick

    console.log "starting minimax"
    #the recursive funktion:
    minimax = (board, depth, player, done, alpha, beta) =>
      legalMoves = if depth is @maxDepth
        shuffle(@getLegalMovesFkt board, player)
      else
        @getLegalMovesFkt board, player
      if depth is 0 or legalMoves.length is 0
        return { value : @evaluateBoardFkt(board, depth+1)}
      bestValue = -1*player*Infinity
      bestMove = undefined
      for move, i in legalMoves
        if @useWorker
          if @maxDepth - depth <= 1
            done += 1/7**(@maxDepth-depth+1)
            postMessage
              progress : done
        tempBoard = copy board
        @makeMoveFkt tempBoard, player, move
        value = minimax(tempBoard, depth-1, -1*player, done, alpha, beta).value
        if player*value > player*bestValue
          bestValue = value
          if player is 1
            if bestValue > alpha then alpha = bestValue
          if player is -1
            if bestValue < beta then beta = bestValue
          if beta <= alpha then return {value : bestValue, move : bestMove}
          bestMove = move
      return {value : bestValue, move : bestMove}

    done = -1/@getLegalMovesFkt(@board, @player).length
    minimax(@board, @maxDepth, @currentPlayer, done, -1*Infinity, Infinity)
