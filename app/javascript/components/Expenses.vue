<template>
  <div class="row">
    <div class="col-12 order-2 col-md-8 order-md-1">
      <ExpensesList />
    </div>

    <div class="col-12 order-1 col-md-4 order-md-2">
      <ExpenseForm />
    </div>
  </div>
</template>

<script>
import ExpenseForm from 'components/ExpenseForm'
import ExpensesList from 'components/ExpensesList'

export default {
  components: {
    ExpensesList,
    ExpenseForm,
  },
}
</script>