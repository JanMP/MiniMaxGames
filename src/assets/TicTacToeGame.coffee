import MiniMaxGame from "@/assets/MiniMaxGame.coffee"

rows = [
  [1,2,3],[4,5,6],[7,8,9],
  [1,4,7],[2,5,8],[3,6,9],
  [1,5,9],[3,5,7]
]

export default new MiniMaxGame
  initBoardFkt : ->
    @winningRow = []
    [0,0,0,0,0,0,0,0,0]
  getLegalMovesFkt : (board, player) ->
    if @evaluateBoardFkt(board) is 0
      (i+1 for field, i in board when field is 0)
    else []
  makeMoveFkt : (board, player, move) ->
    board[move-1] = player
  evaluateBoardFkt : (board) ->
    for row in rows
      rowSum = 0
      rowSum += board[field-1] for field in row
      if rowSum is 3 or rowSum is -3
        @winningRow = row
      return 1 if rowSum is 3
      return -1 if rowSum is -3
    0
