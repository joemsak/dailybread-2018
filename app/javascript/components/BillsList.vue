<template>
  <ol v-if="currentPayPeriod == 1">
    <li v-for="bill in firstPeriodBills" :key="bill.id">
      {{ bill.name }} – {{ bill.amount }}
    </li>
  </ol>

  <ol v-else>
    <li v-for="bill in secondPeriodBills" :key="bill.id">
      {{ bill.name }} – {{ bill.amount }}
    </li>
  </ol>
</template>

<script>
import { mapState } from 'vuex'

export default {
  computed: mapState(['currentPayPeriod', 'firstPeriodBills', 'secondPeriodBills']),
}
</script>