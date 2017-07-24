<template lang="jade">
  div
    p {{greeting}}
    input(v-model="greeting")
    button(@click="click") Klick mich!
</template>

<script lang="coffee">
module.exports =
  data : ->
    greeting : "Moin Welt!"
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
