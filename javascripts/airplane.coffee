###
  开飞机的苏克，开启写轮眼“摇一摇”。~~~~(>_<)~~~~
                   |
                   |
              ___-/_\-___
   _____________/( . )\_____________
  *    |    |  (  \_/  )  |    |    *
      *|*  *|*  \_-+-_/  *|*  *|*
###
map = "table.base-map>tbody"

$.fn.extend
  forward: (i) ->
    $tr = $(@)
    $ball = $tr.find("td:eq(#{i})>div").addClass("ball").css("visibility", "visible")
    $ball.fadeOut 100, ->
      $(@).removeClass().css("visibility", "hide")
      if $tr.prev()? then $tr.prev().forward(i)


class Airplane extends Backbone.Model
  defaults: {
    airplaneSeat: 0
  }

class AirplaneView extends Backbone.View
  tagName: "div"
  className: "airplane"
  initialize: ->
    _.bindAll @, "render", "moveLeft", "moveRight", "shot"
    $tblMap = $ map
    trCount = $tblMap.find("tr").size()
    tdCount = $tblMap.find("tr:first td").size()
    @$airplaneTr = $tblMap.find("tr:gt(#{trCount - 7})").filter("tr:lt(5)")
    #@$airplaneRoad = @$airplaneTr.find("td")
    @model = new Airplane({airplaneSeat: parseInt(tdCount / 2) - 4})
    @render()
  render: ->
    seat = @model.get("airplaneSeat")
    @$airplaneTr.each (i, tr) ->
      $matrix = $(tr).find("td:gt(#{seat})").filter("td:lt(5)")
      $matrix.addClass "airplane-matrix"
      $matrix.eq(2).addClass "airplane" if i is 1
      $matrix.filter("td:gt(0)").filter("td:lt(3)").addClass "airplane" if i is 2
      $matrix.addClass "airplane" if i is 3
      $matrix.filter("td:gt(0)").filter("td:lt(3)").addClass "airplane" if i is 4
  moveLeft: (selector) ->
    flag = true
    selector = @className if selector is undefined
    @$airplaneTr.each ->
      $matrix = $(@).find("td.#{selector}")
      $newTd = $matrix.first().prev()
      if $newTd.hasClass("snake-road")
        flag = false
        return false
      else
        $newTd.addClass selector
        $matrix.last().removeClass selector
    return flag
  moveRight: (selector) ->
    flag = true
    selector = @className if selector is undefined
    @$airplaneTr.each ->
      $matrix = $(@).find("td.#{selector}")
      $newTd = $matrix.last().next()
      if $newTd.hasClass("snake-road")
        flag = false
        return false
      else
        $newTd.addClass selector
        $matrix.first().removeClass selector
    return flag
  shot: ->
    $gun = @$airplaneTr.eq(1).find("td.#{@className}")
    $tr = $gun.closest("tr")
    $tdRow = $tr.find("td")
    column = $tdRow.index($gun)
    $tr.prev().forward(column)

$(document).ready ->
  view = new AirplaneView()
  $(window).keydown (e) ->
    if e.keyCode is 37 # left
      if view.moveLeft "airplane-matrix" then view.moveLeft()
    else if e.keyCode is 39 # right
      if view.moveRight "airplane-matrix" then view.moveRight()
    else if e.keyCode is 32 # space
      view.shot()