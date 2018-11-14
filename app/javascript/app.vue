<template>
  <div id="app" class="container-fluid">
    <div class="row">
      <div class="col-8">
        <h3>&#127838; Dailybread</h3>
        <h4>Know Your Dough</h4>
        <BillsList />
      </div>

      <div class="col-4 pt-3">
        <IncomeForm />
        <BillForm />
      </div>
    </div>

    <footer>
      <p>
        Dailybread was made with Ruby on Rails and Vue by Joseph M. Sak
        <span><i>&#128247;</i><i>&#128248;</i></span>
        <a href="https://github.com/joemsak/contribute-to-db2018/">
          Earn a free year by contributing to the source
        </a>
      </p>
    </footer>
  </div>
</template>

<script>
import Vue from 'vue'
import Vue2Filters from 'vue2-filters'

Vue.use(Vue2Filters)

import IncomeForm from 'components/IncomeForm'
import BillForm from 'components/BillForm'
import BillsList from 'components/BillsList'

import Api from 'utils/api'

import { mapState, mapActions } from 'vuex'

export default {
  components: {
    IncomeForm,
    BillForm,
    BillsList,
  },

  methods: {
    ...mapActions(['initApp']),
  },

  created () {
    this.initApp()
  }
}
</script>

<style lang="scss" scoped>
#app {
  margin: 1rem 0;
}

.col-4 {
  position: fixed;
  z-index: 1;
  top: 0;
  right: 0;
  overflow-x: hidden;
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