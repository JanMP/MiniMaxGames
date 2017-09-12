<template lang="jade">
  .gameContainer
    svg(width=200 height=200)
      line(x1=70 x2=70 y1= 10 y2=190)
      line(x1=130 x2=130 y1= 10 y2=190)
      line(x1=10 x2=190 y1= 70 y2=70)
      line(x1=10 x2=190 y1= 130 y2=130)
      g(v-for="piece in pieces" v-bind:transform="piece.transform")
        circle.piece(
          v-if="piece.player ===  1"
          v-bind:class="{inWinningRow : piece.inWinningRow}"
          cx=0 cy=0 r=25)
        g(v-if="piece.player === -1")
          line.piece(x1=-25 x2=25 y1=-25 y2=25 v-bind:class="{inWinningRow : piece.inWinningRow}")
          line.piece(x1=25 x2=-25 y1=-25 y2=25 v-bind:class="{inWinningRow : piece.inWinningRow}")
        rect.empty(v-if="piece.player === 0"
          width=56 height=56 x=-28 y=-28 @click="clickField(piece.field)")
    .resetButton(@click.stop.prevent="resetBoard") reset
</template>

<script lang="coffee">
import game from "@/assets/TicTacToeGame.coffee"
import _ from "lodash"
export default
  data : ->
    tickel : true
    hotSeat : false
    computerStarts : false
  methods :
    getData : ->
      @tickel = not @tickel
    clickField : (field) ->
      if game.winner is 0
        game.makeMove field
        @getData()
        unless @hotSeat
          window.setTimeout =>
            game.makeMove game.getBestMove().move
            @getData()
          , 300
    test : ->
      game.makeMove game.getBestMove().move
      @getData()
    resetBoard : ->
      game.initBoard()
      unless @hotSeat
        if @computerStarts
          game.makeMove _.random 1, 9
      @getData()
  computed :
    pieces : ->
      @tickel
      result = []
      for row in [0..2]
        for column in [0..2]
          index = row*3+column
          result.push
            player : game.board[index]
            inWinningRow : if game.winner isnt 0 then index+1 in game.winningRow else false
            field : index+1
            transform : "translate(#{10+30+column*60} #{10+30+row*60})"
      result
</script>

<style scoped lang="sass">
  .gameContainer
    width : 200px
    margin : auto
  .resetButton
    width : 200px
    border : 1px solid black
    border-radius : 3px
    background-color : white
    box-shadow : 2px 2px 2px silver
    cursor : pointer
    &:active
      box-shadow : 1px 1px 1px grey
  svg
    background-color : transparent
  line
    stroke : black
    stroke-width : 2px
  .piece
    stroke : black
    stroke-width : 5px
    fill : none
  .inWinningRow
    stroke : red
  .empty
    stroke : none
    fill : transparent
    cursor : pointer

</style>
