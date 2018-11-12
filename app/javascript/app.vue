<template>
  <div id="app">
    <p>Dailybread</p>

    <p>
      <label for="incomePerPeriod">Income per pay period</label>
      <input id="incomePerPeriod" type="number" @focus="this.select()" v-model="incomePerPeriod" />
    </p>

    <p>{{ totalAfterBills }}</p>

    <form @submit.prevent="addNewBill">
      <label for="billEntry">Enter bills:</label>
      <input id="billEntry" type="number" @focus="this.select()" v-model="newBillAmount" />

      <label for="billEntryName">Name:</label>
      <input id="billEntryName" type="text" @focus="this.select()" v-model="newBillName" />

      <button>Add</button>
    </form>

    <ol>
      <li v-for="bill in bills" :key="bill.id">
        {{ bill.name }} – {{ bill.amount }}
      </li>
    </ol>
  </div>
</template>

<script>
import uuid from 'uuid/v4'

export default {
  data () {
    return {
      incomePerPeriod: 0,
      bills: [],
      newBillAmount: 0,
      newBillName: ''
    }
  },

  methods: {
    addNewBill () {
      this.bills.push({
        id: uuid(),
        name: this.newBillName,
        amount: this.newBillAmount
      })
      this.newBillAmount = 0
      this.newBillName = ''
    }
  },

  computed: {
    totalAfterBills () {
      return this.incomePerPeriod - this.sumOfBills
    },

    sumOfBills () {
      return this.bills.reduce((sum, b) => sum + b.amount, 0)
    }
  },
}
</script>

<style scoped>
label {
  display: block;
  cursor: pointer;
}
</style>
