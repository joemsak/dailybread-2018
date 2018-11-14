<template>
  <div class="grid">
    <div class="col-12" v-if="currentPayPeriod == 1">
      <table class="table table-striped">
        <thead>
          <tr>
            <th>Bill name</th>
            <th>Amount</th>
            <th>Actions</th>
          </tr>
        </thead>

        <tbody>
          <tr v-for="bill in firstPeriodBills" :key="bill.id">
            <td>{{ bill.name }}</td>
            <td>{{ bill.amount | currency }}</td>
            <td>edit / delete...</td>
          </tr>
        </tbody>
      </table>
    </div>

    <div class="col-12" v-else>
      <table class="table table-striped">
        <thead>
          <tr>
            <th>Bill name</th>
            <th>Amount</th>
            <th>Actions</th>
          </tr>
        </thead>

        <tbody>
          <tr v-for="bill in secondPeriodBills" :key="bill.id">
            <td>{{ bill.name }}</td>
            <td>{{ bill.amount | currency }}</td>
            <td>edit / delete...</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex'

export default {
  computed: mapState(['currentPayPeriod', 'firstPeriodBills', 'secondPeriodBills']),
}
</script>