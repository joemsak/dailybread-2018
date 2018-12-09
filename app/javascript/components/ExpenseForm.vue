<template>
  <form @submit.prevent="saveExpense">
    <h4 class="mt-3">Add a new expense</h4>

    <div class="form-group">
      <label for="expenseEntryDate">Made on:</label>
      <input
        id="expenseEntryDate"
        type="date"
        class="form-control"
        @focus="$event.target.select()"
        v-model="expenseMadeOn"
      />
    </div>

    <div class="form-group">
      <label for="expenseEntryCategory">Category:</label>
      <input
        type="text"
        id="expenseEntryCategory"
        ref="expenseEntryCategory"
        class="form-control"
        @focus="$event.target.select()"
        v-model="expense.category"
      />
    </div>

    <div class="form-group">
      <label for="expenseEntryName">Name: (optional)</label>
      <input
        type="text"
        id="expenseEntryName"
        ref="expenseEntryName"
        class="form-control"
        @focus="$event.target.select()"
        v-model="expense.name"
      />
    </div>

    <label for="expenseEntryAmount">Amount:</label>
    <div class="input-group mb-3">
      <div class="input-group-prepend">
        <span class="input-group-text" id="basic-addon1">$</span>
      </div>

      <input
        id="expenseEntryAmount"
        type="number"
        step="0.01"
        class="form-control"
        @focus="$event.target.select()"
        v-model.number="expense.amount"
      />
    </div>

    <button type="submit" class="btn btn-primary">
      {{ editingExpense ? "Save" : "Add" }}
    </button>

    <p class="mt-3">
      <strong>Amount remaining:</strong>
      {{ totalAfterBillsAndExpenses | currency }}
    </p>
  </form>
</template>

<script>
import Vue from 'vue'
import { mapState, mapActions, mapGetters } from 'vuex'

import Api from 'utils/api'

export default {
  data () {
    return {
      expense: {
        amount: null,
        name: '',
        category: '',
        madeOn: new Date(),
      },
    }
  },

  computed: {
    ...mapState([
      'incomePerPeriod',
      'currentPayPeriod',
      'expenses',
      'firstPeriodBills',
      'secondPeriodBills',
      'editingExpense'
    ]),

    ...mapGetters([
      'totalAfterBillsAndExpenses',
    ]),

    expenseMadeOn: {
      get() {
        const madeOn = this.expense.madeOn

        if (typeof(madeOn) === 'string') {
          const parts = madeOn.split('/')
          return [parts[2], parts[0], parts[1]].join("-")
        } else {
          const year = madeOn.getFullYear()
          let month = madeOn.getMonth() + 1
          let day = madeOn.getDate()

          if (day.toString().length === 1)
            day = `0${day}`

          if (month.toString().length === 1)
            month = `0${month}`

          return [year, month, day].join("-")
        }
      },

      set(value) {
        const parts = value.split("-")

        const year = parts[0]
        const month = parts[1]
        let day = parts[2]

        if (day.toString().length === 1)
          day = `0${day}`

        const localTimeDateString = `${month}/${day}/${year}`
        Vue.set(this.expense, 'madeOn', new Date(localTimeDateString))
      }
    },
  },

  watch: {
    editingExpense (currentValue) {
      this.expense = currentValue || {
        amount: null,
        name: '',
        category: '',
        madeOn: new Date(),
      }
    }
  },

  methods: {
    ...mapActions(['createExpense', 'updateExpense']),

    saveExpense () {
      const payload = {
        "expense": {
          "category": this.expense.category,
          "name": this.expense.name,
          "amount": this.expense.amount,
          "madeOn": this.expense.madeOn,
        }
      }

      let performAction

      if (this.editingExpense) {
        performAction = this.updateExpense(payload)
      } else {
        performAction = this.createExpense(payload)
      }

      performAction.then(() => {
        Vue.set(this.expense, 'name', '')
        Vue.set(this.expense, 'amount', null)
        Vue.set(this.expense, 'category', '')
        Vue.set(this.expense, 'madeOn', new Date())
        this.$refs.expenseEntryCategory.focus()
      })
    },
  },
}
</script>