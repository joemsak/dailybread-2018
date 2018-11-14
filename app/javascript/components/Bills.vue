<template>
  <div class="row">
    <div class="col-8">
      <BillsList />
    </div>

    <div class="col-4">
      <IncomeForm />
      <BillForm />
    </div>
  </div>
</template>

<script>
import IncomeForm from 'components/IncomeForm'
import BillForm from 'components/BillForm'
import BillsList from 'components/BillsList'

export default {
  components: {
    BillsList,
    IncomeForm,
    BillForm,
  },
}
</script>