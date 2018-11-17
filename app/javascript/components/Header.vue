<template>
  <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top justify-content-between">
    <div>
      <router-link class="navbar-brand" to="/">&#127838; Leftover Dough</router-link>
    </div>

    <div id="navbar">
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
          to="/logout"
          class="nav-item nav-link"
        >Log out</router-link>
      </div>
    </div>
  </nav>
</template>