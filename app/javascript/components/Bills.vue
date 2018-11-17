<template>
  <div class="row">
    <div class="col-12 order-2 col-md-8 order-md-1">
      <BillsList />
    </div>

    <div class="col-12 order-1 col-md-4 order-md-2">
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