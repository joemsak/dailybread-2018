<template>
  <div v-if="currentSubscription.status === 'active'">
    Your subscription is active. Thank you!
    <p>Cancel link...</p>
  </div>

  <div v-else>
    <p>Your subscription is {{ currentSubscription.status }}</p>
    <button
      id="subscribe-btn"
      class="btn btn-primary"
      @click.prevent="openCheckout"
    >
      Subscribe Today
    </button>
  </div>
</template>

<script>
import { mapState } from 'vuex'

import Api from 'utils/api'

export default {
  computed: {
    ...mapState(['currentEmail', 'currentSubscription']),

    handler () {
      return StripeCheckout.configure({
        key: "pk_test_6bYuHRe4zpv5pT3oqzm0cmkU",
        image: 'https://stripe.com/img/documentation/checkout/marketplace.png',
        locale: 'auto',
        token: token => {
          Api.post('/checkout', { stripeToken: token.id }).then(() => {
            this.$router.push('/')
          })
        }
      })
    },
  },

  methods: {
    openCheckout () {
      this.handler.open({
        name: "Leftover Dough",
        description: "Monthly Subscription ($4 per month)",
        panelLabel: "Subscribe now for {{amount}}",
        amount: 400,
        email: this.currentEmail,
        allowRememberMe: false,
        zipCode: true,
      })
    },
  },

  mounted () {
    let checkoutScript = document.createElement("script")
    checkoutScript.setAttribute("src", "https://checkout.stripe.com/checkout.js")
    document.head.appendChild(checkoutScript)

    window.addEventListener('popstate', function() {
      this.handler.close()
    })
  }
}
</script>