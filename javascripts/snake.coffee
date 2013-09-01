###
  蛇围绕画布边缘移动（围观），蛇的身体在td间移动。怎么移动的呢？点亮td中的div。
                    /^\/^\
                  _|__|  O|
         \/     /~     \_/ \
          \____|__________/  \
                 \_______      \
                         `\     \                 \
                           |     |                  \
                          /      /                    \
                         /     /                       \\
                       /      /                         \ \
                      /     /                            \  \
                    /     /             _----_            \   \
                   /     /           _-~      ~-_         |   |
                  (      (        _-~    _--_    ~-_     _/   |
                   \      ~-____-~    _-~    ~-_    ~-_-~    /
                     ~-_           _-~          ~-_       _-~
                        ~--______-~                ~-___-~
###
snakeLen = 18
speed = 100
speedLevel = "slow"
LEFT = 0
BOTTOM = 1
RIGHT = 2
TOP = 3

class Item extends Backbone.Model

class Snake extends Backbone.Collection
  model: Item

$.extend
  move: (index, item) ->
    if $(item).hasClass("item0")
      $(item).hide speedLevel, ->
        $(@).removeClass().removeData("item")
    else
      newItemNum = $(item).data("item") - 1
      $(item).removeClass().addClass("snake item" + newItemNum).data("item", newItemNum)
  reverseDom: (oldDomList) ->
    arr = oldDomList.toArray()
    len = arr.length
    newDomList = []
    while len-- then newDomList.push arr[len]
    return $(newDomList)

$.fn.extend
  createSnake: (len) ->
    count = 1
    while len--
      itemNum = snakeLen - count++
      $(@).eq(len).find("div").addClass("item#{itemNum} snake").data("item", itemNum).show()
  moveSnake: ->
    $(@).find("div.snake").each (i, item) ->
      $.move(i, item)
  findSnakeHead: ->
    $(@).find("div.item#{snakeLen - 1}").closest("td")
  createSnakeHead: ->
    $(@).find("div").addClass("snake item#{snakeLen}").data("item", snakeLen).show()
  filterSnakeBody: ->
    $(@).filter(":lt(#{$(@).size() - 1})")
  findSnakeItemCount: ->
    $(@).find("div.snake").size()

class SnakeView extends Backbone.View
  tagName: "div"
  className: "snake"
  initialize: ->
    _.bindAll @, "render", "moveLeft", "moveBottom"
    @direction = LEFT
    @$tblMap = $("table.base-map>tbody")
    @$leftRoad = @$tblMap.find "tr:first>td"
    @$bottomRoad = @$tblMap.find("tr").find "td:last"
    @$rightRoad = $.reverseDom(@$tblMap.find("tr:last>td"))
    @$topRoad = $.reverseDom(@$tblMap.find("tr").find "td:first")
    len = snakeLen
    @collection = new Snake()
    while len-- then @collection.add new Item()
    @render()
  render: ->
    @$leftRoad.createSnake(snakeLen)
  moveCtrl: ->
    if @direction is LEFT then @moveLeft()
    else if @direction is BOTTOM then @moveBottom()
    else if @direction is RIGHT then @moveRight()
    else if @direction is TOP then @moveTop()
  moveLeft: ->
    @$topRoad.filterSnakeBody().moveSnake() if @$topRoad.findSnakeItemCount()
    $oldHeadTd = @$leftRoad.findSnakeHead()
    $newHeadTd = $oldHeadTd.next()
    $newHeadTd.createSnakeHead()
    @$leftRoad.moveSnake()
    if not $newHeadTd.size()
      @direction = BOTTOM
      @$bottomRoad.createSnake(2)
  moveBottom: ->
    @$leftRoad.filterSnakeBody().moveSnake() if @$leftRoad.findSnakeItemCount()
    $oldHeadTd = @$bottomRoad.findSnakeHead()
    $newHeadTd = $oldHeadTd.closest("tr").next().find("td:last")
    $newHeadTd.createSnakeHead()
    @$bottomRoad.moveSnake()
    if not $newHeadTd.size()
      @direction = RIGHT
      @$rightRoad.createSnake(2)
  moveRight: ->
    @$bottomRoad.filterSnakeBody().moveSnake() if @$bottomRoad.findSnakeItemCount()
    $oldHeadTd = @$rightRoad.findSnakeHead()
    $newHeadTd = $oldHeadTd.prev()
    $newHeadTd.createSnakeHead()
    @$rightRoad.moveSnake()
    if not $newHeadTd.size()
      @direction = TOP
      @$topRoad.createSnake(2)
  moveTop: ->
    @$rightRoad.filterSnakeBody().moveSnake() if @$rightRoad.findSnakeItemCount()
    $oldHeadTd = @$topRoad.findSnakeHead()
    $newHeadTd = $oldHeadTd.closest("tr").prev().find("td:first")
    $newHeadTd.createSnakeHead()
    @$topRoad.moveSnake()
    if not $newHeadTd.size()
      @direction = LEFT
      @$leftRoad.createSnake(2)

$(document).ready ->
  view = new SnakeView()
  window.setInterval ->
   view.moveCtrl()
  , speed