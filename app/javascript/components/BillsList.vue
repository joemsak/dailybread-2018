<template>
  <div class="grid">
    <div class="col-12" v-if="currentPayPeriod == 1">
      <BillsTable :bills="firstPeriodBills" />
    </div>

    <div class="col-12" v-else>
      <BillsTable :bills="secondPeriodBills" />
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex'

import BillsTable from 'components/BillsTable'

export default {
  components: {
    BillsTable,
  },

  computed: mapState([
    'currentPayPeriod',
    'firstPeriodBills',
    'secondPeriodBills'
  ]),
}
</script>