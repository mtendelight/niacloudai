// app/javascript/packs/swiper.js
import Swiper from 'swiper/bundle';
import 'swiper/swiper-bundle.min.css';

document.addEventListener("turbolinks:load", () => {
  new Swiper('.swiper-container', {
    slidesPerView: 1,
    spaceBetween: 10,
    pagination: {
      el: '.swiper-pagination',
      clickable: true,
    },
    navigation: {
      nextEl: '.swiper-button-next',
      prevEl: '.swiper-button-prev',
    },
    loop: true,
  });
});
