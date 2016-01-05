'use strict'

angular.module('smartRegisterApp')
  .directive('barChart', ['$filter', '$window', ($filter, $window) ->
    template: '<figure class="bar-chart"><figcaption ng-transclude></figcaption><div class="chart"></div></figure>'
    replace: true
    restrict: 'E'
    transclude: true
    link: ($scope, $element, $attrs) ->

      # jqplot requires an id on the chart element
      $element.find('.chart').attr('id', $attrs.id)

      # function that extracts labels from the source data
      getLabels = (sources) ->
        categories = []
        if sources?
          for source in sources
            for point in source
              category = eval "point.#{$attrs.labels}"
              categories.push(category) unless category in categories
        categories

      # function that converts the source data into series for jqplot
      getValues = (sources, labels) ->
        series = []
        if sources?
          for source in sources
            data = (0 for [1..labels.length])
            for point in source
              index = labels.indexOf eval("point.#{$attrs.labels}")
              data[index] = eval("point.#{$attrs.values}")
            series.push data if data.length > 0
        series

      # standard options for jqplot
      plotOptions =
        grid:
          background: '#ffffff'
          borderWidth: 0
          shadow: false
        seriesDefaults:
          pointLabels:
            show: true
            formatString: if $attrs.currency then "#{$attrs.currency}%01.2f" else null
          renderer: $.jqplot.BarRenderer
          rendererOptions:
            barPadding: 2
            barMargin: 5
            fillToZero: true
          shadow: false
        series: [
          color: '#3594a6'
        ]

      if $attrs.tooltips?
        plotOptions.highlighter =
          useAxesFormatters: false
          tooltipFormatString: if $attrs.currency then "#{$attrs.currency}%01.2f" else null
          show: true
          sizeAdjust: 7.5

      if $attrs.legends?
        plotOptions.legend =
          show: true
          labels: eval "$scope.#{$attrs.legends}()"

      # these axes are interchangeable depending on orientation of chart
      categoryAxis =
        renderer: $.jqplot.CategoryAxisRenderer
        tickOptions:
          showGridline: false

      valueAxis =
        tickOptions:
          formatString: if $attrs.currency then "#{$attrs.currency}%01d" else null

      # determine chart orientation
      if $attrs.direction is 'horizontal'
        plotOptions.seriesDefaults.rendererOptions.barDirection = 'horizontal'
        plotOptions.seriesDefaults.pointLabels.location = 'e'
        plotOptions.highlighter.tooltipAxes = 'x' if $attrs.tooltips?
        plotOptions.axes =
          xaxis: valueAxis
          yaxis: categoryAxis
      else
        categoryAxis.tickRenderer = $.jqplot.CanvasAxisTickRenderer
        categoryAxis.tickOptions.angle = -30

        plotOptions.seriesDefaults.pointLabels.location = 'n'
        plotOptions.highlighter.tooltipAxes = 'y' if $attrs.tooltips?
        plotOptions.axes =
          xaxis: categoryAxis
          yaxis: valueAxis

      # optionally hide point labels
      plotOptions.seriesDefaults.pointLabels.show = false if $attrs.hideValues?

      plot = null

      ###
      custom redraw function as jqplot.replot(resetAxes: true) does not allow
      for media queries causing font size changes in the axes.
      ###
      redraw = (data) ->
        plot.destroy() if plot?
        plot = $.jqplot($attrs.id, data, plotOptions) unless data.length is 0

      # redraw the chart when the data changes
      $scope.$watchCollection $attrs.source, (value) ->
        labels = getLabels(value)
        data = getValues(value, labels)

        if $attrs.direction is 'horizontal'
          plotOptions.axes.yaxis.ticks = labels
        else
          plotOptions.axes.xaxis.ticks = labels

        if $attrs.legends?
          plotOptions.legend.labels = eval "$scope.#{$attrs.legends}()"

        redraw data

      # redraw the chart when the window resizes
      $($window).on 'debouncedresize', ->
        redraw plot?.data
  ])
