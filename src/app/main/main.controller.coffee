angular.module "msfEbola"
  .controller "MainCtrl", ($scope) ->
    # Create 52 slots for each week
    $scope.weeks = new Array(52)
    # Populate week's slot with fake data
    for week, i in $scope.weeks
      victims = ~~(50 * Math.random())
      $scope.weeks[i] = new Array(victims)
    # Map's settings
    $scope.settings =
      maxbounds:
        southWest: L.latLng(90, 180)
        northEast: L.latLng(-90, -180)
      center:
        zoom: 3
        lat: 8.460555
        lng: -11.779889
      defaults:
        zoomControl: no
        scrollWheelZoom: no
      tiles:
        name: 'CartoDB.Positron'
        type: 'sxyz'
        url: "http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png"
        options:
          attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> &copy; <a href="http://cartodb.com/attributions">CartoDB</a>'
          subdomains: 'abcd'
          minZoom: 0
          maxZoom: 18
          continuousWorld: no
          noWrap: yes
