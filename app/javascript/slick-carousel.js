import $ from 'jquery';
import 'slick-carousel/slick/slick.js';
import 'slick-carousel/slick/slick.css';

$(document).ready(function() {
  var myCarousel = $('.slick-carouselw');

  myCarousel.on('beforeChange', function(event, slick, currentSlide, nextSlide) {
    var currentVideo = $('.slick-current').find('video')[0];
    currentVideo.pause();
  });

  myCarousel.on('afterChange', function(event, slick, currentSlide, nextSlide) {
    updateSlideNumber(currentSlide);
  });

  function updateSlideNumber(currentSlide) {
    var slideNumberElement = $('.slick-current .slide-number');
    if (slideNumberElement.length) {
      var slideCount = myCarousel.slick('getSlick').slideCount;
      var uniqueSlideIndex = currentSlide + 1;
      slideNumberElement.text(uniqueSlideIndex + '/' + slideCount);
    }
  }

  updateSlideNumber(0); // Set initial slide number on page load

  myCarousel.slick({
    prevArrow: $('.slick-prev'),
    nextArrow: $('.slick-next'),
    slidesToShow: 1,
    infinite: false,
    slidesToScroll: 1,
    autoplay: false,
    lazyLoad: 'progressive',
  });
});

