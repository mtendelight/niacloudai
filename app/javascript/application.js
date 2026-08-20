// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
//= require chartkick
//= require jquery
//= require select2-full
//= require Chart.bundle
//= require bootstrap
//= require ahoy
//= require registrations
//= require jquery_ujs
//= require custom/companion 
//= require select2
//= require select2_locale_pt-BR
//= require_tree .
// application.js or equivalent
// Make sure jQuery is loaded (if not using Rails UJS)
// Uncomment if needed
////= require jquery

//= require jquery
import Rails from "@rails/ujs";

Rails.start();
import "./calendar"
import "@hotwired/turbo-rails"
import { Turbo } from "@hotwired/turbo-rails"
import "chartkick/chart.js"
import "controllers"
import * as bootstrap from "bootstrap"
import "trix"
import "@rails/actiontext"

import * as bootstrap from "bootstrap"
Turbo.session.drive = true
import 'slick-carousel';
import Html5Qrcode from "html5-qrcode";
import Quagga from 'quagga';
import "custom/companion"
import 'slick-carousel/slick/slick.css';
import 'slick-carousel/slick/slick-theme.css';
import './lazy_load';
import "jquery";
import 'select2';
import 'select2/dist/css/select2.min.css';
import Rails from "@rails/ujs"
Rails.start()
import select2 from "select2";
import "@hotwired/turbo-rails"
import "controllers"
import "chartkick"
import "Chart.bundle"
import $ from 'jquery';
require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("jquery")
require("bootstrap")
require("chartkick")
require("chart.js")
require("ahoy")
require("select2")
import 'select2';
import 'select2/dist/css/select2.css';
import Swiper from 'swiper/swiper-bundle.min';
import 'bootstrap/dist/js/bootstrap'
import ahoy from "ahoy.js";
import 'trix';
import '@rails/actiontext';
import "chartkick/chart.js"

import Chartkick from "chartkick";
import Chart from "chart.js/auto";

import { Turbo } from "@hotwired/turbo-rails"
import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"
import {Chart} from 'chart.js';
import ChartDataLabels from 'chartjs-plugin-datalabels';

// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

//= require commontator/application
//= require math_input 




require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("jquery")
require("bootstrap")
require("chartkick")
require("chart.js")
require("trix")
require("@rails/actiontext")

// ======================================
// Service Worker Registration
// ======================================

if ("serviceWorker" in navigator) {
  window.addEventListener("load", () => {
    navigator.serviceWorker.register("/service-worker.js")
      .then((registration) => {
        console.log("Service Worker registered");

        // Check for updates every minute
        setInterval(() => {
          registration.update();
        }, 60000);

        registration.addEventListener("updatefound", () => {
          const worker = registration.installing;
          if (!worker) return;

          worker.addEventListener("statechange", () => {
            if (
              worker.state === "installed" &&
              navigator.serviceWorker.controller
            ) {
              // Activate immediately
              worker.postMessage({ type: "SKIP_WAITING" });

              // Refresh to load latest assets
              window.location.reload();
            }
          });
        });
      })
      .catch((err) => {
        console.error("Service Worker registration failed:", err);
      });
  });

  navigator.serviceWorker.addEventListener("controllerchange", () => {
    window.location.reload();
  });
}

Chart.defaults.font.size = 16;
let chart = new Chart(ctx, {
    type: 'line',
    data: data,
    options: {
        plugins: {
            legend: {
                labels: {
                    // This more specific font property overrides the global property
                    font: {
                        size: 14
                    }
                }
            }
        }
    }
});
 


$(function() {
  $.ajax({
    url: "/carsales",
    success: function (html) {
      $("#content").append(html);
    }
  });
});



import ahoy from "ahoy.js";


$(document).ready(function() {
  $('#myCarousel').carousel({
    interval: 1000
  });
});





$('#sidebar [data-toggle=collapse]').prop('disabled', false); 




window.addEventListener('turbolinks:load', () => {
  $('.select2').select2({
    tags: true,
    theme: bootstrap,
    tokenSeparators: [',', ' ']
  });
})



