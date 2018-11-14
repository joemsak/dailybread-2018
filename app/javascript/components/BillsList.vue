<template>
  <div class="grid">
    <div class="col-12" v-if="currentPayPeriod == 1">
      <Table :items="firstPeriodBills" item-type="bill" />
    </div>

    <div class="col-12" v-else>
      <Table :items="secondPeriodBills" item-type="bill" />
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex'

import Table from 'components/Table'

export default {
  components: {
    Table,
  },

  computed: mapState([
    'currentPayPeriod',
    'firstPeriodBills',
    'secondPeriodBills'
  ]),
}
</script>