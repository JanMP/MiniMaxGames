import Vue from 'vue'
import Router from 'vue-router'
import Landing from '@/components/landing'
import TicTacToeBoard from '@/components/TicTacToeBoard'
import Connect4Board from '@/components/Connect4Board'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/tictactoe',
      name: 'tictactoe',
      component: TicTacToeBoard
    },
    {
      path: '/connect4',
      name: 'connect4',
      component: Connect4Board
    },
    {
      path: '/',
      name: 'landing',
      component: Landing
    }
  ]
})
