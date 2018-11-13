<template>
  <div id="app">
    <p>Dailybread</p>

    <IncomeForm />

    <p>{{ totalAfterBills }}</p>

    <form @submit.prevent="addNewBill">
      <label for="billEntry">Enter bills:</label>
      <input
        id="billEntry"
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

    <ol>
      <li v-for="bill in bills" :key="bill.id">
        {{ bill.name }} – {{ bill.amount }}
      </li>
    </ol>
  </div>
</template>

<script>
import Vue from 'vue'
import IncomeForm from 'components/IncomeForm'
import Api from 'utils/api'

import { mapState } from 'vuex'

export default {
  data () {
    return {
      bills: [],
      newBillAmount: 0,
      newBillName: ''
    }
  },

  components: {
    IncomeForm,
  },

  methods: {
    addNewBill () {
      const payload = {
        "bill": {
          "name": this.newBillName,
          "amount": this.newBillAmount,
          "pay_period": "current"
        }
      }

      Api.post('/bills', payload)
        .then(({ data: { id } }) => {
          this.bills.push({
            id: id,
            name: this.newBillName,
            amount: this.newBillAmount
          })

          this.newBillAmount = 0
          this.newBillName = ''
        })
    },

    handleIncomeSubmit () {
      const payload = { "income": { "amount": this.incomePerPeriod.amount } }

      if (this.incomePerPeriod.id) {
        Api.patch("/income", payload)
      } else {
        Api.post("/income", payload).then(({ data: { id } }) => {
          this.incomePerPeriod.id = id
        })
      }
    }
  },

  computed: {
    ...mapState(['incomePerPeriod']),

    totalAfterBills () {
      return this.incomePerPeriod.amount - this.sumOfBills
    },

    sumOfBills () {
      return this.bills.reduce((sum, b) => sum + b.amount, 0)
    }
  },

  created () {
    Api.get("/bills?pay_period=current")
      .then(({ data }) => {
        for (const { id, attributes } of data) {
          this.bills.push({
            id: id,
            name: attributes.name,
            amount: attributes.amount
          })
        }
      })
  }
}
</script>

<style>
label {
  display: block;
  cursor: pointer;
}
</style>
