<template>
  <div>
    <div class="row justify-content-around">
      <div class="col-6">
        <h4>Welcome to Leftover Dough!</h4>

        <p>Let's start with your income settings...</p>
      </div>
    </div>

    <div class="row justify-content-around">
      <form @submit.prevent class="col-6">
        <label for="incomeFrequency">How often are you paid?</label>

        <select v-model="frequency" id="incomeFrequency" class="form-control">
          <option value="monthly">Once a month</option>
          <option value="semi_monthly_type1">Twice a month on the 1st and 15th</option>
          <option value="semi_monthly_type2">Twice a month on th 15th and last day</option>
          <option value="bi_weekly">Every other week</option>
          <option value="weekly">Every week</option>
        </select>
      </form>
    </div>

    <div class="row justify-content-around">
      <form @submit.prevent class="col-6" v-if="frequency == 'monthly'">
        <label for="specificFreqMonthly">On which day of the month?</label>

        <select v-model="specificFreqMonthly" id="specificFreqMonthly" class="form-control">
          <option
            v-for="n in 28"
            :key="n"
            :value="n"
          >{{ n }}</option>
          <option value="last">The last day</option>
        </select>
      </form>
    </div>

    <div class="row justify-content-around">
      <form @submit.prevent class="col-6" v-if="frequency.match(/weekly/)">
        <label for="specificFreqWeekly">On which day of the week?</label>

        <select v-model="specificFreqWeekly" id="specificFreqWeekly" class="form-control">
          <option value="monday">Monday</option>
          <option value="tuesday">Tuesday</option>
          <option value="wednesday">Wednesday</option>
          <option value="thursday">Thursday</option>
          <option value="friday">Friday</option>
        </select>
      </form>
    </div>

    <div class="row justify-content-around">
      <form @submit.prevent class="col-6" v-if="showAmountForm">
        <label for="incomePerPeriod">How much are you paid per paycheck?</label>

        <div class="form-group">
          <input
            id="incomePerPeriod"
            type="number"
            class="form-control"
            @focus="$event.target.select()"
            v-model="amount"
          />

          <button class="btn btn-primary">Save</button>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
  import { mapState, mapActions } from 'vuex'

  export default {
    data () {
      return {
        frequency: '',
        specificFreqMonthly: '',
        specificFreqWeekly: 'friday',
      }
    },

    computed: {
      ...mapState(['incomePerPeriod']),

      amount: {
        get() { return this.incomePerPeriod.amount },
        set(amount) { this.updateIncome({ amount }) }
      },

      showAmountForm () {
        if (!this.frequency)
          return false

        if (this.frequency == 'monthly' && !this.specificFreqMonthly)
          return false

        if (this.frequency.match(/weekly/) && !this.specificFreqWeekly)
          return false

        return true
      },
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