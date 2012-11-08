ab = new vec2();  bc = new vec2()
ca = new vec2();  ap = new vec2()
bp = new vec2();  cp = new vec2()

# POINT IN TRIANGLE
#
# Walk around the edges and determine if
# p is to the left or right of each edge.
# If the answer is the same for all 3 edges,
# then the point is inside.
#
pointInTri = (p, tri) ->
  ab.sub tri[1], tri[0]
  bc.sub tri[2], tri[1]
  ca.sub tri[0], tri[2]
  ap.sub p, tri[0]
  bp.sub p, tri[1]
  cp.sub p, tri[2]
  a = ab.cross ap
  b = bc.cross bp
  c = ca.cross cp
  return true if a < 0 and b < 0 and c < 0
  return true if a > 0 and b > 0 and c > 0
  false

# MAIN EAR CLIPPING ALGORITHM
#
# This is an n-squared algorithm but at least
# it's nice and simple.
#
triangulate = (pts) ->

  # First find all reflex verts
  reflex = []
  concave = []
  for b, ncurr in pts
    nprev = (ncurr + pts.length - 1) % pts.length
    nnext = (ncurr + 1) % pts.length
    a = pts[nprev]
    c = pts[nnext]
    ab.sub b, a
    bc.sub c, a
    ca.sub a, c
    reflex.push ncurr

  # Next find all ears.
  ears = []
  for ncurr in reflex
    nprev = (ncurr + pts.length - 1) % pts.length
    nnext = (ncurr + 1) % pts.length
    triangle = [nprev, ncurr, nnext]
    tricoords = (pts[i] for i in triangle)
    isEar = true
    for ocoord, oindex in pts
      continue if oindex in triangle
      if pointInTri ocoord, tricoords
        isEar = false
        break
    if isEar
      ears.push ncurr

  console.info "prideout"
  console.info "prideout ears    #{ears}"
  console.info "prideout reflex  #{reflex}"
  console.info "prideout concave #{concave}"

  indices = []
  indices

module.exports = triangulate