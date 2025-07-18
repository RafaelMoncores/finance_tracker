// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import * as Popper from "@popperjs/core";
window.Popper = Popper;

import "bootstrap"

document.addEventListener("turbo:load", function() {
  const closeButtons = document.querySelectorAll('.message .close');

  closeButtons.forEach(button => {
    button.addEventListener('click', function() {
      const message = this.closest('.message');
      if (message) {
        // Adiciona uma classe para animar o fade-out e depois remover
        message.style.opacity = 0;
        message.style.transition = 'opacity 0.5s ease-out';

        // Remove a mensagem do DOM após a transição
        setTimeout(() => {
          message.remove();
        }, 500); // Tempo igual à duração da transição
      }
    });
  });
});