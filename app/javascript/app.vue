<template>
  <main>
    <Header />

    <div id="app" class="container-fluid pt-5">
      <router-view></router-view>

      <footer>
        <p>
          Leftover Dough was made with Ruby on Rails and Vue by Joseph M. Sak
          <span><i>&#128247;</i><i>&#128248;</i></span>
          <a href="https://github.com/joemsak/contribute-to-leftover-dough">
            Earn a free year by contributing to the source
          </a>
        </p>
      </footer>
    </div>
  </main>
</template>

<script>
import Vue from 'vue'
import { mapActions } from 'vuex'

import Header from 'components/Header'

export default {
  components: {
    Header,
  },
  methods: mapActions(['initApp']),
  created () { this.initApp() }
}
</script>

<style lang="scss" scoped>
#app {
  margin: 1rem 0 3rem;
  position: relative;
}

footer {
  margin: 1rem 0 0;
  background: snow;
  font-size: 0.9rem;
  box-shadow: 0 -0.2rem 0.7rem rgba(0, 0, 0, 0.2);
  position: fixed;
  left: 0;
  bottom: 0;
  width: 100%;
  text-align: center;
}

footer p {
  padding: 0.5rem 1rem;
  margin: 0;
  font-size: 0.9rem;
}

footer span {
  transition: transform 0.2s;
  display: inline-block;
  padding: 0 0.2rem;
}

footer span i {
  font-style: normal;
}

footer span:hover {
  transform: scale(1.5);
  cursor: none;
}

footer span i:last-child {
  display: none;
}

footer span:hover i:first-child {
  display: none;
}

footer span:hover i:last-child {
  display: inline-block;
}
</style>