<template>
  <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top justify-content-between">
    <div>
      <router-link class="navbar-brand" to="/">&#127838; Leftover Dough</router-link>
    </div>

    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar" aria-controls="navbarNavAltMarkup" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbar">
      <div class="navbar-nav">
        <router-link
          to="/"
          exact-active-class="active"
          class="nav-item nav-link"
          exact
        >Expenses</router-link>

        <router-link
          to="/bills"
          active-class="active"
          class="nav-item nav-link"
        >Manage Bills</router-link>
      </div>
    </div>

    <div class="navbar-nav">
      <router-link
        to="/logout"
        class="nav-item nav-link"
      >Log out</router-link>
    </div>
  </nav>
</template>