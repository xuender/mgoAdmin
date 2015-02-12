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
    $log.debug $scope.$$childHead.$columns
    ret = (i)->
      m = n[i]
      ->
        m
    $scope.$$childHead.$columns = []
    for i in [0..n.length-1]
      $scope.$$childHead.$columns.push(
        id: i
        filter: ->
          False
        title: ret(i)
        sortable: ret(i)
        show: ->
          true
      )
    $scope.$$childHead.$columns.push(
      id: n.length
      filter: ->
        False
      title: ->
        ''
      sortable: ->
        ''
      show: ->
        true
    )
    $log.debug $scope.$$childHead.$columns
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
      $http.put("/collection/#{ $scope.db }/#{ $scope.collection }",
        ok: true
        data: data
      ).success((msg)->
        $log.debug msg
        if msg.ok
          $scope.tableParams.reload()
        else
          alert(msg.err)
      )
    ,->
      $log.debug 'cancel'
    )
  $scope.show = (d)->
    if angular.isObject(d) and not angular.isArray(d)
      return 'object'
    if angular.isArray(d)
      return 'array'
    d
  $scope.tableParams = new ngTableParams(
    page: 1
    count: 10
  ,
    getData: ($defer, params)->
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

