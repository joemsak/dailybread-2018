<template>
  <form @submit.prevent="addNewBill">
    <label for="billEntryPayPeriod">During pay period:</label>
    <select
      id="billEntryPayPeriod"
      v-model.number="newBillPayPeriod"
    >
      <option value="1">First pay period</option>
      <option value="2">Second pay period</option>
    </select>

    <label for="billEntryAmount">Enter bills:</label>
    <input
      id="billEntryAmount"
      type="number"
      @focus="$event.target.select()"
      v-model.number="newBillAmount"
    />

    <label for="billEntryName">Name:</label>
    <input
      id="billEntryName"
      type="text"
      @focus="$event.target.select()"
      v-model="newBillName"
    />

    <button type="submit">Add</button>
  </form>
</template>

<script>
import { mapState, mapActions } from 'vuex'

import Api from 'utils/api'

export default {
  data () {
    return {
      newBillAmount: null,
      newBillName: '',
      mutableNewBillPayPeriod: null,
    }
  },

  computed: {
    ...mapState(['currentPayPeriod']),

    newBillPayPeriod: {
      get () { return this.currentPayPeriod },
      set (value) { this.mutableNewBillPayPeriod = value }
    },

  },

  methods: {
    ...mapActions(['createBill']),

    addNewBill () {
      const payload = {
        "bill": {
          "name": this.newBillName,
          "amount": this.newBillAmount,
          "pay_period": this.mutableNewBillPayPeriod,
        }
      }

      this.createBill(payload).then(() => {
        this.newBillName = ''
        this.newBillAmount = null
        this.mutableNewBillPayPeriod = null
      })
    },
  },
}
</script>