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
          <small>
            <a href="#" @click.prevent="editBill(bill)">
              edit
            </a>
            &nbsp;|&nbsp;
            <a href="#" class="text-danger" @click.prevent="deleteBill(bill)">
              delete
            </a>
          </small>
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

  methods: mapActions(['editBill', 'deleteBill']),
}
</script>