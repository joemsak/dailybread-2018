<template>
  <form @submit.prevent>
    <label for="incomePerPeriod">Income per pay period</label>

    <div v-if="editingAmount">
      <input
        id="incomePerPeriod"
        type="number"
        @focus="$event.target.select()"
        v-model="amount"
      />

      <button @click.prevent="editingAmount = false">Save</button>
    </div>

    <div v-else>
      {{ amount }}
      <a href="#" @click.prevent="editingAmount = true">edit</a>
    </div>
  </form>
</template>

<script>
  import { mapState, mapActions } from 'vuex'

  export default {
    data () {
      return {
        editingAmount: false,
      }
    },

    computed: {
      ...mapState(['incomePerPeriod']),

      amount: {
        get() { return this.incomePerPeriod.amount },
        set(amount) { this.updateIncome({ amount }) }
      }
    },

    methods: mapActions(['updateIncome']),
  }
</script>