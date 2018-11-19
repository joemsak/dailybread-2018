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
        <label for="incomePayrollType">How often are you paid?</label>

        <select v-model="payrollType" id="incomePayrollType" class="form-control">
          <option value="monthly">Once a month</option>
          <option value="semi_monthly_type1">Twice a month on the 1st and 15th</option>
          <option value="semi_monthly_type2">Twice a month on th 15th and last day</option>
          <option value="bi_weekly">Every other week</option>
          <option value="weekly">Every week</option>
        </select>
      </form>
    </div>

    <div class="row justify-content-around">
      <form @submit.prevent class="col-6" v-if="payrollType == 'monthly'">
        <label for="specificMonthly">On which day of the month?</label>

        <select v-model="specificMonthly" id="specificMonthly" class="form-control">
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
      <form @submit.prevent class="col-6" v-if="payrollType.match(/weekly/)">
        <label for="specificWeekly">On which day of the week?</label>

        <select v-model="specificWeekly" id="specificWeekly" class="form-control">
          <option value="monday">Monday</option>
          <option value="tuesday">Tuesday</option>
          <option value="wednesday">Wednesday</option>
          <option value="thursday">Thursday</option>
          <option value="friday">Friday</option>
        </select>
      </form>
    </div>

    <div class="row justify-content-around">
      <form @submit.prevent="saveIncome" class="col-6" v-if="showAmountForm">
        <label for="incomePerPeriod">How much are you paid per paycheck?</label>

        <div class="form-group">
          <input
            id="incomePerPeriod"
            type="number"
            class="form-control"
            v-model="amount"
          />

          <button type="submit" class="btn btn-primary">Save</button>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
  import { mapState, mapActions } from 'vuex'

  export default {
    computed: {
      ...mapState(['incomePerPeriod']),

      showAmountForm () {
        if (!this.payrollType)
          return false

        if (this.payrollType == 'monthly' && !this.specificMonthly)
          return false

        if (this.payrollType.match(/weekly/) && !this.specificWeekly)
          return false

        return true
      },

      amount: {
        get () { return this.incomePerPeriod.amount },
        set (value) { Vue.set(this.$store.state.incomePerPeriod, 'amount', value) }
      },

      payrollType: {
        get () { return this.incomePerPeriod.payrollType },
        set (value) { Vue.set(this.$store.state.incomePerPeriod, 'payrollType', value) }
      },

      specificMonthly: {
        get () { return this.incomePerPeriod.specificMonthly },
        set (value) { Vue.set(this.$store.state.incomePerPeriod, 'specificMonthly', value) }
      },

      specificWeekly: {
        get () { return this.incomePerPeriod.specificWeekly },
        set (value) { Vue.set(this.$store.state.incomePerPeriod, 'specificWeekly', value) }
      },
    },

    methods: {
      ...mapActions(['updateIncome']),

      saveIncome () {
        this.updateIncome({
          amount: this.amount,
          payrollType: this.payrollType,
          specificMonthly: this.specificMonthly,
          specificWeekly: this.specificWeekly,
        })
      },
    },
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