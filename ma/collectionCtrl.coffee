###
collectionCtrl.coffee
Copyright (C) 2015 ender xu <xuender@gmail.com>

Distributed under terms of the MIT license.
###

CollectionCtrl = ($scope, $log, $http, $routeParams, ngTableParams, $filter)->
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
          $log.debug $scope.$$childHead.$columns
          na
        sortable: ->
          na
        id: i++
      )
  ,true)
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
  '$routeParams'
  'ngTableParams'
  '$filter'
]

