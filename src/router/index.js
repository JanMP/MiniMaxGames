import Vue from 'vue'
import Router from 'vue-router'
import Landing from '@/components/landing'
import TicTacToeBoard from '@/components/TicTacToeBoard'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/tictactoe',
      name: 'tictactoe',
      component: TicTacToeBoard
    },
    {
      path: '/',
      name: 'landing',
      component: Landing
    }
  ]
})
