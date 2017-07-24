import Vue from 'vue'
import Router from 'vue-router'
import NewHello from '@/components/NewHello'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'NewHello',
      component: NewHello
    }
  ]
})
