###
index.coffee
Copyright (C) 2015 ender xu <xuender@gmail.com>

Distributed under terms of the MIT license.
###
angular.module('ma', [
  'ngRoute'
  'ui.bootstrap'
  'LocalStorageModule'
  'ngTable'
]).config(['$routeProvider', ($routeProvider)->
  $routeProvider.
    when('/about',
      templateUrl: 'partials/about.html'
      controller: 'AboutCtrl'
    ).when('/collection/:db/:collection',
      templateUrl: 'partials/collection.html'
      controller: 'CollectionCtrl'
    ).otherwise({
      redirectTo: '/about'
    })
])

