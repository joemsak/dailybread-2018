<template>
  <div id="app" class="container-fluid">
    <div class="row">
      <div class="col-8">
        <h3>Dailybread</h3>
        <h4>&#127838; Know Your Dough</h4>
        <BillsList />
      </div>

      <div class="col-4 pt-3">
        <IncomeForm />
        <BillForm />
      </div>
    </div>
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
</style>