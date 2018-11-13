<template>
  <div id="app">
    <h1>Dailybread</h1>

    <IncomeForm />

    <h3>
      Amount remaining after bills &amp; expenses:
      {{ totalAfterBills }}
    </h3>

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

  computed: {
    ...mapState(['incomePerPeriod', 'currentPayPeriod', 'firstPeriodBills', 'secondPeriodBills']),

    totalAfterBills () {
      return this.incomePerPeriod.amount - this.sumOfBills
    },

    sumOfBills () {
      if (this.currentPayPeriod == 1) {
        return this.firstPeriodBills.reduce((sum, b) => sum + b.amount, 0)
      } else {
        return this.secondPeriodBills.reduce((sum, b) => sum + b.amount, 0)
      }
    },
  },

  created () {
    this.initApp()
  }
}
</script>

<style>
label {
  display: block;
  cursor: pointer;
}
</style>
