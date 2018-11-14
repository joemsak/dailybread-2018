<template>
  <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
    <router-link class="navbar-brand" to="/">&#127838; Dailybread</router-link>

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
  </nav>
</template>