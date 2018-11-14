<template>
  <div class="row">
    <div class="col-8">
      <ExpensesList />
    </div>

    <div class="col-4">
      <IncomeForm />
      <ExpenseForm />
    </div>
  </div>
</template>

<script>
import IncomeForm from 'components/IncomeForm'
import ExpenseForm from 'components/ExpenseForm'
import ExpensesList from 'components/ExpensesList'

export default {
  components: {
    ExpensesList,
    IncomeForm,
    ExpenseForm,
  },
}
</script>