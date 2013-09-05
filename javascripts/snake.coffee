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
map = "table.base-map>tbody"

$.extend
  # 倒序jQuery DOM数组对象
  reverseDom: (oldDomList) ->
    arr = oldDomList.toArray()
    len = arr.length
    newDomList = []
    while len-- then newDomList.push arr[len]
    $ newDomList

$.fn.extend
  # 取得 index > 0 的数组
  getRealRoad: ->
    $(@).filter ":gt(0)"

class Item extends Backbone.Model

class Snake extends Backbone.Collection
  model: Item

class SnakeView extends Backbone.View
  tagName: "div"
  className: "snake"
  initialize: ->
    _.bindAll @, "render", "move", "letsgo"
    $tblMap = $ map
    $leftRoad = $tblMap.find("tr:first>td").getRealRoad()
    $bottomRoad = $tblMap.find("tr").find("td:last").getRealRoad()
    $rightRoad = $.reverseDom($tblMap.find("tr:last>td")).getRealRoad()
    $topRoad = $.reverseDom($tblMap.find("tr").find("td:first")).getRealRoad()
    # 星光大道
    @$road = $.merge($.merge($.merge($leftRoad, $bottomRoad), $rightRoad), $topRoad).addClass "snake-road"
    #@$road = $bottomRoad
    # 蛇蛇从石头里蹦出来了
    len = snakeLen
    @collection = new Snake()
    while len-- then @collection.add new Item()
    @render()
  # 在表格中创建一条蛇蛇
  render: ->
    len = @collection.length
    while len--
      @$road.eq(len).find("div").addClass("item#{len} snake").data("item", len).css("visibility", "visible")
  # 蛇蛇跑起来
  letsgo: ->
    move = @move
    setInterval ->
      move()
    , speed
  # 蛇蛇向前移动一步
  move: ->
    $oldHead = @$road.find("div.item#{@collection.length - 1}").parent()
    oldIndex = @$road.index($oldHead)
    $newHead = @$road.eq(oldIndex + 1)
    $newHead.find("div").addClass("snake item#{@collection.length}").data("item", @collection.length).css("visibility", "visible")
    @$road.find("div.snake").each ->
      if $(@).hasClass("item0")
        $(@).hide speedLevel, ->
          $(@).css({"visibility":"hide","display":"block"}).removeClass().removeData("item")
      else
        newItemNum = $(@).data("item") - 1
        $(@).removeClass().addClass("snake item" + newItemNum).data("item", newItemNum)

$(document).ready ->
  view = new SnakeView()
  view.letsgo()