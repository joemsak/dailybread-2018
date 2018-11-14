<template>
  <form @submit.prevent="addNewBill">
    <div class="btn-group btn-group-toggle" data-toggle="buttons">
      <label :class="['btn', 'btn-secondary', currentPayPeriod == 1 ? 'active' : '']">
        <input
          type="radio"
          name="selectPayPeriod"
          id="selectPayPeriod1"
          autocomplete="off"
          checked="currentPayPeriod == 1"
          @click="setCurrentPayPeriod(1)"
        >
        1<sup>st</sup> Pay Period
      </label>

      <label :class="['btn', 'btn-secondary', currentPayPeriod == 2 ? 'active' : '']">
        <input
          type="radio"
          name="selectPayPeriod"
          id="selectPayPeriod2"
          autocomplete="off"
          checked="currentPayPeriod == 2"
          @click="setCurrentPayPeriod(2)"
        >
        2<sup>nd</sup> Pay Period
      </label>
    </div>

    <h4 class="mt-3">Add a new bill</h4>

    <div class="form-group">
      <label for="billEntryName">Name:</label>
      <input
        type="text"
        id="billEntryName"
        ref="billEntryName"
        class="form-control"
        @focus="$event.target.select()"
        v-model="newBillName"
      />
    </div>

    <div class="form-group">
      <label for="billEntryAmount">Amount:</label>
      <input
        id="billEntryAmount"
        type="number"
        class="form-control"
        @focus="$event.target.select()"
        v-model.number="newBillAmount"
      />
    </div>

    <button type="submit" class="btn btn-primary">Add</button>

    <p class="mt-3">
      <strong>Amount remaining:</strong>
      {{ totalAfterBillsAndExpenses | currency }}
    </p>
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
    }
  },

  computed: {
    ...mapState(['incomePerPeriod', 'firstPeriodBills', 'secondPeriodBills']),

    currentPayPeriod: {
      get() { return this.$store.state.currentPayPeriod },
      set(value) { this.$store.commit('currentPayPeriod', value) }
    },

    totalAfterBillsAndExpenses () {
      let sum

      if (this.currentPayPeriod == 1) {
        sum = this.calculateSum(this.firstPeriodBills)
      } else {
        sum = this.calculateSum(this.secondPeriodBills)
      }

      return this.incomePerPeriod.amount - sum
    },

  },

  methods: {
    ...mapActions(['createBill']),

    addNewBill () {
      const payload = {
        "bill": {
          "name": this.newBillName,
          "amount": this.newBillAmount,
          "pay_period": this.currentPayPeriod,
        }
      }

      this.createBill(payload).then(() => {
        this.newBillName = ''
        this.newBillAmount = null
        this.$refs.billEntryName.focus()
      })
    },

    setCurrentPayPeriod (value) {
      this.currentPayPeriod = value
      let searchParams = new URLSearchParams(window.location.search)
      searchParams.set("payPeriod", value)
      const newRelativePathQuery = window.location.pathname + '?' + searchParams.toString()
      history.pushState(null, '', newRelativePathQuery)
    },

    calculateSum (bills) {
      return bills.reduce((sum, b) => sum + b.amount, 0)
    },
  },
}
</script>