// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).
// import "../css/app.css"

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

document.addEventListener('DOMContentLoaded', () => {
  initializeNavbar();
  initializeHideableCols();
  initializePenaltyButtons();
  initializePasswordReveal();
});

function initializeNavbar() {
  // Get all "navbar-burger" elements
  const $navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);

  // Add a click event on each of them
  $navbarBurgers.forEach( el => {
    el.addEventListener('click', () => {

      // Get the target from the "data-target" attribute
      const target = el.dataset.target;
      const $target = document.getElementById(target);

      // Toggle the "is-active" class on both the "navbar-burger" and the "navbar-menu"
      el.classList.toggle('is-active');
      $target.classList.toggle('is-active');

    });
  });
}

function initializeHideableCols() {
  const checkbox = document.querySelector('#toggle-hidable-cols');

  function setVisibility(target, show) {
    if (show) {
      target.classList.remove('hide-cols');
    } else {
      target.classList.add('hide-cols');
    }
  }

  if (checkbox) {
    const table = document.querySelector(checkbox.dataset.target);
    setVisibility(table, checkbox.checked);

    checkbox.addEventListener('change', (e) => {
      console.log(e.currentTarget.checked)
      setVisibility(table, e.currentTarget.checked);
    });
  }
}

function initializePenaltyButtons() {
  const increaseValue = function(el, step) {
    const targetValue = parseInt(el.value);
    const maxAttribute = el.getAttribute('max');

    if (maxAttribute && targetValue + step > parseInt(maxAttribute)) {
      return;
    }

    el.value = parseInt(el.value) + step;
  }

  const decreaseValue = function(el, step) {
    const targetValue = parseInt(el.value);
    const minAttribute = el.getAttribute('min');


    if (minAttribute && targetValue + step < parseInt(minAttribute)) {
      return;
    }

    el.value = parseInt(el.value) + step;
  }

  document.querySelectorAll("[data-penalty-target]").forEach(el => {
    el.addEventListener('click', (e) => {
      const target = document.getElementById(e.currentTarget.dataset.penaltyTarget);
      const directionAttribute = e.currentTarget.dataset.penaltyDirectionValue;

      if (!(directionAttribute && target)) { return; }

      const direction = parseInt(directionAttribute);
      const minAttribute = target.getAttribute('min');
      const step = target.getAttribute('step') ? parseInt(target.getAttribute('step')) : 1

      if (direction > 0) {
        increaseValue(target, step);
      } else {
        decreaseValue(target, step * -1);
      }
    })
  });
}

function initializePasswordReveal() {
  const eyeOpenIcon = 'ri-eye-fill';
  const eyeClosedIcon = 'ri-eye-close-fill';
  const passwordIcon = document.querySelector('#reveal-user-password i');
  const passwordInput = document.querySelector('#user_password');
  if (passwordIcon && passwordInput) {
    passwordIcon.addEventListener('click', (e) => {
      if (passwordIcon.classList.contains(eyeOpenIcon)) {
        passwordInput.type = 'text';
        passwordIcon.classList.add(eyeClosedIcon);
        passwordIcon.classList.remove(eyeOpenIcon);
      } else {
        passwordInput.type = 'password';
        passwordIcon.classList.add(eyeOpenIcon);
        passwordIcon.classList.remove(eyeClosedIcon);
      }
    });
  }
}