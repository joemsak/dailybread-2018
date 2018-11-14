<template>
  <table class="table table-striped">
    <thead>
      <tr>
        <th>Bill name</th>
        <th>Amount</th>
        <th>Actions</th>
      </tr>
    </thead>

    <tbody>
      <tr v-for="bill in bills" :key="bill.id">
        <td>{{ bill.name }}</td>
        <td>{{ bill.amount | currency }}</td>
        <td>
          <a href="#" @click.prevent="editBill(bill)">
            edit
          </a> / delete...
        </td>
      </tr>
    </tbody>
  </table>
</template>

<script>
import { mapActions } from 'vuex'

export default {
  props: {
    bills: {
      type: Array,
      required: true,
      default: [],
    },
  },

  methods: mapActions(['editBill']),
}
</script>