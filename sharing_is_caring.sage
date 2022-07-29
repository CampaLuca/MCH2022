from sage.all import *
from Crypto.Util.number import long_to_bytes

# the points

x0  = ZZ("2740898742966601935114133183106529")
y0 = ZZ("956157655799717714864508073016211621761609346753693883071835634336701162346899667843127478623689609421921959757635162027164435651849444039861798305449805669806060897098677034940051454923858123316418111771244842263136200150949")
x1 = ZZ("4681515083705154508573047498744706")
y1 = ZZ("8137729467373933116892508790883965853824225864544185629594304843306928863961691391715058478012421229999432914675335993933647800020626034683613711997688036772875553560302624022039862210798719189229119735618787699810723188634719")
x2 = ZZ("713083567420521725647105281913383")
y2 = ZZ("4380455310144784872605974709167150361708365833979536574950088299593054964905207611091625844071796262320158274849703026573280865132707680730814638177402685313693168998262565678693098484143079216308958193534983606222931969247")


"""
CVP solver
:param B: the matrix
:param target: the target vector
"""
def Babai_closest_vector(B, target):
    # Babai's Nearest Plane algorithm
    M = B.LLL()
    G = M.gram_schmidt()[0]
    small = target
    for _ in range(1):
        for i in reversed(range(M.nrows())):
            c = ((small * G[i]) / (G[i] * G[i])).round()
            small -= M[i] * c
    return target - small

"""
Scaling performed with division
"""
def solution1():
    D = 2^200
    B = matrix(
        [
        [1   , 1   , 1,      1/D,0,0,0,0],
        [x0  , x1  , x2,     0,1/D,0,0,0],
        [x0^2, x1^2, x2^2,   0,0,1/D,0,0],
        [x0^3, x1^3, x2^3,   0,0,0,1/D,0],
        [x0^4, x1^4, x2^4,   0,0,0,0,1/D], 
        ])
    target_vector  = vector([y0, y1, y2, 0, 0, 0, 0, 0])
    
    result = Babai_closest_vector(B, target_vector)
    result = result * D
    a0, a1, a2, a3, a4 = result[3:]
    print(long_to_bytes(int(a0)))


"""
Scaling performed with multiplication
"""
def solution2():
    D = 2^200
    B = matrix(
    [
    
        [D*1   , D*1   , D* 1,   1,0,0,0,0],
        [D*x0  , D*x1  , D*x2,   0,1,0,0,0],
        [D*x0^2, D*x1^2, D*x2^2, 0,0,1,0,0],
        [D*x0^3, D*x1^3, D*x2^3, 0,0,0,1,0],
        [D*x0^4, D*x1^4, D*x2^4, 0,0,0,0,1], 
    ])

    target_vector  = vector([D*y0, D*y1, D*y2,0, 0, 0, 0, 0])
    result = Babai_closest_vector(B, target_vector)
    a0, a1, a2, a3, a4 = result[3:]
    print(long_to_bytes(int(a0)))


"""
By using sagemath LLL
"""
def solution3(): 
    D = 2^200
    B = matrix(
    [
        [D*1   , D*1   , D* 1,   1,0,0,0,0,0],
        [D*x0  , D*x1  , D*x2,   0,1,0,0,0,0],
        [D*x0^2, D*x1^2, D*x2^2, 0,0,1,0,0,0],
        [D*x0^3, D*x1^3, D*x2^3, 0,0,0,1,0,0],
        [D*x0^4, D*x1^4, D*x2^4, 0,0,0,0,1,0], 
        [D*-y0,  D*-y1, D*-y2,   0,0,0,0,0,1],
    ])

    base = B.LLL()
    for lista in B.LLL():
     a0, a1, a2, a3, a4, k = lista[3:]
     if k == 1:
         print(long_to_bytes(a0))


solution1()
solution2()
solution3()