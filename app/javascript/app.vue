<template>
  <div id="app" class="container">
    <h1>Dailybread</h1>

    <IncomeForm />
    <BillForm />
    <BillsList />
  </div>
</template>

<script>
import Vue from 'vue'

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