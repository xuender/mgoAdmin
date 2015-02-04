###
collectionCtrl.coffee
Copyright (C) 2015 ender xu <xuender@gmail.com>

Distributed under terms of the MIT license.
###

CollectionCtrl = ($scope, $log, $http, $modal, $routeParams, ngTableParams, $filter)->
  $log.debug 'collection'
  $scope.db = $routeParams.db
  $scope.collection = $routeParams.collection
  $scope.names = []
  $scope.$watch('names', (n, o)->
    $log.debug n
    $scope.$$childHead.$columns = []
    i = 0
    for na in n
      $scope.$$childHead.$columns.push(
        title: ->
          na
        sortable: ->
          na
        id: i++
      )
  ,true)
  $scope.edit = (data)->
    i = $modal.open(
      templateUrl: '/partials/edit.html'
      controller: 'EditCtrl'
      backdrop: 'static'
      keyboard: true
      size: 'lg'
      resolve:
        data: ->
          angular.copy data
    )
    i.result.then((data)->
      $log.debug data
    ,->
      $log.debug 'cancel'
    )
  $scope.tableParams = new ngTableParams(
    page: 1
    count: 10
  ,
    getData: ($defer, params)->
      # 过滤
      $http.post('/collection',
        db: $scope.db
        collection: $scope.collection
        page: params.page()
        limit: params.count()
        sorting: params.orderBy()
        filter: params.filter()
      ).success((msg)->
        $log.debug msg
        if msg.ok
          params.total(msg.data.count)
          $scope.names = msg.data.names
          $defer.resolve(msg.data.results)
        else
          alert(msg.err)
      )
  )

CollectionCtrl.$inject = [
  '$scope'
  '$log'
  '$http'
  '$modal'
  '$routeParams'
  'ngTableParams'
  '$filter'
]

