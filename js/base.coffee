###
  一张游戏画布，就是一个table。table中的td就相当于一个像素点，点亮td中的div来画画。
         _==/          i     i          \==_
       /XX/            |\___/|            \XX\
     /XXXX\            |XXXXX|            /XXXX\
    |XXXXXX\_         _XXXXXXX_         _/XXXXXX|
   XXXXXXXXXXXxxxxxxxXXXXXXXXXXXxxxxxxxXXXXXXXXXXX
  |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX|
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX|
   XXXXXX/^^^^"\XXXXXXXXXXXXXXXXXXXXX/^^^^^\XXXXXX
    |XXX|       \XXX/^^\XXXXX/^^\XXX/       |XXX|
      \XX\       \X/    \XXX/    \X/       /XX/
         "\       "      \X/      "      /"
###
tblHeight = 21
tblWeight = 68
tdHt = 30
tdWt = 30

$.fn.extend
  createMap: (height, weight) ->
    tblMap = "<table class='base-map'><tbody>"
    while height--
      tdCount = weight
      tblMap += "<tr>"
      while tdCount-- then tblMap += "<td><div>&nbsp;</div></td>"
      tblMap += "</tr>"
    tblMap += "</tbody></table>"
    $(this).append tblMap

$(document).ready ->
  tblHeight = parseInt($(window).height() / tdHt)
  tblWeight = parseInt($(window).width() / tdWt)
  $("body").createMap(tblHeight, tblWeight)