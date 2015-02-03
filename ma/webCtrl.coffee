###
web.coffee
Copyright (C) 2014 ender xu <xuender@gmail.com>

Distributed under terms of the MIT license.
###
WebCtrl = ($scope, $log, $http, $modal, lss)->
  $scope.showLogin = ->
    i = $modal.open(
      templateUrl: 'partials/login.html'
      controller: LoginCtrl
      backdrop: 'static'
      keyboard: false
      size: 'sm'
    )
    i.result.then((user)->
      $scope.isLogin = true
      $scope.user = user
    ,->
      $log.info '取消'
    )
  $scope.alerts = []
  $scope.alert = (msg)->
    # 提示信息
    $scope.alerts.push(
      msg: msg
      type: 'success'
    )
  $scope.closeAlert = (index)->
    # 关闭
    $scope.alerts.splice(index, 1)
  $scope.confirm = (msg, oFunc, cFunc=null)->
    # 询问
    i = $modal.open(
      templateUrl: '/partials/confirm.html?v=2'
      controller: 'ConfirmCtrl'
      backdrop: 'static'
      keyboard: true
      size: 'sm'
      resolve:
        msg: ->
          msg
    )
    i.result.then((ok)->
      $log.debug '增加'
      $log.info ok
      oFunc()
    ,->
      if cFunc != null
        cFunc()
    )
  $scope.db = 'test'
  $scope.database = []
  $scope.collection = []
  $scope.readDb = ->
    $http.get('/database').success((msg)->
      $log.debug msg
      if msg.ok
        $scope.database = msg.data
    )
  $scope.$watch('db', (n, o)->
    $log.debug n
    $http.get("/collection/#{ n }").success((msg)->
      $log.debug msg
      if msg.ok
        $scope.collection= msg.data

    )
  )
  $scope.readDb()
  #if $scope.isLogin
  #  $http.get('/login').success((data)->
  #    $log.debug(data)
  #    $scope.isLogin = data.ok
  #    if data.ok
  #      $scope.user = data.data
  #      $log.debug('user id:%s', data.data.Id)
  #  )

WebCtrl.$inject = [
  '$scope'
  '$log'
  '$http'
  '$modal'
  'localStorageService'
]

