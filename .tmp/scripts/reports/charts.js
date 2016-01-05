(function() {
  'use strict';
  var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  angular.module('smartRegisterApp').directive('barChart', [
    '$filter', '$window', function($filter, $window) {
      return {
        template: '<figure class="bar-chart"><figcaption ng-transclude></figcaption><div class="chart"></div></figure>',
        replace: true,
        restrict: 'E',
        transclude: true,
        link: function($scope, $element, $attrs) {
          var categoryAxis, getLabels, getValues, plot, plotOptions, redraw, valueAxis;
          $element.find('.chart').attr('id', $attrs.id);
          getLabels = function(sources) {
            var categories, category, point, source, _i, _j, _len, _len1;
            categories = [];
            if (sources != null) {
              for (_i = 0, _len = sources.length; _i < _len; _i++) {
                source = sources[_i];
                for (_j = 0, _len1 = source.length; _j < _len1; _j++) {
                  point = source[_j];
                  category = eval("point." + $attrs.labels);
                  if (__indexOf.call(categories, category) < 0) {
                    categories.push(category);
                  }
                }
              }
            }
            return categories;
          };
          getValues = function(sources, labels) {
            var data, index, point, series, source, _i, _j, _len, _len1;
            series = [];
            if (sources != null) {
              for (_i = 0, _len = sources.length; _i < _len; _i++) {
                source = sources[_i];
                data = (function() {
                  var _j, _ref, _results;
                  _results = [];
                  for (_j = 1, _ref = labels.length; 1 <= _ref ? _j <= _ref : _j >= _ref; 1 <= _ref ? _j++ : _j--) {
                    _results.push(0);
                  }
                  return _results;
                })();
                for (_j = 0, _len1 = source.length; _j < _len1; _j++) {
                  point = source[_j];
                  index = labels.indexOf(eval("point." + $attrs.labels));
                  data[index] = eval("point." + $attrs.values);
                }
                if (data.length > 0) {
                  series.push(data);
                }
              }
            }
            return series;
          };
          plotOptions = {
            grid: {
              background: '#ffffff',
              borderWidth: 0,
              shadow: false
            },
            seriesDefaults: {
              pointLabels: {
                show: true,
                formatString: $attrs.currency ? "" + $attrs.currency + "%01.2f" : null
              },
              renderer: $.jqplot.BarRenderer,
              rendererOptions: {
                barPadding: 2,
                barMargin: 5,
                fillToZero: true
              },
              shadow: false
            },
            series: [
              {
                color: '#3594a6'
              }
            ]
          };
          if ($attrs.tooltips != null) {
            plotOptions.highlighter = {
              useAxesFormatters: false,
              tooltipFormatString: $attrs.currency ? "" + $attrs.currency + "%01.2f" : null,
              show: true,
              sizeAdjust: 7.5
            };
          }
          if ($attrs.legends != null) {
            plotOptions.legend = {
              show: true,
              labels: eval("$scope." + $attrs.legends + "()")
            };
          }
          categoryAxis = {
            renderer: $.jqplot.CategoryAxisRenderer,
            tickOptions: {
              showGridline: false
            }
          };
          valueAxis = {
            tickOptions: {
              formatString: $attrs.currency ? "" + $attrs.currency + "%01d" : null
            }
          };
          if ($attrs.direction === 'horizontal') {
            plotOptions.seriesDefaults.rendererOptions.barDirection = 'horizontal';
            plotOptions.seriesDefaults.pointLabels.location = 'e';
            if ($attrs.tooltips != null) {
              plotOptions.highlighter.tooltipAxes = 'x';
            }
            plotOptions.axes = {
              xaxis: valueAxis,
              yaxis: categoryAxis
            };
          } else {
            categoryAxis.tickRenderer = $.jqplot.CanvasAxisTickRenderer;
            categoryAxis.tickOptions.angle = -30;
            plotOptions.seriesDefaults.pointLabels.location = 'n';
            if ($attrs.tooltips != null) {
              plotOptions.highlighter.tooltipAxes = 'y';
            }
            plotOptions.axes = {
              xaxis: categoryAxis,
              yaxis: valueAxis
            };
          }
          if ($attrs.hideValues != null) {
            plotOptions.seriesDefaults.pointLabels.show = false;
          }
          plot = null;

          /*
          custom redraw function as jqplot.replot(resetAxes: true) does not allow
          for media queries causing font size changes in the axes.
           */
          redraw = function(data) {
            if (plot != null) {
              plot.destroy();
            }
            if (data.length !== 0) {
              return plot = $.jqplot($attrs.id, data, plotOptions);
            }
          };
          $scope.$watchCollection($attrs.source, function(value) {
            var data, labels;
            labels = getLabels(value);
            data = getValues(value, labels);
            if ($attrs.direction === 'horizontal') {
              plotOptions.axes.yaxis.ticks = labels;
            } else {
              plotOptions.axes.xaxis.ticks = labels;
            }
            if ($attrs.legends != null) {
              plotOptions.legend.labels = eval("$scope." + $attrs.legends + "()");
            }
            return redraw(data);
          });
          return $($window).on('debouncedresize', function() {
            return redraw(plot != null ? plot.data : void 0);
          });
        }
      };
    }
  ]);

}).call(this);

//# sourceMappingURL=charts.js.map
