<template>
  <form @submit.prevent>
    <label for="incomePerPeriod">Income per pay period</label>
    <input
      id="incomePerPeriod"
      type="number"
      @focus="$event.target.select()"
      v-model="amount"
    />

    <button type="submit">Save</button>
  </form>
</template>

<script>
  import Vue from 'vue'

  import { mapState, mapActions } from 'vuex'

  export default {
    computed: {
      ...mapState(['incomePerPeriod']),

      amount: {
        get() { return this.incomePerPeriod.amount },
        set(amount) { this.updateIncome({ amount }) }
      }
    },

    methods: mapActions(['initIncome', 'updateIncome']),

    created () {
      this.initIncome()
    }
  }
</script>