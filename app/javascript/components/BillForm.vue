<template>
  <form @submit.prevent="saveBill">
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
        v-model="bill.name"
      />
    </div>

    <div class="form-group">
      <label for="billEntryAmount">Amount:</label>
      <input
        id="billEntryAmount"
        type="number"
        class="form-control"
        @focus="$event.target.select()"
        v-model.number="bill.amount"
      />
    </div>

    <button type="submit" class="btn btn-primary">
      {{ editingBill ? "Save" : "Add" }}
    </button>

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
      bill: {
        amount: null,
        name: '',
      },
    }
  },

  computed: {
    ...mapState([
      'incomePerPeriod',
      'firstPeriodBills',
      'secondPeriodBills',
      'editingBill'
    ]),

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

  watch: {
    editingBill (currentValue) {
      this.bill = currentValue || { amount: null, name: '' }
    }
  },

  methods: {
    ...mapActions(['createBill', 'updateBill']),

    saveBill () {
      const payload = {
        "bill": {
          "name": this.bill.name,
          "amount": this.bill.amount,
          "payPeriod": this.currentPayPeriod,
        }
      }

      let performAction

      if (this.editingBill) {
        performAction = this.updateBill(payload)
      } else {
        performAction = this.createBill(payload)
      }

      performAction.then(() => {
        Vue.set(this.bill, 'name', '')
        Vue.set(this.bill, 'amount', null)
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