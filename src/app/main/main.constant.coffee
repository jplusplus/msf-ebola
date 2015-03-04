angular.module "msfEbola"
  .constant "main",
    start: new Date(2014, 2, 17)
    duration: 35*1000
    months: [ 'january', 'february', 'march', 'april', 'may', 'june', 'july',
              'august', 'september', 'october', 'november', 'december', ]
    iconCte:
      type: 'div'
      className: 'main__map__center main__map__center--cte'
      iconSize: [20, 20]
      popupAnchor:  [0, 0]
      template: _.template [
        '<div class="main__map__center__wrapper" data-name="<%- name %>" data-open="<%- open %>">'
          '<i class="main__map__center__marker fa fa-dot-circle-o"></i>'
          '<div class="main__map__center__staff"><%= staff %></div>'
          '<div class="main__map__center__admitted"><%= admitted %></div>'
        '</div>'
      ].join("")
    iconSupport:
      type: 'div'
      className: 'main__map__center main__map__center--support'
      iconSize: [30, 30]
      popupAnchor:  [0, 0]
      html: '<i class="main__map__center__marker fa fa-circle"></i>'
    centerPopup: '<div ng-include="\'app/main/popup/popup.html\'"></div>'
    settings:
      maxbounds:
        southWest: L.latLng(90, 180)
        northEast: L.latLng(-90, -180)
      center:
        zoom: 7
        lat: 8.460555
        lng: -11.779889
      defaults:
        maxZoom: 7
        minZoom: 7
        zoomControl: no
        scrollWheelZoom: no
      tiles:
        name: 'CartoDB.Positron'
        type: 'sxyz'
        url: "http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png"
        options:
          attribution: [
            '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
            '&copy; <a href="http://cartodb.com/attributions">CartoDB</a>'
          ].join " "
          subdomains: 'abcd'
          minZoom: 0
          maxZoom: 18
          continuousWorld: no
          noWrap: yes
