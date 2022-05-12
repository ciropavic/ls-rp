<template>
  <div id="app">
    <!-- <hello-world name="2277" value="1234" /> -->
  <card></card>
  </div>
</template>

<script>
//  import HelloWorld from './components/HelloWorld';
 import Card from './components/Card';
// import Nui from './utils/Nui';

export default {
  name: 'app',
  components: {
     Card,
    // HelloWorld,
  },
  data() {
    return {};
  },
  destroyed() {
    window.removeEventListener('message', this.listener);
  },
  mounted() {
    this.listener = window.addEventListener(
      'message',
      event => {
        const item = event.data || event.detail;
        if (this[item.type]) {
          this[item.type](item);
        }
      },
      false,
    );
  },
  methods: {},
};
</script>

<style lang="scss">
/* Want nice animations? Check out https://github.com/asika32764/vue2-animate */
/* @import 'https://unpkg.com/vue2-animate/dist/vue2-animate.min.css'; */
</style>
