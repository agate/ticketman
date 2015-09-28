var gulp = require('gulp');
var addsrc = require('gulp-add-src');
var coffee = require('gulp-coffee');
var sass = require('gulp-ruby-sass');
var jade = require('gulp-jade');
var concat = require('gulp-concat');
var uglify = require('gulp-uglify');
var imagemin = require('gulp-imagemin');
var sourcemaps = require('gulp-sourcemaps');
var autoprefixer = require('gulp-autoprefixer');
var minifycss = require('gulp-minify-css');
var del = require('del');

var PATHS = {
  images: {
    src: 'src/assets/images/**/*',
    dest: 'dest/unpacked/images'
  },

  scripts: {
    src: [
      'src/assets/javascripts/*.coffee'
    ],
    lib: [
      'bower_components/jquery/dist/jquery.js',
      'bower_components/underscore/underscore.js',
      'bower_components/backbone/backbone.js',
      'bower_components/octokat/dist/octokat.js',
      'lib/javascripts/backbone.chromestorage.js',
      'lib/javascripts/backbone.localstorage.js',
    ],
    background: [
      'src/assets/javascripts/storage.coffee',
      'src/background.coffee',
    ],
    backgroundlib: [
      'bower_components/octokat/dist/octokat.js',
    ],
    dest: 'dest/unpacked/javascripts'
  },

  styles: {
    sass: 'src/assets/stylesheets',
    lib: [
      'bower_components/font-awesome/css/font-awesome.css'
    ],
    dest: 'dest/unpacked/stylesheets'
  },

  fonts: {
    src: [
      'bower_components/font-awesome/fonts/*',
      'src/assets/fonts/*'
      
    ],
    dest: 'dest/unpacked/fonts'
  },

  views: {
    src: 'src/views/**/*.jade',
    dest: 'dest/unpacked'
  },

  manifest: {
    src: 'src/manifest.json',
    dest: 'dest/unpacked'
  }
};

// Not all tasks need to use streams
// A gulpfile is just another node program and you can use all packages available on npm
gulp.task('clean', function(cb) {
  // You can use multiple globbing patterns as you would with `gulp.src`
  del(['build'], cb);
});

gulp.task('scripts', ['clean'], function() {
  // Minify and copy all JavaScript (except vendor scripts)
  // with sourcemaps all the way down
  return gulp
  .src(PATHS.scripts.src)
  .pipe(coffee())
  .pipe(addsrc.prepend(PATHS.scripts.lib))
  // .pipe(uglify())
  .pipe(concat('all.min.js'))
  .pipe(sourcemaps.write())
  .pipe(gulp.dest(PATHS.scripts.dest));
});

gulp.task('styles', function() {
  return sass(PATHS.styles.sass, {style: 'expanded', sourcemap: true})
  .pipe(addsrc.prepend(PATHS.styles.lib))
  .pipe(autoprefixer('last 2 version'))
  // .pipe(minifycss())
  .pipe(concat('all.min.css'))
  .pipe(sourcemaps.write())
  .pipe(gulp.dest(PATHS.styles.dest));
});

// Copy all static images
gulp.task('images', ['clean'], function() {
  return gulp
  .src(PATHS.images.src)
  .pipe(imagemin({optimizationLevel: 5})) // Pass in options to the task
  .pipe(gulp.dest(PATHS.images.dest));
});

gulp.task('fonts', function() {
  return gulp
  .src(PATHS.fonts.src)
  .pipe(gulp.dest(PATHS.fonts.dest));
});

gulp.task('views', function() {
  var YOUR_LOCALS = {};

  return gulp
  .src(PATHS.views.src)
  .pipe(jade({ locals: YOUR_LOCALS }))
  .pipe(gulp.dest(PATHS.views.dest));
});

gulp.task('background', function() {
  return gulp
  .src(PATHS.scripts.background)
  .pipe(coffee())
  .pipe(addsrc.prepend(PATHS.scripts.backgroundlib))
  // .pipe(uglify())
  .pipe(concat('background.min.js'))
  .pipe(sourcemaps.write())
  .pipe(gulp.dest(PATHS.scripts.dest));
});

gulp.task('manifest', function() {
  return gulp
  .src(PATHS.manifest.src)
  .pipe(gulp.dest(PATHS.manifest.dest));
});

// Rerun the task when a file changes
gulp.task('watch', function() {
  gulp.watch(PATHS.manifest.src, ['manifest']);
  gulp.watch(PATHS.images.src, ['images']);
  gulp.watch(PATHS.scripts.src, ['scripts']);
  gulp.watch(PATHS.scripts.background, ['background']);
  gulp.watch(PATHS.styles.sass + '/**/*', ['styles']);
  gulp.watch(PATHS.views.src, ['views']);
});

// The default task (called when you run `gulp` from cli)
gulp.task('default', [
  'watch',
  'manifest',
  'background',
  'images',
  'fonts',
  'scripts',
  'styles',
  'views',
]);
