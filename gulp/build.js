'use strict';

var gulp = require('gulp');
var    _ = require('lodash');

var paths = gulp.paths;

var $ = require('gulp-load-plugins')({
  pattern: ['gulp-*', 'main-bower-files', 'uglify-save-license', 'del']
});

gulp.task('partials', ['markups'], function () {
  return gulp.src([
    paths.tmp + '/serve/{app,components}/**/*.html',
    paths.tmp + '/{app,components}/**/*.html'
  ])
    .pipe($.minifyHtml({
      empty: true,
      spare: true,
      quotes: true
    }))
    .pipe($.angularTemplatecache('templateCacheHtml.js', {
      module: 'msfEbola'
    }))
    .pipe(gulp.dest(paths.tmp + '/partials/'));
});

gulp.task('html', ['inject', 'partials'], function () {
  var partialsInjectFile = gulp.src(paths.tmp + '/partials/*.js', { read: false });
  var partialsInjectOptions = {
    starttag: '<!-- inject:partials -->',
    ignorePath: paths.tmp + '/partials',
    addRootSlash: false
  };

  var htmlFilter = $.filter('*.html');
  var jsFilter = $.filter('**/*.js');
  var cssFilter = $.filter('**/*.css');
  var assets;

  return gulp.src(paths.tmp + '/serve/*.html')
    .pipe($.inject(partialsInjectFile, partialsInjectOptions))
    .pipe(assets = $.useref.assets())
    .pipe($.rev())
    .pipe(jsFilter)
    .pipe($.ngAnnotate())
    .pipe($.uglify({preserveComments: $.uglifySaveLicense}))
    .pipe(jsFilter.restore())
    .pipe(cssFilter)
    .pipe($.replace('../bootstrap/fonts', 'fonts'))
    .pipe($.csso())
    .pipe(cssFilter.restore())
    .pipe(assets.restore())
    .pipe($.useref())
    .pipe($.revReplace())
    .pipe(htmlFilter)
    .pipe($.minifyHtml({
      empty: true,
      spare: true,
      quotes: true
    }))
    .pipe(htmlFilter.restore())
    .pipe(gulp.dest(paths.dist + '/'))
    .pipe($.size({ title: paths.dist + '/', showFiles: true }));
});

gulp.task('images', function () {
  return gulp.src(paths.src + '/assets/images/**/*')
    .pipe(gulp.dest(paths.dist + '/assets/images/'));
});

gulp.task('fonts', function () {
  return gulp.src($.mainBowerFiles())
    .pipe($.filter('**/*.{eot,svg,ttf,woff}'))
    .pipe($.flatten())
    .pipe(gulp.dest(paths.dist + '/fonts/'));
});

gulp.task('misc', function () {
  return gulp.src(paths.src + '/**/*.ico')
    .pipe(gulp.dest(paths.dist + '/'));
});


gulp.task('assets:csv', function(){
  return gulp.src(['src/assets/csv/*.csv'])
    .pipe($.convert({ from: 'csv', to: 'json' }))
    .pipe(gulp.dest(paths.tmp + '/serve/assets/json/'))
    .pipe(gulp.dest(paths.dist + '/assets/json/'));
});

gulp.task('assets:copy', function() {
  return gulp.src(['src/assets/{fonts,json}/**/*'])
    .pipe(gulp.dest(paths.dist + '/assets/'))
    .pipe(gulp.dest(paths.tmp + '/serve/assets/'));
});

gulp.task('assets:days', ['assets:copy'], function(){
  return gulp.src(['src/assets/json/days.json'])
    .pipe($.jsonEditor(function(days) {
      // Transform the days to an array
      days = _.reduce(days, function(array, day, timestamp) {
        day.timestamp = timestamp;
        array.push(day);
        return array;
      }, []);

      return _.sortBy(days, 'day');
    }))
    .pipe(gulp.dest(paths.dist + '/assets/json/'))
    .pipe(gulp.dest(paths.tmp + '/serve/assets/json/'));
});

gulp.task('assets:aggregation', ['assets:days'], function(){
  return gulp.src([paths.dist + '/assets/json/days.json'])
    .pipe($.jsonEditor(function(days) {

      var hash = {
        weeks: {},
        weeksCount: 0
      };

      for (var i = 0, len = days.length; i < len; i++) {
        var data = days[i];
        if (!(data.day % 7)) {
          ++hash.weeksCount;
          data.cases = 0;
          data.places = [];
          var ref = data.regional_data;
          for( var key in ref) {
            var zone = ref[key];
            if (zone.weekly_new_cases != null) {
              data.cases += Math.max(1 * zone.weekly_new_cases, 0);
              zone.code = key;
              data.places.push(zone);
            }
          }
          var victims = Math.max(0, Math.ceil(data.cases / 10));
          data.victims = new Array(victims);
          data.start = data.timestamp * 1000
          data.end = data.timestamp * 1000 + 7 * 24 * 60 * 60 * 1000
          hash.weeks[data.timestamp] = data;
        }
      }


      hash.start = _.min(hash.weeks, "start").start
      hash.end =   _.max(hash.weeks, "end").end

      return hash;
    }))
    .pipe($.rename('aggregation.json'))
    .pipe(gulp.dest(paths.dist + '/assets/json/'))
    .pipe(gulp.dest(paths.tmp + '/serve/assets/json/'));
});


gulp.task('assets:centers', function(){
  return gulp.src(['src/assets/json/centers.json'])
    .pipe($.jsonEditor(function(centers) {
      return _.filter(centers, {type: 'CTE'})
    }))
    .pipe(gulp.dest(paths.dist + '/assets/json/'))
    .pipe(gulp.dest(paths.tmp + '/serve/assets/json/'));
});


gulp.task('assets', ['assets:csv', 'assets:aggregation', 'assets:centers']);


gulp.task('clean', function (done) {
  $.del([paths.dist + '/', paths.tmp + '/'], done);
});

gulp.task('build', ['html', 'images', 'fonts', 'misc', 'assets']);

gulp.task('gh-pages', ['build'], function() {
  gulp.src("./dist/**/*").pipe($.ghPages());
});
