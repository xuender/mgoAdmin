module.exports = (grunt)->
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-contrib-uglify')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-karma')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-cssmin')
  grunt.loadNpmTasks('grunt-coffeelint')
  grunt.loadNpmTasks('grunt-bumpx')

  grunt.initConfig(
    pkg:
      grunt.file.readJSON('package.json')
    clean:
      dist: [
        'dist'
        'public'
      ]
    bump:
      options:
        part: 'patch'
      files: [ 'package.json', 'bower.json']
    copy:
      dist:
        files: [
          {
            cwd: 'public'
            src: '**'
            dest: 'public'
            expand: true
          }
        ]
      ma:
        files: [
          cwd: 'ma'
          src: [
            '**/*.html'
          ]
          dest: 'public'
          filter: 'isFile'
          expand: true
        ]
      img:
        files: [
          cwd: 'img'
          src: [
            '*'
          ]
          dest: 'public/img'
          expand: true
        ]
      bootstrap:
        files: [
          cwd: 'bower_components/bootstrap/dist'
          src: [
            'css/*.min.css'
            'css/*.map'
            'fonts/*'
            'js/*.min.js'
            'js/*.map'
          ]
          dest: 'public'
          expand: true
        ]
      angular:
        files: [
          cwd: 'bower_components/angular/'
          src: [
            'angular.js'
            'angular.min.js'
            'angular.min.js.map'
          ]
          dest: 'public/js'
          expand: true
          filter: 'isFile'
        ]
      angularI18n:
        files: [
          cwd: 'bower_components/angular-i18n/'
          src: [
            'angular-locale_zh-cn.js'
          ]
          dest: 'public/js'
          expand: true
          filter: 'isFile'
        ]
      angular_route:
        files: [
          cwd: 'bower_components/angular-route/'
          src: [
            'angular-route.js'
            'angular-route.min.js'
            'angular-route.min.js.map'
          ]
          dest: 'public/js'
          expand: true
          filter: 'isFile'
        ]
      ng_table_js:
        files: [
          cwd: 'bower_components/ng-table/'
          src: [
            'ng-table.js'
            'ng-table.min.js'
            'ng-table.map'
          ]
          dest: 'public/js'
          expand: true
          filter: 'isFile'
        ]
      ng_table_css:
        files: [
          cwd: 'bower_components/ng-table/'
          src: [
            'ng-table.min.css'
          ]
          dest: 'public/css'
          expand: true
          filter: 'isFile'
        ]
      storage:
        files: [
          cwd: 'bower_components/angular-local-storage/'
          src: [
            'angular-local-storage.min.js'
          ]
          dest: 'public/js'
          expand: true
          filter: 'isFile'
        ]
      jquery:
        files: [
          cwd: 'bower_components/jquery/dist'
          src: [
            'jquery.min.js'
            'jquery.min.map'
          ]
          dest: 'public/js'
          expand: true
          filter: 'isFile'
        ]
      ui:
        files: [
          cwd: 'bower_components/angular-bootstrap'
          src: [
            'ui-bootstrap-tpls.min.js'
          ]
          dest: 'public/js'
          expand: true
          filter: 'isFile'
        ]
      fontCss:
        files: [
          cwd: 'bower_components/font-awesome/css'
          src: [
            'font-awesome.min.css'
          ]
          dest: 'public/css'
          expand: true
          filter: 'isFile'
        ]
      font:
        files: [
          cwd: 'bower_components/font-awesome/fonts'
          src: [
            '*'
          ]
          dest: 'public/fonts'
          expand: true
          filter: 'isFile'
        ]
      css:
        files: [
          cwd: 'ma'
          src: [
            '*.css'
          ]
          dest: 'public/css'
          expand: true
          filter: 'isFile'
        ]
    coffee:
      options:
        bare: true
      main:
        files:
          'public/js/index.min.js': [
            'ma/index.coffee'
            'ma/aboutCtrl.coffee'
            'ma/collectionCtrl.coffee'
            'ma/webCtrl.coffee'
          ]
    uglify:
      main:
        files:
          'dist/js/index.min.js': [
            'public/js/index.min.js'
          ]
    cssmin:
      toolbox:
        expand: true
        cwd: 'public/css/'
        src: ['*.css', '!*.min.css'],
        dest: 'dist/css/'
        #ext: '.min.css'
    watch:
      css:
        files: [
          'ma/*.css'
        ]
        tasks: ['copy:css']
      html:
        files: [
          'ma/**/*.html'
        ]
        tasks: [
          'copy:ma'
        ]
      coffee:
        files: [
          'ma/**/*.coffee'
        ]
        tasks: ['coffee']
    karma:
      options:
        configFile: 'karma.conf.js'
      dev:
        colors: true,
      travis:
        singleRun: true
        autoWatch: false
  )
  grunt.registerTask('test', ['karma'])
  grunt.registerTask('dev', [
    'clean'
    'copy'
    'coffee'
  ])
  grunt.registerTask('dist', [
    'dev'
    'copy:dist'
    'uglify'
  ])
  grunt.registerTask('deploy', [
    'bump'
    'dist'
  ])
  grunt.registerTask('travis', 'travis test', ['karma:travis'])
  grunt.registerTask('default', ['dist'])
