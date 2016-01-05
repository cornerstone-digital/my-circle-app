'use strict'

map = (element, fn) ->
  arr = []
  angular.forEach element, (it) ->
    arr.push fn(angular.element(it))
  arr

describe 'Directive: barChart', ->
  beforeEach module 'mockEnvironment', 'smartRegisterApp', 'views/faq.html', 'views/login.html'

  beforeEach ->
    @element = undefined

    # retrieves the x-axis labels from the chart
    @xAxisLabels = ->
      map @element.find('.jqplot-xaxis-tick'), (it) -> it.text()

    # retrieves the y-axis labels from the chart
    @yAxisLabels = ->
      map @element.find('.jqplot-yaxis-tick'), (it) -> it.text()

    @pointLabels = (series = 1) ->
      map @element.find(".jqplot-point-label.jqplot-series-#{series - 1}"), (it) -> it.text()

  afterEach ->
    @element.remove()

  describe 'drawing a bar chart', ->

    describe 'with a single data series', ->
      beforeEach inject ($rootScope) ->
        series = [
          key: 'a', value: 1
        ,
          key: 'b', value: 3
        ,
          key: 'c', value: 10
        ]
        $rootScope.data = [series]

      describe 'with numeric values', ->
        beforeEach inject ($rootScope, $compile) ->
          @element = angular.element '<bar-chart source="data" labels="key" values="value" data-id="chart1"><h3>The Caption</h3></bar-chart>'
          @element = $compile(@element) $rootScope
          @element.appendTo(document.body)
          $rootScope.$digest()

        it 'should replace the element with a figure', ->
          expect(@element[0].tagName).toBe 'FIGURE'

        it 'should assign an id to the chart element', ->
          expect(@element.attr('id')).toBeUndefined()
          expect(@element.find('.jqplot-target').attr('id')).toBe 'chart1'

        it 'should contain a caption with the transcluded content', ->
          captionElement = @element.children().eq(0)
          expect(captionElement[0].tagName).toBe 'FIGCAPTION'
          expect(captionElement.children()[0].tagName).toBe 'H3'
          expect(captionElement.text()).toBe 'The Caption'

        it 'should use the data points for the chart data', ->
          expect(@pointLabels()).toBeEqualSet ['1', '3', '10']

        it 'should use the values for the y axis labels', ->
          expect(@yAxisLabels()).toEqual ['0', '2', '4', '6', '8', '10', '12']

        it 'should use the keys for the x axis labels', ->
          expect(@xAxisLabels()).toEqual ['a', 'b', 'c']

        describe 'when the source data changes', ->
          beforeEach inject ($rootScope) ->
            series = [
              key: 'x', value: 2
            ,
              key: 'y', value: 6
            ,
              key: 'z', value: 20
            ]
            $rootScope.data = [series]
            $rootScope.$digest()

          it 'should update the chart', ->
            expect(@xAxisLabels()).toEqual ['x', 'y', 'z']
            expect(@yAxisLabels()).toEqual ['0', '5', '10', '15', '20', '25']

        describe 'when the source data is removed', ->
          beforeEach inject ($rootScope) ->
            $rootScope.data = []
            $rootScope.$digest()

          it 'should clear the chart', ->
            expect(@xAxisLabels()).toEqual []
            expect(@yAxisLabels()).toEqual []
            expect(@pointLabels()).toEqual []

      describe 'with hidden values', ->
        beforeEach inject ($rootScope, $compile) ->
          @element = angular.element '<bar-chart source="data" labels="key" values="value" data-id="chart1" hide-values/>'
          @element = $compile(@element) $rootScope
          @element.appendTo(document.body)
          $rootScope.$digest()

        it 'should display the y axis labels as currency strings', ->
          expect(@pointLabels()).toEqual []

      describe 'with currency values', ->
        beforeEach inject ($rootScope, $compile) ->
          @element = angular.element '<bar-chart source="data" labels="key" values="value" data-id="chart1" currency="&#163;"/>'
          @element = $compile(@element) $rootScope
          @element.appendTo(document.body)
          $rootScope.$digest()

        it 'should display the y axis labels as currency strings', ->
          expect(@yAxisLabels()).toEqual ['£0', '£2', '£4', '£6', '£8', '£10', '£12']

      describe 'displayed horizontally', ->
        beforeEach inject ($rootScope, $compile) ->
          @element = angular.element '<bar-chart source="data" labels="key" values="value" data-id="chart1" direction="horizontal"/>'
          @element = $compile(@element) $rootScope
          @element.appendTo(document.body)
          $rootScope.$digest()

        it 'should use the values for the x axis labels', ->
          expect(@xAxisLabels()).toEqual ['0', '2', '4', '6', '8', '10', '12']

        it 'should use the keys for the y axis labels', ->
          expect(@yAxisLabels()).toEqual ['a', 'b', 'c']

      describe 'with a legend', ->
        beforeEach inject ($rootScope, $compile) ->
          $rootScope.foo = -> ['legend label 1']

          @element = angular.element '<bar-chart source="data" labels="key" values="value" data-id="chart1" legends="foo"/>'
          @element = $compile(@element) $rootScope
          @element.appendTo(document.body)
          $rootScope.$digest()

        it 'should display a legend', ->
          expect(@element.find('.jqplot-table-legend-label').text()).toBe 'legend label 1'

    describe 'with multiple data series', ->

      describe 'with the same keys', ->
        beforeEach inject ($rootScope, $compile) ->
          series1 = [
            key: 'a', value: 1
          ,
            key: 'b', value: 3
          ,
            key: 'c', value: 10
          ]
          series2 = [
            key: 'a', value: 2
          ,
            key: 'b', value: 6
          ,
            key: 'c', value: 20
          ]
          $rootScope.data = [series1, series2]

          @element = angular.element '<bar-chart source="data" labels="key" values="value" data-id="chart1"/>'
          @element = $compile(@element) $rootScope
          @element.appendTo(document.body)
          $rootScope.$digest()

        it 'should use the data points for the chart data', ->
          expect(@pointLabels(1)).toBeEqualSet ['1', '3', '10']
          expect(@pointLabels(2)).toBeEqualSet ['2', '6', '20']

        it 'should use the values for the y axis labels', ->
          expect(@yAxisLabels()).toEqual ['0', '5', '10', '15', '20', '25']

        it 'should use the keys for the x axis labels', ->
          expect(@xAxisLabels()).toEqual ['a', 'b', 'c']

      describe 'with different keys', ->
        beforeEach inject ($rootScope, $compile) ->
          series1 = [
            key: 'a', value: 1
          ,
            key: 'b', value: 3
          ,
            key: 'c', value: 10
          ]
          series2 = [
            key: 'a', value: 2
          ,
            key: 'x', value: 6
          ,
            key: 'y', value: 20
          ]
          $rootScope.data = [series1, series2]

          @element = angular.element '<bar-chart source="data" labels="key" values="value" data-id="chart1"/>'
          @element = $compile(@element) $rootScope
          @element.appendTo(document.body)
          $rootScope.$digest()

        it 'should use the data points for the chart data', ->
          expect(@pointLabels(1)).toBeEqualSet ['1', '3', '10', '0', '0']
          expect(@pointLabels(2)).toBeEqualSet ['2', '0', '0', '6', '20']

        it 'should use the values for the y axis labels', ->
          expect(@yAxisLabels()).toEqual ['0', '5', '10', '15', '20', '25']

        it 'should use the keys for the x axis labels', ->
          expect(@xAxisLabels()).toEqual ['a', 'b', 'c', 'x', 'y']

      describe 'with an empty series', ->
        beforeEach inject ($rootScope, $compile) ->
          series1 = [
            key: 'a', value: 1
          ,
            key: 'b', value: 3
          ,
            key: 'c', value: 10
          ]
          series2 = []
          $rootScope.data = [series1, series2]

          @element = angular.element '<bar-chart source="data" labels="key" values="value" data-id="chart1"/>'
          @element = $compile(@element) $rootScope
          @element.appendTo(document.body)
          $rootScope.$digest()

        it 'should default bar values to zero for the empty series', ->
          expect(@pointLabels(1)).toBeEqualSet ['1', '3', '10']
          expect(@pointLabels(2)).toBeEqualSet ['0', '0', '0']

    describe 'with no data series', ->
      beforeEach inject ($rootScope, $compile) ->
        $rootScope.data = []

        @element = angular.element '<bar-chart source="data" labels="key" values="value" data-id="chart1"/>'
        @element = $compile(@element) $rootScope
        @element.appendTo(document.body)
        $rootScope.$digest()

      it 'should not render any data', ->
        expect(@pointLabels(1)).toBeEqualSet []
