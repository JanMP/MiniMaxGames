<template lang="jade">
  div
    h1 Landing Page
    p blabla marketing bs bla
    p
      router-link(to="/tictactoe") play tictactoe
</template>

<script lang="coffee">
export default
  data : ->
    greeting : "Tach Erde!"
  methods :
    click : ->
      alert "Die Begrüßung lautet: '#{@greeting}'"
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped lang="sass">
h1, h2
  font-weight: normal

ul
  list-style-type: none
  padding: 0

li
  display: inline-block
  margin: 0 10px

a
  color: #42b983
</style>
