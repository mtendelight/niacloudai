# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "chartkick", to: "chartkick.js"
pin "Chart.bundle", to: "Chart.bundle.js"
pin "chart.js", to: "chart.js"
pin "chartkick", to: "chartkick"
pin "jquery", to: "https://ga.jspm.io/npm:jquery@3.6.0/dist/jquery.js", preload: true
pin "select2", to: "https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"
pin "utils"
pin "quagga", to: "https://cdn.skypack.dev/quagga"
pin "ahoy", to: "ahoy.js"
pin_all_from "app/javascript/custom", under: "custom"
pin "@fullcalendar/core", to: "https://ga.jspm.io/npm:@fullcalendar/core@6.1.8/index.global.js"
pin "@fullcalendar/daygrid", to: "https://ga.jspm.io/npm:@fullcalendar/daygrid@6.1.8/index.global.js"
pin "@fullcalendar/interaction", to: "https://ga.jspm.io/npm:@fullcalendar/interaction@6.1.8/index.global.js"
pin "trix" # @2.1.19
pin "@rails/actiontext", to: "@rails--actiontext.js" # @8.1.300
pin "trix"
pin "@rails/actiontext", to: "actiontext.esm.js"
