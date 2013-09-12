class Clouds
  @objects = []
  @layers = []
  @worldXAngle: 0
  @worldYAngle: 0
  @world: document.getElementById('world')
  @d: 0
  @p: 400
  constructor : -> 
    @viewport = document.getElementById('viewport') 
    viewport.style.webkitPerspective = Clouds.p
    viewport.style.MozPerspective = Clouds.p
    viewport.style.oPerspective = Clouds.p
    @generate() 
    window.addEventListener 'mousemove', (e) ->
      Clouds.worldYAngle = -( .5 - ( e.clientX / window.innerWidth ) ) * 180
      Clouds.worldXAngle = ( .5 - ( e.clientY / window.innerHeight ) ) * 180
      d = 0
      Clouds.updateView()
    window.addEventListener 'mousewheel', @onContainerMouseWheel
    window.addEventListener 'DOMMouseScroll', @onContainerMouseWheel 
  update : ->     
    for j in [0...Clouds.layers.length]
      layer = Clouds.layers[j]
      layer.data.a += layer.data.speed
      t = 'translateX( ' + layer.data.x + 'px ) translateY( ' + layer.data.y + 'px ) translateZ( ' + layer.data.z + 'px ) rotateY( ' + ( - Clouds.worldYAngle ) + 'deg ) rotateX( ' + ( - Clouds.worldXAngle ) + 'deg ) rotateZ( ' + layer.data.a + 'deg ) scale( ' + layer.data.s + ')'
      layer.style.webkitTransform = t
      layer.style.MozTransform = t
      layer.style.oTransform = t 
    requestAnimationFrame(@update())
  @updateView : -> 
    world = document.getElementById('world')
    t = 'translateZ( ' + @d + 'px ) \ rotateX( ' + @worldXAngle + 'deg) \ rotateY( ' + @worldYAngle + 'deg)'
    world.style.transform = t
    world.style.webkitTransform = t
    world.style.MozTransform = t
    world.style.oTransform = t
  onContainerMouseWheel : (event) ->            
    event = event ? event : window.event
    d = d - (event.detail ? event.detail * -5 : event.wheelDelta / 8 )
    @updateView()
  generate : -> 
    if world.hasChildNodes()
        while world.childNodes.length >= 1 
            world.removeChild(world.firstChild)       
    Clouds.objects.push @createCloud()
  createCloud : () -> 
    div = document.createElement('div')
    div.className+='cloudBase'
    x = 256 - ( Math.random() * 512 )
    y = 256 - ( Math.random() * 512 )
    z = 256 - ( Math.random() * 512 )
    t = 'translateX( ' + x + 'px ) translateY( ' + y + 'px ) translateZ( ' + z + 'px )'
    div.style.webkitTransform = t
    div.style.MozTransform = t
    div.style.oTransform = t
    world.appendChild(div)
    for j in [0...5+Math.round(Math.random() * 10)]
      cloud = document.createElement('img')
      cloud.style.opacity = 0.8
      r = Math.random()
      src = 'http://www.clicktorelease.com/blog/css3dclouds/cloud.png'
      cloud.addEventListener 'load',->
        cloud.style.opacity = .8
      cloud.setAttribute 'src',src
      cloud.className = 'cloudLayer'
      x = 256 - ( Math.random() * 512 )
      y = 256 - ( Math.random() * 512 )
      z = 100 - ( Math.random() * 200 )
      a = Math.random() * 360
      s = .25 + Math.random()
      x *= .2
      y *= .2
      cloud.data = {x: x,y: y,z: z,a: a,s: s,speed: .1 * Math.random()}
      t = 'translateX( ' + x + 'px ) translateY( ' + y + 'px ) translateZ( ' + z + 'px ) rotateZ( ' + a + 'deg ) scale( ' + s + ' )'
      cloud.style.webkitTransform = t
      cloud.style.MozTransform = t
      cloud.style.oTransform = t
      div.appendChild cloud
      Clouds.layers.push cloud
    return div
$ -> 
  cloud=new Clouds()
  cloud.update()
  