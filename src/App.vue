<template lang="jade">
  #app
    router-view
</template>

<script lang="coffee">
module.exports =
  data : ->
    name : "app"
</script>

<style lang="sass">
#app
  font-family: 'Avenir', Helvetica, Arial, sans-serif
  -webkit-font-smoothing: antialiased
  -moz-osx-font-smoothing: grayscale
  text-align: center
  color: #2c3e50
  margin-top: 60px
</style>
