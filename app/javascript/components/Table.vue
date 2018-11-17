<template>
  <div class="table-responsive">
    <table class="table table-striped">
      <thead>
        <tr>
          <th>Name</th>
          <th>Amount</th>
          <th>Actions</th>
        </tr>
      </thead>

      <tbody>
        <tr v-for="item in items" :key="item.id">
          <td>{{ item.name }}</td>
          <td>{{ item.amount | currency }}</td>
          <td>
            <small>
              <a href="#" @click.prevent="editItem(item)">
                edit
              </a>
              &nbsp;|&nbsp;
              <a href="#" class="text-danger" @click.prevent="deleteItem(item)">
                delete
              </a>
            </small>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
import { mapActions } from 'vuex'

export default {
  props: {
    items: {
      type: Array,
      required: true,
      default: [],
    },

    itemType: {
      type: String,
      required: true,
    }
  },

  methods: {
    ...mapActions(['editBill', 'deleteBill', 'editExpense', 'deleteExpense']),

    editItem (item) {
      if (this.itemType === 'bill') {
        this.editBill(item)
      } else {
        this.editExpense(item)
      }
    },

    deleteItem (item) {
      if (this.itemType === 'bill') {
        this.deleteBill(item)
      } else {
        this.deleteExpense(item)
      }
    },
  },
}
</script>