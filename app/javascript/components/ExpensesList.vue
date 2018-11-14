<template>
  <div class="grid">
    <div class="col-12">
      <Table :items="expenses" item-type="expense" />
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex'

import Table from 'components/Table'

export default {
  components: {
    Table,
  },

  computed: mapState(['expenses']),
}
</script>