'use strict';

var path = require('path')
var gulp = require('gulp');
var paths = gulp.paths;
var $ = require('gulp-load-plugins')();
var wiredep = require('wiredep').stream;

gulp.task('inject', ['styles', 'scripts'], function () {

  var injectStyles = gulp.src([
    paths.tmp + '/serve/{app,components}/**/*.css',
    '!' + paths.tmp + '/serve/app/vendor.css'
  ], { read: false });

  var injectScripts = gulp.src([
    '{' + paths.src + ',' + paths.tmp + '/serve}/{app,components}/**/*.js',
    '!' + paths.src + '/{app,components}/**/*.spec.js',
    '!' + paths.src + '/{app,components}/**/*.mock.js'
  ]).pipe($.angularFilesort());

  var injectOptions = {
    ignorePath: [paths.src, paths.tmp + '/serve'],
    addRootSlash: false
  };

  var wiredepOptions = {
    directory: 'bower_components',
    exclude: [/bootstrap\.js/, /bootstrap\.css/, /bootstrap\.css/, /foundation\.css/]
  };

  return gulp.src(paths.src + '/*.html')
    .pipe($.inject(injectStyles, injectOptions))
    .pipe($.inject(injectScripts, injectOptions))
    .pipe(wiredep(wiredepOptions))
    .pipe(gulp.dest(paths.tmp + '/serve'));

});


gulp.task('languages', function () {
  return gulp.src('./src/app/index.constant.coffee')
    .pipe($.inject(gulp.src('./src/assets/json/??.json', {read: false}), {
      starttag: '# inject:languages',
      endtag: '# endinject',
      transform: function (filepath, file, i, length) {
        return '"' + path.basename(filepath, '.json') + '"';
      }
    }))
    .pipe(gulp.dest('./src/app/'));
});
