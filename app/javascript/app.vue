<template>
  <div id="app">
    <p>Dailybread</p>

    <form @submit.prevent="handleIncomeSubmit">
      <label for="incomePerPeriod">Income per pay period</label>
      <input id="incomePerPeriod" type="number" @focus="$event.target.select()" v-model="incomePerPeriod.amount" />
      <button type="submit">Save</button>
    </form>

    <p>{{ totalAfterBills }}</p>

    <form @submit.prevent="addNewBill">
      <label for="billEntry">Enter bills:</label>
      <input id="billEntry" type="number" @focus="$event.target.select()" v-model.number="newBillAmount" />

      <label for="billEntryName">Name:</label>
      <input id="billEntryName" type="text" @focus="$event.target.select()" v-model="newBillName" />

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
import Api from './utils/api'

export default {
  data () {
    return {
      incomePerPeriod: {},
      bills: [],
      newBillAmount: 0,
      newBillName: ''
    }
  },

  methods: {
    addNewBill () {
      const payload = {
        "bill": {
          "name": this.newBillName,
          "amount": this.newBillAmount,
          "pay_period": 1
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
    totalAfterBills () {
      return this.incomePerPeriod.amount - this.sumOfBills
    },

    sumOfBills () {
      return this.bills.reduce((sum, b) => sum + b.amount, 0)
    }
  },

  created () {
    Api.get("/income")
      .then(({ data }) => {
        if (data) {
          const { id, attributes } = data
          Vue.set(this.incomePerPeriod, 'id', id)
          Vue.set(this.incomePerPeriod, 'amount', attributes.amount)
        } else {
          Vue.set(this.incomePerPeriod, 'id', null)
          Vue.set(this.incomePerPeriod, 'amount', 0)
        }
      })

    Api.get("/bills?pay_period=1")
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

<style scoped>
label {
  display: block;
  cursor: pointer;
}
</style>
