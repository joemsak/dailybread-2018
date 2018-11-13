<template>
  <div class="grid">
    <div class="col-6">
      <h2>First period bills</h2>

      <h3>
        Amount remaining after bills &amp; expenses:
        {{ totalAfterBillsAndExpenses({ period: 1 }) }}
      </h3>

      <ul class="list-style--none margin--none padding--none">
        <li v-for="bill in firstPeriodBills" :key="bill.id">
          {{ bill.name }} – {{ bill.amount }}
        </li>
      </ul>
    </div>

    <div class="col-6">
      <h2>Second period bills</h2>

      <h3>
        Amount remaining after bills &amp; expenses:
        {{ totalAfterBillsAndExpenses({ period: 2 }) }}
      </h3>

      <ul class="list-style--none margin--none padding--none">
        <li v-for="bill in secondPeriodBills" :key="bill.id">
          {{ bill.name }} – {{ bill.amount }}
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex'

export default {
  computed: mapState(['incomePerPeriod', 'firstPeriodBills', 'secondPeriodBills']),

  methods: {
    totalAfterBillsAndExpenses (options) {
      let sum

      if (options.period == 1) {
        sum = this.calculateSum(this.firstPeriodBills)
      } else {
        sum = this.calculateSum(this.secondPeriodBills)
      }

      return this.incomePerPeriod.amount - sum
    },

    calculateSum (bills) {
      return bills.reduce((sum, b) => sum + b.amount, 0)
    },
  },
}
</script>