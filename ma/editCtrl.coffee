###
editCtrl.coffee
Copyright (C) 2015 ender xu <xuender@gmail.com>

Distributed under terms of the MIT license.
###

EditCtrl= ($scope, $log, $modal, $modalInstance, data)->
  $scope.data = data
  $scope.$watch('data', (n, o)->
    $log.debug 'watch', n
  )
  $scope.isObj = (d)->
    angular.isObject(d) and not angular.isArray(d)
  $scope.isArray = (d)->
    angular.isArray d
  $scope.ok = ->
    $log.debug 'ok'
    $modalInstance.close $scope.data
  $scope.cancel = ->
    $modalInstance.dismiss('cancel')
  $scope.edit = (k, v)->
    i = $modal.open(
      templateUrl: '/partials/edit.html?1'
      controller: 'EditCtrl'
      backdrop: 'static'
      keyboard: true
      size: 'lg'
      resolve:
        data: ->
          angular.copy v
    )
    i.result.then((n)->
      $log.debug n
      $scope.data[k] = n
    ,->
      $log.debug 'cancel'
    )

EditCtrl.$inject = [
  '$scope'
  '$log'
  '$modal'
  '$modalInstance'
  'data'
]

