<template>
  <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top justify-content-between">
    <div>
      <router-link class="navbar-brand" to="/">&#127838; Leftover Dough</router-link>
    </div>

    <button
      class="navbar-toggler"
      type="button"
      data-toggle="collapse"
      data-target="#navbar"
      aria-controls="navbar"
      aria-expanded="false"
      aria-label="Toggle navigation"
      @click="handleCollapseElementClick"
    >
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbar">
      <div class="navbar-nav">
        <router-link
          to="/"
          exact-active-class="active"
          class="nav-item nav-link"
          exact
        >Current Period Expenses</router-link>

        <router-link
          to="/bills"
          active-class="active"
          class="nav-item nav-link"
        >Recurring Bills</router-link>

        <router-link
          to="/income"
          active-class="active"
          class="nav-item nav-link"
        >Income Settings</router-link>

        <a
          href="/checkout/new"
          class="nav-item nav-link"
        >Subscribe</a>

        <router-link
          to="/logout"
          class="nav-item nav-link"
        >Log out</router-link>
      </div>
    </div>
  </nav>
</template>

<script>
export default {
  data () {
    return {
      CLASS_SHOW: 'show',
      CLASS_COLLAPSE: 'collapse',
      CLASS_COLLAPSING: 'collapsing',
      CLASS_COLLAPSED: 'collapsed',
      ANIMATION_TIME: 350, // 0.35s
    }
  },

  methods: {
    handleCollapseElementClick (e) {
      let el = e.currentTarget;
      let collapseTargetId = el.dataset.target || el.href || null;

      if (collapseTargetId) {
        let targetEl = document.querySelector(collapseTargetId);
        let isShown = targetEl.classList.contains(this.CLASS_SHOW) || targetEl.classList.contains(this.CLASS_COLLAPSING);

        if(!isShown) {
          targetEl.classList.remove(this.CLASS_COLLAPSE);
          targetEl.classList.add(this.CLASS_COLLAPSING);
          targetEl.style.height = 0
          targetEl.classList.remove(this.CLASS_COLLAPSED);

          setTimeout(() => {
            targetEl.classList.remove(this.CLASS_COLLAPSING);
            targetEl.classList.add(this.CLASS_COLLAPSE, this.CLASS_SHOW);
            targetEl.style.height = '';
          }, this.ANIMATION_TIME)

          targetEl.style.height = targetEl.scrollHeight + 'px';
        } else {
          targetEl.style.height = `${targetEl.getBoundingClientRect().height}px`
          targetEl.offsetHeight; // force reflow
          targetEl.classList.add(this.CLASS_COLLAPSING);
          targetEl.classList.remove(this.CLASS_COLLAPSE, this.CLASS_SHOW);
          targetEl.style.height = '';

          setTimeout(() => {
            targetEl.classList.remove(this.CLASS_COLLAPSING);
            targetEl.classList.add(this.CLASS_COLLAPSE);
          }, this.ANIMATION_TIME)
        }
      }
    },
  },
}
</script>