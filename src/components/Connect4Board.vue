<template lang="jade">
  .gameContainer
    svg(width=230 height=200)
      //the board
      line(v-for="wall in walls"
        v-bind:x1="wall.lineX"
        v-bind:x2="wall.lineX"
        y1=10 y2=190
      )
      line(x1=10 x2=220 y1=190 y2=190)
      //the pieces
      transition-group(name="drop" tag="g")
        circle(v-for="piece in pieces"
          v-bind:key="piece.key"
          v-bind:cx="piece.cx"
          v-bind:cy="piece.cy"
          r=14
          v-bind:class="piece.class"
        )
      //the click areas
      rect.clickRect(v-for="column in columnRects"
        v-bind:x="column.x"
        y=10 width=28 height=179
        @click="clickColumn(column.id)"
      )
    .progressBar(v-bind:style="{width : progress*210 + 'px'}")
    .message {{message}}
    .resetButton(@click.stop.prevent="resetBoard") reset
</template>

<script lang="coffee">
_ = require "lodash"
Worker = require("worker-loader!@/assets/worker.coffee")
worker = new Worker()

export default
  data : ->
    tickel : 0
    winner : 0
    currentPlayer : 1
    message : "Viel Spaß beim Spiel!"
    progress : 0
    winningPieces : []
    board :
      [1..7].map (column) ->
        [1..6].map (row) -> 0
    columnRects : [0..6].map (column) ->
      id : column+1
      x : 11+column*30
    walls : [0..7].map (column) ->
      lineX : 10+column*30
  methods :
    clickColumn : (column) ->
      if @winner is 0 and @currentPlayer is 1
        worker.postMessage cmd : "makeMove", move : column
        @message = "Ich denke nach..."
        @tickel++
        worker.postMessage cmd : "makeBestMove"
    resetBoard : ->
      worker.postMessage cmd : "initBoard"
      @message = "Neues Spiel. Mach deinen Zug."
  created : ->
    worker.onmessage = (event) =>
      console.log event.data
      if event.data.board?
        @board = event.data.board
        @tickel++
      if event.data.currentPlayer?
        @currentPlayer = event.data.currentPlayer
      if event.data.winner?
        @winner = event.data.winner
      if event.data.winningPieces?
        @winningPieces = event.data.winningPieces
      if event.data.bestMove?
        @bestMove = event.data.bestMove
        @message = if event.data.bestMove.value > 0
          "Spieler Rot kann gewinnen."
        else if event.data.bestMove.value < 0
          "Spieler Gelb wird gewinnen!"
        else "Du bist am Zug."
      if event.data.progress?
        @progress = event.data.progress
  computed :
    pieces : ->
      @tickel
      list = []
      for column in [0..6]
        for row in [0..5]
          piece = @board[column][row]
          unless piece is 0
            cssClass = switch piece
              when 1 then "player1"
              when -1 then "player2"
            unless @winner is 0
              @message = if @winner is 1 then "Rot gewinnt!" else
                "Gelb ist der Sieger!"
              if "#{column}#{row}" in @winningPieces
                cssClass += " winning-row"
            list.push
              key : "#{column}-#{row}"
              cx : 25 + column * 30
              cy : 175 - row * 28
              class : cssClass
      list
</script>

<style scoped lang="sass">
  .gameContainer
    width : 230px
    margin : auto
  .progressBar
    margin : 0px auto 5px 10px
    padding : 0
    height : 5px
    background-color : green
  .resetButton
    width : 210px
    margin : 0 auto 5px auto
    border : 1px solid black
    border-radius : 3px
    background-color : white
    box-shadow : 2px 2px 2px silver
    cursor : pointer
    &:active
      box-shadow : 1px 1px 1px grey
  .message
    font-size : 0.5em
    height : 1rem
  svg
    background-color : transparent
  line
    stroke : black
    stroke-width : 1px
  .player1
    fill : red
  .player2
    fill : orange
  .winning-row
    animation : pulse .5s infinite
  @keyframes pulse
    0%
      r : 14.2
    50%
      r : 13.6
    100%
      r : 14.2
  .clickRect
    transition : fill-opacity 1s
    fill : cornflowerblue
    fill-opacity : 0
    &:hover
      fill-opacity : .5
  .drop-enter-to
    transform : translateY(0px)
  .drop-enter-active
    animation : drop-in .5s ease-in
  @keyframes drop-in
    0%
      transform : translateY(-230px)
    60%
      transform : translateY(0px)
    80%
      transform : translateY(-10px)
    100%
      transform : translateY(0px)
</style>
