'use strict';

var gulp = require('gulp');

var paths = gulp.paths;

var $ = require('gulp-load-plugins')();

gulp.task('scripts', function () {
  return gulp.src(paths.src + '/{app,components}/**/*.coffee')
    .pipe($.coffeelint({max_line_length: false}))
    .pipe($.coffeelint.reporter())
    .pipe($.coffee())
    .on('error', function handleError(err) {
      console.error(err.toString());
      this.emit('end');
    })
    .pipe(gulp.dest(paths.tmp + '/serve/'))
    .pipe($.size())
});
