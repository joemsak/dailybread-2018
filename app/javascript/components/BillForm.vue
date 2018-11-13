<template>
  <form @submit.prevent="addNewBill" class="grid">
    <div class="col-12">
      <label for="billEntryPayPeriod">During pay period:</label>
      <select
        id="billEntryPayPeriod"
        v-model.number="newBillPayPeriod"
      >
        <option value="1">First pay period</option>
        <option value="2">Second pay period</option>
      </select>

      <label for="billEntryName">Name:</label>
      <input
        type="text"
        id="billEntryName"
        ref="billEntryName"
        @focus="$event.target.select()"
        v-model="newBillName"
      />

      <label for="billEntryAmount">Amount:</label>
      <input
        id="billEntryAmount"
        type="number"
        @focus="$event.target.select()"
        v-model.number="newBillAmount"
      />
      <button type="submit">Add</button>
    </div>
  </form>
</template>

<script>
import { mapState, mapActions } from 'vuex'

import Api from 'utils/api'

export default {
  data () {
    return {
      newBillAmount: null,
      newBillName: '',
      newBillPayPeriod: null,
    }
  },

  computed: mapState(['currentPayPeriod']),

  methods: {
    ...mapActions(['createBill']),

    addNewBill () {
      const payload = {
        "bill": {
          "name": this.newBillName,
          "amount": this.newBillAmount,
          "pay_period": this.newBillPayPeriod,
        }
      }

      this.createBill(payload).then(() => {
        this.newBillName = ''
        this.newBillAmount = null
        this.$refs.billEntryName.focus()
      })
    },
  },

  mounted () {
    this.newBillPayPeriod = this.currentPayPeriod
  }
}
</script>