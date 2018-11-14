<template>
  <form @submit.prevent>
    <label for="incomePerPeriod">Income per pay period</label>

    <div v-if="editingAmount" class="form-group">
      <input
        id="incomePerPeriod"
        type="number"
        class="form-control"
        @focus="$event.target.select()"
        v-model="amount"
      />

      <button @click.prevent="editingAmount = false" class="btn btn-primary">Save</button>
    </div>

    <p v-else>
      {{ amount | currency }}
      <a href="#" @click.prevent="editingAmount = true">edit</a>
    </p>
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

<style lang="scss" scoped>
input, select {
  width: 100%;
  padding: 0.5rem;
  font-size: 1.2rem;
  margin: 0.5rem 0 1rem;
}
</style>