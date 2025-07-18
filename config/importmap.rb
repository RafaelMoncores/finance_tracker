pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

pin "@popperjs/core", to: "@popperjs/core/dist/umd/popper.js", preload: true
pin "bootstrap", to: "bootstrap/dist/js/bootstrap.min.js", preload: true
